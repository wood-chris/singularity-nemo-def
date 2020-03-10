#!/bin/bash --login

# PBS job options (name, compute nodes, job time)
#PBS -N mpi_test
#PBS -l select=1:ncpus=8
# Parallel jobs should always specify exclusive node access
##PBS -l place=scatter:excl
#PBS -l walltime=00:01:00

# Replace [budget code] below with your project code (e.g. t01)
#PBS -A z04

cd $PBS_O_WORKDIR
#cat $PBS_NODEFILE > nodes.txt
#export OMP_NUM_THREADS=1
#aprun -n 16 python multiprocess_test.py &> stdout.txt
module load singularity/3.2.1
singularity run mpi_test.simg
