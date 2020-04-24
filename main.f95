!main program

! this is the main program for the model

        program main
                use params
                use model_vars

                implicit none
                
                integer :: i

                print *, "Loaded parameters and variables"

                call init
                print *, "Data initialised and starting calculation"

                do i=2,nt
                        call rk4(i-1)
                        print *,"calculations done for timeStep t=",i-1,"of",nt
                                                
                end do
                print *,"All calculations done! Saving data"
	        call matlab_saver
                print *, "ALl data saved...exiting"
	
		write(*,*)'The y value is'
		write(*,90) (y(i),i=1,ny) 
		90 format (*(F8.3,1X))

        end program main

