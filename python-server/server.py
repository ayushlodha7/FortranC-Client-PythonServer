from flask import Flask, request, Response
import struct

app = Flask(__name__)

# Predefine the data to send back.
predefined_data = [1.1, 2.2, 3.3, 4.4, 5.5]
binary_predefined_data = struct.pack('5f', *predefined_data)

@app.route('/send_data', methods=['POST'])
def send_data():
    try:
        # Assuming the data sent is in a binary format as it would be from your Fortran client
        received_data = request.get_data()
        print(f"Received data: {struct.unpack('5f', received_data)}")  # Unpack and print the received data
        return Response("Data received successfully", status=200)
    except Exception as e:
        print(f"An error occurred: {e}")
        return Response("Failed to receive data", status=500)

@app.route('/get_data', methods=['GET'])
def get_data():
    print(f"Sending predefined data: {predefined_data}")
    return Response(binary_predefined_data, mimetype='application/octet-stream')

if __name__ == '__main__':
    print("Starting the server...")
    app.run(host='0.0.0.0', port=8080)
