from flask import Flask, request, Response
import struct

app = Flask(__name__)

@app.route('/receive_data', methods=['POST'])
def receive_data():
    try:
        received_data = request.get_data()
        num_doubles = len(received_data) // struct.calcsize('d')
        unpacked_data = struct.unpack(f'{num_doubles}d', received_data)
        print(f"Received data: {unpacked_data}")
        return "Data received successfully", 200
    except Exception as e:
        print(f"Error: {e}")
        return "Failed to receive data", 500

@app.route('/send_data', methods=['GET'])
def send_data():
    array_size = 2000000
    data_to_send = [float(i) for i in range(array_size)]  # Python's float is equivalent to C's double
    binary_data = struct.pack(f'{array_size}d', *data_to_send)
    return Response(binary_data, mimetype='application/octet-stream')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
