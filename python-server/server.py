from flask import Flask, request, Response,jsonify
import struct

app = Flask(__name__)

# Prompt for the data size when the server starts
try:
    array_size = int(input("Enter the size for data to send: "))
except ValueError:
    print("Invalid input! Using default size 20.")
    array_size = 20

@app.route('/sent_data_size', methods=['GET'])
def sent_data_size():
    try:
        return Response(str(array_size), mimetype='text/plain')
    except Exception as e:
        print(f"Error: {e}")
        return "Failed to get data size", 500

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
    data_to_send = [float(i) for i in range(array_size)]
    binary_data = struct.pack(f'{array_size}d', *data_to_send)
    return Response(binary_data, mimetype='application/octet-stream')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
