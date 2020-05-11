!this is used to initialise the variables of the program

subroutine init
	use params
	use model_vars
	
	implicit none
	
	real*8,parameter :: uinit=0,vinit=0
	integer :: i1 !iterating variable
	
	do i1=1,nx
		x(i1)=xstart+dx*real(i1-1)
	end do

	do i1=1,ny
		y(i1)=ystart+dy*real(i1-1)
	end do
	
	call meshgrid2d(x,y,xx,yy,nx,ny)

	do i1=1,nt
		t(i1)=tstart+dt*real(i1-1)
	end do
!coriolis matrix
	do i1=1,ny
		F(:,i1)=2.0*omega*sin(pi*y(i1)/Ly)
	end do

	u(:,:,1)=0.0
	v(:,:,1)=0.0
	h(:,:,1)=H0-perturb*exp(-(xx**2.0 + yy**2.0))
	
	print *,"initialised the variables"

end subroutine init

subroutine meshgrid2d(x,y,x2,y2,nx,ny)

	implicit none
	
	integer,intent(in):: nx,ny
	real*8, intent(in) :: x(nx),y(ny)
	real*8,intent(out) :: x2(nx,ny),y2(nx,ny)
	real*8,dimension(ny,nx) :: y1	
!	x2=spread(x,1,size(y))
	x2=spread(x,1,101)
!	y2=spread(y,2,size(x))
!	y1=reshape(y,(/size(y),1/))
	y2=spread(y,2,101)
!	y2=spread(y,1,size(x))
!	y1=transpose(y2)


end subroutine meshgrid2d


