package handler

import (
	"pocketapi/internal/controller"

	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// register routes here
func RegisterRoutes(e *core.ServeEvent) error {
	v1 := e.Router.Group("/v1")

	v1.GET("/hello", controller.HelloWorldController)
	v1.POST("/post", controller.PostController).Bind(apis.RequireAuth()) // Auth middleware

	paymentGroup := v1.Group("/payment")
	paymentGroup.POST("/create", controller.CreatePaymentOrder).Bind(apis.RequireAuth())

	return e.Next()
}
