! sender_client.f90
module c_interface_sender
    use, intrinsic :: iso_c_binding
  
    implicit none
  
    interface
       function send_data_to_server(arr, n) bind(C, name="send_data_to_server")
          import :: c_int, c_float
          real(c_float), intent(in) :: arr(*)
          integer(c_int), value, intent(in) :: n
          integer(c_int) :: send_data_to_server
       end function
    end interface
  
  end module c_interface_sender
  
  program sender_client
    use c_interface_sender
    implicit none
  
    integer :: status
    real, dimension(5) :: arr = [1.1, 2.2, 3.3, 4.4, 5.5]
  
    ! Send float array to server
    status = send_data_to_server(arr, size(arr))
    if (status /= 0) then
       print *, "Failed to send data to server"
       stop
    end if
  
    print *, "Data sent successfully!"
  
  end program sender_client
  