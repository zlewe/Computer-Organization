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

void simulate(int cache_size, int block_size)
{
	unsigned int tag, index, index2, x;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	cache_content *cache = new cache_content[line];
	
    cout << "cache line: " << line << " cache size: " << cache_size << " block size: " << block_size << endl;
	cout << "offset bit: " << offset_bit << " index_bit: " << index_bit << endl << endl;
	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    FILE *fp = fopen("DCACHE.txt", "r");  // read file ICACHE DCACHE
	
	int hitcount = 0;
	int misscount = 0;
	
	//cout << "add " << setw(10) << "binary add" << " " << setw(5) << "index" << " " << setw(5) << "tag" << " " << "hit" << endl;
	while(fscanf(fp, "%x", &x) != EOF)
    {
		//cout << hex << setw(3) << x << " ";
		//cout << dec << setfill('0') << setw(10) << d2b(x) << setfill(' ') <<  " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit+offset_bit);
		//cout << setw(5) << index << " " << setw(5) << tag << " ";
		if(cache[index].v && cache[index].tag == tag)
		{
			cache[index].v = true;    // hit
			hitcount++;
			//cout << setw(3) << 1 << endl;
		}
		else
        {
			cache[index].v = true;  // miss
			cache[index].tag = tag;
			misscount++;
			//cout << setw(3) << 0 << endl;
		}
	}
	fclose(fp);

	//cout << endl;
	//cout << dec << "Miss Count = " << misscount << " Hit Count = " << hitcount << endl; 
	cout << "Miss rate = " << ((double)misscount)*100/(misscount+hitcount) << endl << endl;
	
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
		
		simulate(cache*K, block);
	}

}
