import os
import re

from flask import Flask, jsonify, render_template, request
from google.cloud import firestore


app = Flask(__name__)


PROJECT_ID = os.environ.get("GOOGLE_CLOUD_PROJECT")

DATABASE_ID = os.environ.get(
    "FIRESTORE_DATABASE",
    "(default)"
)


db = firestore.Client(
    project=PROJECT_ID,
    database=DATABASE_ID
)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    })


@app.route(
    "/api/checkin",
    methods=["POST"]
)
def checkin():

    data = request.get_json(
        silent=True
    ) or {}


    name = str(
        data.get(
            "name",
            ""
        )
    ).strip()


    weight_value = data.get(
        "weight"
    )


    blood_pressure = str(
        data.get(
            "blood_pressure",
            ""
        )
    ).strip()


    client_timestamp = data.get(
        "client_timestamp"
    )


    #
    # Validate name
    #

    if not name:
        return jsonify({
            "success": False,
            "error": "Name is required."
        }), 400


    if len(name) > 100:
        return jsonify({
            "success": False,
            "error": "Name is too long."
        }), 400


    #
    # Validate weight
    #

    try:
        weight = float(
            weight_value
        )

    except (
        TypeError,
        ValueError
    ):
        return jsonify({
            "success": False,
            "error": "Enter a valid weight."
        }), 400


    if weight <= 0 or weight > 1500:
        return jsonify({
            "success": False,
            "error": "Enter a valid weight."
        }), 400


    #
    # Validate blood pressure.
    #
    # Valid examples:
    #
    # 120/80
    # 98/65
    # 145/90
    #

    blood_pressure_pattern = (
        r"^\d{2,3}\s*/\s*\d{2,3}$"
    )


    if not re.fullmatch(
        blood_pressure_pattern,
        blood_pressure
    ):
        return jsonify({
            "success": False,
            "error": (
                "Enter blood pressure "
                "in a format such as 120/80."
            )
        }), 400


    systolic_text, diastolic_text = (
        blood_pressure.split("/")
    )


    systolic = int(
        systolic_text.strip()
    )


    diastolic = int(
        diastolic_text.strip()
    )


    #
    # Broad validation only.
    #
    # These limits are intended to reject
    # obvious data-entry errors.
    #

    if (
        systolic < 40
        or systolic > 300
        or diastolic < 20
        or diastolic > 200
    ):
        return jsonify({
            "success": False,
            "error": (
                "Blood pressure value "
                "appears invalid."
            )
        }), 400


    normalized_blood_pressure = (
        f"{systolic}/{diastolic}"
    )


    #
    # Firestore document
    #

    document = {
        "name": name,

        "weight": weight,

        "weight_unit": "lb",

        "blood_pressure":
            normalized_blood_pressure,

        "systolic":
            systolic,

        "diastolic":
            diastolic,

        "timestamp":
            firestore.SERVER_TIMESTAMP,

        "client_timestamp":
            client_timestamp
    }


    document_reference = (
        db
        .collection("checkins")
        .document()
    )


    document_reference.set(
        document
    )


    return jsonify({
        "success": True,

        "id":
            document_reference.id,

        "message":
            "Check-in logged successfully."
    })


if __name__ == "__main__":

    port = int(
        os.environ.get(
            "PORT",
            8080
        )
    )


    app.run(
        host="0.0.0.0",
        port=port
    )
