module c_interface_combined
    use, intrinsic :: iso_c_binding
    implicit none

    interface
        function send_data_to_server(arr, n) bind(C, name="send_data_to_server")
            import :: c_int, c_double
            real(c_double), intent(in) :: arr(*)
            integer(c_int), value, intent(in) :: n
            integer(c_int) :: send_data_to_server
        end function send_data_to_server

        function fetch_data_from_server(arr, n) bind(C, name="fetch_data_from_server")
            import :: c_int, c_double
            real(c_double), intent(out) :: arr(*)
            integer(c_int), value, intent(in) :: n
            integer(c_int) :: fetch_data_from_server
        end function fetch_data_from_server
    end interface

end module c_interface_combined

program combined_client
    use c_interface_combined
    implicit none

    integer :: status_send, status_fetch, n, i
    real(kind=c_double), allocatable :: arr_send(:), arr_fetch(:)

    n = 2000  ! Size of the array
    allocate(arr_send(n), arr_fetch(n))

    ! Initialize arr_send with double precision values
    do i = 1, n
        arr_send(i) = real(i, kind=c_double)
    end do

    ! Send the entire array
    status_send = send_data_to_server(arr_send, n)
    if (status_send /= 0) then
        print *, "Failed to send data to server"
    else
        print *, "Data sent successfully!"
    end if

    ! Fetch the entire array
    status_fetch = fetch_data_from_server(arr_fetch, n)
    if (status_fetch /= 0) then
        print *, "Failed to fetch data from server"
    else
        print *, "Data received:", arr_fetch
    end if

    deallocate(arr_send, arr_fetch)
end program combined_client
