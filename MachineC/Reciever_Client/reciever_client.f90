! receiver_client.f90
module c_interface_receiver
    use, intrinsic :: iso_c_binding
  
    implicit none
  
    interface
       function fetch_data_from_server(arr, n) bind(C, name="fetch_data_from_server")
          import :: c_int, c_float
          real(c_float), intent(out) :: arr(*)
          integer(c_int), value, intent(in) :: n
          integer(c_int) :: fetch_data_from_server
       end function
    end interface
  
  end module c_interface_receiver
  
  program receiver_client
    use c_interface_receiver
    implicit none
  
    integer :: status
    real, dimension(5) :: arr
  
    ! Fetch float array from server
    status = fetch_data_from_server(arr, size(arr))
    if (status /= 0) then
       print *, "Failed to fetch data from server"
       stop
    end if
  
    print *, "Data received:", arr
  
  end program receiver_client
  