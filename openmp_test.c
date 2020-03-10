#include <stdio.h>
#include <omp.h>

int main (void)
{
		int n;

		#pragma omp parallel for
		for ( n = 1; n <= 72; n++) {
			printf("We are in thread  number %d and are printing %d\n", omp_get_thread_num(), n);
		}


}