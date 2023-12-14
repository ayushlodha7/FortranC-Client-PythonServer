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

        function get_data_size_from_server(n) bind(C, name="get_data_size_from_server")
            import :: c_int
            integer(c_int), intent(out) :: n
            integer(c_int) :: get_data_size_from_server
        end function get_data_size_from_server
    end interface

end module c_interface_combined

program combined_client
    use c_interface_combined
    implicit none

    integer :: status_send, status_fetch, n_send, n_fetch, i
    real(kind=c_double), allocatable :: arr_send(:), arr_fetch(:)

    ! Read the size of the array to send from the terminal
    print *, "Enter the size of the array to send:"
    read(*, *) n_send
    allocate(arr_send(n_send))

    ! Initialize arr_send with double precision values
    do i = 1, n_send
        arr_send(i) = real(i, kind=c_double)
    end do

    ! Send the entire array
    status_send = send_data_to_server(arr_send, n_send)
    if (status_send /= 0) then
        print *, "Failed to send data to server"
    else
        print *, "Data sent successfully!"
    end if

    ! Get the size of the array to fetch from the server
    status_fetch = get_data_size_from_server(n_fetch)
    if (status_fetch /= 0) then
        print *, "Failed to get data size from server"
    else
        print *, "Size of data to fetch from server: ", n_fetch
        allocate(arr_fetch(n_fetch))
        status_fetch = fetch_data_from_server(arr_fetch, n_fetch)
        if (status_fetch /= 0) then
            print *, "Failed to fetch data from server"
        else
            print *, "Data received:"
            do i = 1, n_fetch
                print *, arr_fetch(i)
            end do
        end if
        deallocate(arr_fetch)
    end if

    deallocate(arr_send)
end program combined_client
