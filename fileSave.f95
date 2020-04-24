! This is a file to store the values in a file. This file will be accessed by MATLAB.
! Creating this as a subroutine
subroutine matlab_saver
	use params
	use model_vars

	implicit none
	character(len=10)::filename
	character(len=80)::errmsg
	integer :: i,j,uc,k
	integer :: stat
	filename='mesh.dat'
	uc=11

! open a file to write the mesh data
	open (UNIT=uc, FILE=filename, STATUS='NEW', ACTION='WRITE', IOSTAT=stat,&
	IOMSG=errmsg)	

	write(11,10)
	10 format(T6,'this is the mesh file')

	write(11,20) 'X',xstart,xend
 	20 format(1X,A,2X,2F8.2)

	do i=1,nx
		write(11,30) (xx(i,j),j=1,ny)
		30 format(1X,*(F8.3))
	end do

	write(11,20) 'Y',ystart,yend
	
	do i=1,nx
		write(11,30) (yy(i,j),j=1,ny)

	end do

	close(unit=uc)

! open file to write the important variables - h,u,v
!	open (unit=22, file='h.dat',status='new',action='write',iostat=stat,&
!	iomsg=errmsg)
!
!	write(22,110)
!	110 format(T6,'this is a varible file. it contains h for all time')
!
!	
!	do k=1,nt
!		
!		write(22,120) k
!		120 format('T='I7)
!		
!		do i=1,nx
!			write(22,130) (h(i,j,k),j=1,ny)
!			130 format(1X,*(F11.5))
!		end do
!	end do

! writing in binary format
	open (unit=22, file='h.dat',status='new',action='write',form="unformatted",iostat=stat,&
	iomsg=errmsg)

	do k=1,nt
		
		do i=1,nx
			write(22) (h(i,j,k),j=1,ny)
		end do
	end do



end subroutine matlab_saver



