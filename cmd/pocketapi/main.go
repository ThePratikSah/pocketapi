package main

import (
	"log"
	"pocketapi/internal/handler"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
)

func main() {
	app := pocketbase.New()

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		return handler.RegisterRoutes(se)
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
