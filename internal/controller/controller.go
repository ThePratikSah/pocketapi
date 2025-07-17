package controller

import (
	"net/http"

	"github.com/pocketbase/pocketbase/core"
	razorpay "github.com/razorpay/razorpay-go"
)

func HelloWorldController(e *core.RequestEvent) error {
	return e.String(http.StatusOK, "Hello World")
}

func PostController(e *core.RequestEvent) error {
	return e.String(http.StatusOK, "Post")
}

func CreatePaymentOrder(e *core.RequestEvent) error {
	client := razorpay.NewClient("TEMP_KEY", "TEMP_SECRET")

	data := map[string]interface{}{
		"amount":          100,
		"currency":        "INR",
		"receipt":         "some_receipt_id",
		"partial_payment": false,
		"notes": map[string]interface{}{
			"key1": "value1",
			"key2": "value2",
		},
	}
	body, err := client.Order.Create(data, nil)

	if err != nil {
		return e.Error(http.StatusInternalServerError, "Failed to create payment order", err)
	}

	return e.JSON(http.StatusOK, body)
}
