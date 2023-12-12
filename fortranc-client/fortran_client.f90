program combined_client
    use c_interface_combined
    implicit none

    integer :: status_send, status_fetch, n, i, chunk_index
    double precision, allocatable :: arr_send(:), arr_fetch(:)

    n = 2000000  ! Size of the array
    allocate(arr_send(n), arr_fetch(n))

    ! Initialize arr_send with double precision values
    do i = 1, n
        arr_send(i) = real(i, kind=8)
    end do

    chunk_index = 0  ! Assuming you are sending and receiving data in a single chunk

    ! Send the entire array
    status_send = send_data_to_server(arr_send, n, chunk_index)
    if (status_send /= 0) then
        print *, "Failed to send data to server"
    else
        print *, "Data sent successfully!"
    end if

    ! Fetch the entire array
    status_fetch = fetch_data_from_server(arr_fetch, n, chunk_index)
    if (status_fetch /= 0) then
        print *, "Failed to fetch data from server"
    else
        print *, "Data received:", arr_fetch
    end if

    deallocate(arr_send, arr_fetch)
end program combined_client
