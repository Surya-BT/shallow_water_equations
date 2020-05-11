# remove log file
rm *.log

# remove all the files using make clean
make clean

# compile the program using make
make

# run the executable
./SWE.exe 2>&1 | tee runtime.log

# change the name of the nc datafile
mv data_small_rotation.nc $1.nc
