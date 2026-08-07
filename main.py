import os

from flask import Flask, render_template, request, jsonify
from google.cloud import firestore

app = Flask(__name__)

db = firestore.Client()


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/log", methods=["POST"])
def log_weight():
    data = request.get_json()

    name = data.get("name", "").strip()
    weight = data.get("weight")

    if not name:
        return jsonify({"error": "Name is required"}), 400

    try:
        weight = float(weight)
    except (TypeError, ValueError):
        return jsonify({"error": "Valid weight is required"}), 400

    db.collection("weight_logs").add({
        "name": name,
        "weight": weight,
        "timestamp": firestore.SERVER_TIMESTAMP
    })

    return jsonify({
        "success": True,
        "message": "Weight logged successfully"
    })


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.environ.get("PORT", 8080))
    )
