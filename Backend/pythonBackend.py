import stripe
import sys
import json
from flask import Flask, render_template, request, jsonify


stripe.api_key = "sk_test_RPqKcpfyn4rsbQ25aPiODSQ2"

app = Flask(__name__)

@app.route("/newSubscriber", methods=['GET', 'POST'])
def subscribe():
    data = request.json





@app.route("/buyGas", methods=['GET', 'POST'])
def buyGas():
    data = request.json
    token = data["stripeToken"]
    name = data["shipping"]["name"]
    city = data["shipping"]["address"]["city"]
    lineOne = data["shipping"]["address"]["line1"]
    postalCode = data["shipping"]["address"]["postal_code"]
    state = data["shipping"]["address"]["state"]
    charge = stripe.Charge.create(
    amount=data["amount"],
    currency='usd',
    receipt_email= data["receipt_email"],
    source=token,
    shipping={"name":name,"address":{"city":city,"line1": lineOne,"state":state,
                                     "postal_code":postalCode
                                     }}
      
    )

    return "Gas order succeeded"
    
