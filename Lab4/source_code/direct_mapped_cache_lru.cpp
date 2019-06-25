#include <iostream>
#include <stdio.h>
#include <math.h>
#include <iomanip>
#include <vector>

using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
	int order = 0;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}

int d2b(int decimal_number) 
{ 
    if (decimal_number == 0)  
        return 0;  
    else
        return (decimal_number % 2 + 10 *  
                d2b(decimal_number / 2)); 
} 

void simulate(int cache_size, int block_size, int n){
	unsigned int tag,index,x;
	int num_block = (cache_size / block_size);
	int set = (num_block / n);
	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(set);
	int line= cache_size>>(offset_bit);
	
	cache_content *cache = new cache_content[line];

	cout << "cache line: " << line << " cache size: " << cache_size << " block size: " << block_size << " associativity: " << n << endl;
	cout << "offset bit: " << offset_bit << " index_bit: " << index_bit << endl << endl;
	cout << "total bit: " << block_size*8 + 1 + 32-index_bit-offset_bit << endl << endl;
	
	vector <int> instr_hit;
	vector <int> instr_miss;
  	FILE * fp=fopen("RADIX.txt","r");			//read file RADIX LU
	int instr = 1;
	int time_count = 1;
	while(fscanf(fp,"%x",&x)!=EOF)
	{
		index=(x>>offset_bit)&(line/n-1);
		tag=x>>(index_bit+offset_bit);
		bool hit = false;
		for(int i = 0; i < n; i ++)
		{
			if(cache[index * n + i].v && cache[index * n + i].tag == tag) //hit
			{
				instr_hit.push_back(instr);
				hit = true;
				cache[index * n + i].order = time_count;
				break;
			}		
		}
		
		if(!hit)        	//miss
		{	
			instr_miss.push_back(instr);   
			int picked_index;
			int min_order = 1e9;
			for(int i = 0; i < n; i ++)
			{	
				if(!cache[index * n + i].order)
				{
                    picked_index = i;
                    break;
                }
                else if (cache[index * n + i].order < min_order)
				{
                	picked_index = i;
                	min_order = cache[index * n + i].order;
				}
			}
			cache[index * n + picked_index].v = true;
			cache[index * n + picked_index].order = time_count;			
			cache[index * n + picked_index].tag = tag;
		}
		time_count += 1;
		instr += 1;
	}
	fclose(fp);
	double miss = ((double)(instr_miss.size())/(instr_hit.size() + instr_miss.size())) * 100;
	cout << "Miss rate = " << miss << endl << endl;
	delete [] cache;
}
	
int main()
{
	int block;
	double cache;
	int associativity;
	while(1){	
		cout << "Input cache size (0 to exit): ";
		cin >> cache;
		if(cache == 0)
			break;
		cout << "Input block size: ";
		cin >> block;
		//block = 64;
		cout << "Input associativity: ";
		cin >> associativity;
		
		
		simulate(cache*K, block, associativity);
		/*for(int i = 1; i <= 8; i*=2)
		{ 
			for (int j = 1; j <= 32; j*=2)
				simulate(j*K, block, i);
		}*/
	}

}
