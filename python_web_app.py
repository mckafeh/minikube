from flask import Flask
import socket

app = Flask(__name__)


@app.route("/")
def request_handler():
    hostname = socket.gethostname()
    return "Hello, World!" +  "         " + hostname


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0',port=5000)
