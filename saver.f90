! this file is used for saving the results for future viewing

subroutine data_saver

	use netcdf
	use params
	use model_vars

	implicit none

	! number of dimensions of large variables
	integer, parameter :: NDIMS3 = 3
	integer, parameter :: NDIMS2 = 2
	integer :: ncid 	! Netcfd variable placement id

	! Dimensions names
	character(len=12),parameter :: X_NAME = 'X Distance'
	character(len=12),parameter :: Y_NAME = 'Y Distance'
	character(len=12),parameter :: T_NAME = 'T Time'

	! dimension IDs for the dimension variables
	integer :: x_dimid,y_dimid,time_id

	! size of 3D vars
	integer :: dimids3(NDIMS3)
	integer :: dimids2(NDIMS2)

	!variable names
	character(len=*),parameter :: U_NAME = 'U_velocity'
	character(len=*),parameter :: V_NAME = 'V_velocity'
	character(len=*),parameter :: H_NAME = 'H_LEVEL'
	character(len=*),parameter :: F_NAME = 'F_coriolis'

	!Units for the dimension variables
	
	character(len=*),parameter :: UNITS = 'Units'
	character(len=*),parameter :: U_UNITS = 'm/s'
	character(len=*),parameter :: V_UNITS = 'm/s'
	character(len=*),parameter :: H_UNITS = 'm'
	character(len=*),parameter :: F_UNITS = '1/s'
	character(len=*),parameter :: X_UNITS = 'meters_east'
	character(len=*),parameter :: Y_UNITS = 'meters_north'
	character(len=*),parameter :: T_UNITS = 'seconds_forward'
	

	!variables for the IDs for the variables
	integer :: u_varid,v_varid,h_varid,f_varid
	integer :: x_varid,y_varid,t_varid

	print*, "All data defined in script!"
	
	! create the file
	call check(nf90_create(path=fname,cmode=or(nf90_noclobber,nf90_64bit_offset),ncid=ncid))
!	call check(nf90_create(fname,nf90_clobber,ncid))
	write(*,*) "file created"

	! define the dimensions
	call check(nf90_def_dim(ncid,X_NAME,nx,x_dimid))
	write(*,*) "x dimension defined"
	call check(nf90_def_dim(ncid,Y_NAME,ny,y_dimid))
	write(*,*) "y dimension defined"
	call check(nf90_def_dim(ncid,T_NAME,nt,time_id))
	write(*,*) "t dimension defined"

	dimids2 = (/ x_dimid,y_dimid /)
	! Create dimension variables
	call check(nf90_def_var(ncid,X_NAME, NF90_DOUBLE,dimids2,x_varid))
	write(*,*) "x variable dim defined"
	call check(nf90_def_var(ncid,Y_NAME, NF90_DOUBLE,dimids2,y_varid))
	write(*,*) "y variable dim defined"
!	call check(nf90_def_var(ncid,X_NAME, NF90_DOUBLE,time_id,t_varid))
	write(*,*) "t variable not needed"

	!Set attributes for the dimension variables

	call check(nf90_put_att(ncid,x_varid, UNITS,X_UNITS))
	write(*,*) "x units defined"
	call check(nf90_put_att(ncid,y_varid, UNITS,Y_UNITS))
	write(*,*) "y units defined"
	!call check(nf90_put_att(ncid,t_varid, UNITS,T_UNITS))
	!write(*,*) "t units defined"

	print *,"UNITS placed"

	! creating variables slots
	dimids3 = (/ x_dimid,y_dimid,time_id /)

	call check(nf90_def_var(ncid, U_NAME,NF90_DOUBLE,dimids3,u_varid))
	write(*,*) "u variable dim defined"
	call check(nf90_def_var(ncid, V_NAME,NF90_DOUBLE,dimids3,v_varid))
	write(*,*) "v variable dim defined"
	call check(nf90_def_var(ncid, H_NAME,NF90_DOUBLE,dimids3,h_varid))
	write(*,*) "h variable dim defined"
	call check(nf90_def_var(ncid, F_NAME,NF90_DOUBLE,dimids3,f_varid))
	write(*,*) "f variable dim defined"

	print *,"Data variables created"

	!set attributes for the data variables
	call check(nf90_put_att(ncid, u_varid, UNITS, U_UNITS))
	call check(nf90_put_att(ncid, v_varid, UNITS, V_UNITS))
	call check(nf90_put_att(ncid, h_varid, UNITS, H_UNITS))
	call check(nf90_put_att(ncid, f_varid, UNITS, F_UNITS))

	print *,"Data variables units placed"

	!close variable def
	call check(nf90_enddef(ncid))
	write(*,*) "definition mode ended"

	!Write the dimension variables
	call check(nf90_put_var(ncid,x_varid,xx))
	print *, "X variables placed"
	call check(nf90_put_var(ncid,y_varid,yy))
	print *,"Y variable placed"
	!call check(nf90_put_var(ncid,t_varid,t))
	!print *,"T variable placed"
	
	!Write the data variables
	call check(nf90_put_var(ncid,u_varid,u))
	print *, "u variable placed"
	call check(nf90_put_var(ncid,v_varid,v))
	print *,"v variable placed"
	call check(nf90_put_var(ncid,h_varid,h))
	print *,"h variable placed"
	call check(nf90_put_var(ncid,f_varid,f))
	print *, "f variable placed"

	!close the file
	call check(nf90_close(ncid))

	contains
		subroutine check(status)
			implicit none
			integer,intent(in):: status
		if(status /=nf90_noerr) then
			write(*,*) "error occured"
			print *,trim(nf90_strerror(status))
			stop "stopped"
		endif
		end subroutine check
end subroutine data_saver
