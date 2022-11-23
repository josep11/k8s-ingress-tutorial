from flask import Flask

app = Flask(__name__)


@app.route("/api")
def hello_world_public():
    return "Hello Public Api!"


@app.route("/private/api")
def hello_world_private():
    return "Hello Private Api!"


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
