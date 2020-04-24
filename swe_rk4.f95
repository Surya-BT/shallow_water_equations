!THis the file which stores the rk4 procedure and solve subroutines

subroutine rk4(ts)

	use params
	use model_vars

	implicit none

	integer,intent(in) :: ts
	
	real*8,dimension(1:nx,1:ny) :: uo,vo,ho
	real*8,dimension(1:nx,1:ny) :: ku1,kv1,kh1
	real*8,dimension(1:nx,1:ny) :: ku2,kv2,kh2
	real*8,dimension(1:nx,1:ny) :: ku3,kv3,kh3
	real*8,dimension(1:nx,1:ny) :: ku4,kv4,kh4
	real*8,dimension(1:nx,1:ny) :: uout,vout,hout

	real*8,parameter :: dt2=dt/2.0,dt6=dt/6.0

		
	uo = u(:,:,ts)
	vo = v(:,:,ts)
	ho = h(:,:,ts)

	call solve (ku1,kv1,kh1,uo,vo,ho)
	
	call solve (ku2,kv2,kh2,uo+ku1*dt2,vo+kv1*dt2,ho+kh1*dt2)
	
	call solve (ku3,kv3,kh3,uo+ku2*dt2,vo+kv2*dt2,ho+kh2*dt2)
	
	call solve (ku4,kv4,kh4,uo+ku3*dt,vo+kv3*dt,ho+kh3*dt)


! final step

	uout = uo + dt6*(ku1+2*ku2+2*ku3+ku4)
	vout = vo + dt6*(kv1+2*kv2+2*kv3+kv4)
	hout = ho + dt6*(kh1+2*kh2+2*kh3+kh4)
	
	u(:,:,ts+1) = uout
	v(:,:,ts+1) = vout
	h(:,:,ts+1) = hout
	
end subroutine rk4

subroutine solve(uout,vout,hout,uin,vin,hin)
	
	use params
	use model_vars
	
	implicit none 

	real*8,dimension(1:nx,1:ny),intent(in) :: uin,vin,hin
	real*8,dimension(1:nx,1:ny),intent(out) :: uout,vout,hout

	integer :: i2,j2
	integer :: xb,xc,xf,yb,yc,yf

	real*8,parameter :: nuxx=nu/(dx**2),nuyy=nu/(dy**2),gdx=g/(2.0*dx),gdy=g/(2.0*dy),dx2=1.0/(2.0*dx),dy2=1.0/(2.0*dy)
! 	nuxx = nu/(dx**2.0) ! here I am using teh exponential power instead of multiplying twice
!	nuyy = nu/(dy**2.0)
!	gdx = g/(2.0*dx)
!	gdy = g/(2.0*dy)
!	
!	dx2=1.0/(2.0*dx)
!	dy2=1.0/(2.0*dy)

	real*8 :: hx,hy,ux,uy,vx,vy ! advection terms
	real*8 :: uxx,uyy,vxx,vyy ! diffusion terms
	real*8 :: fv,fu ! coriolis terms in mom eqn
	real*8 :: gx,gy !gravity terms in mom eqn
	real*8 :: bu,bv ! viscous drag in mom eqn
	
	do j2=1,ny
		call indices (yf,yc,yb,j2,ny)
		do i2=1,nx
			call indices (xf,xc,xb,i2,nx)

			hx=(hin(xf,yc)*uin(xf,yc)-hin(xb,yc)*uin(xb,yc))*dx2
			hy=(hin(xc,yf)*uin(xc,yf)-hin(xc,yb)*uin(xc,yb))*dy2

			ux=uin(xc,yc)*(uin(xf,yc)-uin(xb,yc))*dx2	
			uy=vin(xc,yc)*(uin(xc,yf)-uin(xc,yb))*dy2
			
			vx=uin(xc,yc)*(vin(xf,yc)-vin(xb,yc))*dx2
			vy=vin(xc,yc)*(uin(xc,yf)-uin(xc,yb))*dy2

			fv = F(xc,yc)*vin(xc,yc)
			fu = F(xc,yc)*uin(xc,yc)
	
			gx = gdx*(hin(xf,yc)-hin(xb,yc))
			gy = gdy*(hin(xc,yf)-hin(xc,yb))

			bu = vd*uin(xc,yc)
			bv = vd*vin(xc,yc)

			uxx = nuxx*(uin(xf,yc)-2.0*uin(xc,yc)+uin(xb,yc))
			uyy = nuyy*(uin(xc,yf)-2.0*uin(xc,yc)+uin(xc,yb))
			
			vxx = nuxx*(vin(xf,yc)-2.0*vin(xc,yc)+vin(xb,yc))
			vyy = nuyy*(vin(xc,yf)-2.0*vin(xc,yc)+vin(xc,yb))
			
			hout(xc,yc) = -(hx+hy)	
			uout(xc,yc) = -(ux+uy)+fv-gx-bu+uxx+uyy
			vout(xc,yc) = -(vx+vy)+fu-gy-bv+vxx+vyy


		end do
	end do

end subroutine solve


subroutine indices(xb,xc,xf,i2,nxx)

	use params
	use model_vars
	
	integer,intent(in)::i2,nxx
	integer,intent(out)::xb,xc,xf

	if (i2 == 1) then
		xb = nxx
		xc = i2
		xf = i2+1
	else if (i2 == nxx) then
		xb = i2-1
		xc = i2
		xf = 1
	else 	
		xb = i2-1
		xc = i2
		xf = i2+1
	end if

end subroutine indices

