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

                do i=1,nt ! i=2,nt
                        call rk4(i) ! rk4(i-1)
                        print *,"calculations done for timeStep t=",i,"of",nt
                                                
                end do
                print *,"All calculations done! Saving data"
	        call data_saver
                print *, "ALl data saved...exiting"

        end program main

