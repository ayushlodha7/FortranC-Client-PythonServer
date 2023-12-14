#include <curl/curl.h>
#include <string.h>
#include <stdio.h>

typedef struct {
    double *buffer;
    size_t max_size;  // maximum number of doubles the buffer can hold
    size_t current_size;  // current number of doubles written to the buffer
} write_callback_data;

size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata) {
    write_callback_data *data = (write_callback_data *)userdata;
    size_t total_size = size * nmemb;
    size_t available_space = (data->max_size - data->current_size) * sizeof(double);

    if (total_size > available_space) {
        total_size = available_space;  // prevent buffer overrun
    }

    if (total_size > 0) {
        memcpy(data->buffer + data->current_size, ptr, total_size);
        data->current_size += total_size / sizeof(double);
    }

    return total_size;
}

size_t size_write_callback(char *ptr, size_t size, size_t nmemb, void *userdata) {
    int *data_size = (int *)userdata;
    sscanf(ptr, "%d", data_size);
    return size * nmemb;
}

int get_data_size_from_server(int *n) {
    CURL *curl = curl_easy_init();
    if (!curl) return -1;

    curl_easy_setopt(curl, CURLOPT_URL, "http://128.55.64.35:8080/sent_data_size");
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, size_write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, n);
    CURLcode res = curl_easy_perform(curl);

    curl_easy_cleanup(curl);
    return (res == CURLE_OK) ? 0 : -1;
}

int send_data_to_server(double* arr, int n) {
    CURL *curl = curl_easy_init();
    if (!curl) return -1;

    struct curl_slist *headers = curl_slist_append(NULL, "Content-Type: application/octet-stream");
    curl_easy_setopt(curl, CURLOPT_URL, "http://128.55.64.35:8080/receive_data");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, arr);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, sizeof(double) * n);
    CURLcode res = curl_easy_perform(curl);

    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);
    return (res == CURLE_OK) ? 0 : -1;
}

int fetch_data_from_server(double* arr, int n) {
    CURL *curl = curl_easy_init();
    if (!curl) return -1;

    write_callback_data data = {arr, n, 0};  // Initialize write_callback data

    curl_easy_setopt(curl, CURLOPT_URL, "http://128.55.64.35:8080/send_data");
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &data);
    CURLcode res = curl_easy_perform(curl);

    curl_easy_cleanup(curl);
    return (res == CURLE_OK) ? 0 : -1;
}
