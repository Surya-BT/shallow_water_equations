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
		write(*,*)'All calculations done... No saver routine detected'
		write(*,*)'Exiting without saving the data...'

        end program main

