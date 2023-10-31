// http_client_receiver.c
#include <stdio.h>
#include <curl/curl.h>
#include <string.h>


size_t write_callback(char* ptr, size_t size, size_t nmemb, void* userdata) {
    size_t total_size = size * nmemb;
    if (total_size <= 5 * sizeof(float)) {
        memcpy(userdata, ptr, total_size);
        return total_size;
    }
    return 0;
}

int fetch_data_from_server(float arr[], int n) {
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, "Failed to initialize curl\n");
        return -1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, "http://149.159.235.155:8080/get_data");
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, arr);

    res = curl_easy_perform(curl);
    curl_easy_cleanup(curl);

    if (res != CURLE_OK) {
        fprintf(stderr, "Failed to fetch data from server: %s\n", curl_easy_strerror(res));
        return -1;
    }

    return 0;
}
