#
#
#This is the make file for the model
#
# Program Name
PROG =SWE.exe

#SOurce folder name
VPATH=src

#object folder
OBJDIR=objs

# module folder
MODDIR=mods

# Executable folder
EXECDIR=exec


# compiler and flags # the medium flag is used to avoid segmentation fault
# the -g flag indicates debug  und the usr/inlcude is the path to the netcfd install folder
FC = gfortran
FFLAGS = -c -O3 -mcmodel=medium #-g -I/usr/include
#FLINK = -O3 #-mcmodel=medium -g -I/usr/include
FLINK = -O3 -mcmodel=medium #-g -L/usr/lib 
LINKER = $(FC) -o

# $< will point the first file in the dependency chain
# $@ will point the last file in the dependency  chain

# Object files
OBJS = initializer.o swe_rk4.o main.o parameters.o fileSave.o

model: $(PROG)

# Creates the model
$(PROG):$(OBJS)
	@echo "-------------------------------------"
	@echo "Creating the executable for the model"
	@echo "-------------------------------------"
	$(LINKER) $(PROG) $(OBJS) $(FLINK)
	# mv *.o $(OBJDIR)
	# mv *.mod $(MODDIR)
	# mv *.exe $(EXECDIR)

%.o:%.f95
	@echo "-----------------------------------"
	@echo "Compiling the file $<"
	@echo "-----------------------------------"
	$(FC) $(FFLAGS) $<

#clean up everthing
clean:
	@echo "-----------------------------"
	@echo "Cleans up everthing"
	@echo "-----------------------------"
	rm -f *~ *.nc plot*.png *.exe *.o *.mod *.dat
	rm -f $(OBJDIR)/*.o $(OBJDIR)/*~
	rm -f $(MODDIR)/*.mod $(MODDIR)/*~
	
	rm -f $(EXECDIR)/*~ $(EXECDIR)/*.exe $(EXECDIR)/*.nc
	rm -f $(VPATH)/*~

initializer.o	: initializer.f95 parameters.o params.mod model_vars.mod
swe_rk4.o	: swe_rk4.f95 parameters.o
fileSave.o	: fileSave.f95 parameters.o
main.o		: main.f95 parameters.o #params.mod model_vars.mod
parameters.o	: parameters.f95
