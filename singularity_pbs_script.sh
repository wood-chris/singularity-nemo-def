#!/bin/bash --login
# ---------------------------
#===============================================================
# CLUSTER BITS
#===============================================================
#PBS -N NEMO_eg
#PBS -l select=2:ncpus=36
#PBS -l walltime=00:02:00
##PBS -l place=scatter:excl
#PBS -A dc027

module load intel-compilers-18 netcdf-parallel gcc/6.2.0
# Change to the direcotry that the job was submitted from
cd $PBS_O_WORKDIR

# Set the number of threads to 1
#   This prevents any system libraries from automatically 
#   using threading.
export OMP_NUM_THREADS=1

# Change to the directory that the job was submitted from
ulimit -s unlimited

export NEMOproc=35
export XIOSproc=2

#===============================================================
# LAUNCH JOB
#===============================================================
echo `date` : Launch Job
uniq $PBS_NODEFILE | cut -d . -f 1 > hostfile 
hn=`sed -n 1,1p hostfile`
hx=`sed -n 2,2p hostfile`
mpirun -print-rank-map -n $NEMOproc --host $hn ./nemo : -n $XIOSproc --host $hx ./xios_server.exe 


singularity exec nemo.simg mpirun -n 1 -N 1 /nemo/nemo/cfgs/GYRE_PISCES/EXP00/nemo : -n 1 -N 1 /nemo/nemo/cfgs/GYRE_PISCES/EXP00/xios_server.exe 

exit