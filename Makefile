# Tools
GO_BIN := $(shell which go)

# Project info
PROJECT_NAME := $(shell basename $(CURDIR))

# Build configuration
BUILD_DIR := build
MAIN_GO := cmd/$(PROJECT_NAME)/main.go

# Simple color scheme
CYAN := \033[36m
DIM := \033[2m
RESET := \033[0m

# Basic symbols
CHECK := ✓
ARROW := →

.PHONY: check-deps init init-pb create-dirs create-dirs-pb setup-go setup-go-pb setup-git build serve clean help lint fmt mod-tidy

check-deps:
	@printf "\n$(CYAN)Checking dependencies$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@test -n "$(GO_BIN)" || (printf "✗ Go not installed\n" && exit 1)
	@printf "$(CHECK) Go ready\n"
	@test -n "$(shell which git)" || (printf "✗ Git not installed\n" && exit 1)
	@printf "$(CHECK) Git ready\n"

create-dirs:
	@printf "\n$(CYAN)Creating project structure$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@mkdir -p internal/{handler,middleware,model,service,config,controller}
	@mkdir -p cmd/$(PROJECT_NAME)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p docs
	@echo "package main\n\nfunc main() {}" > cmd/$(PROJECT_NAME)/main.go
	@echo "package handler\n\n// HTTP handlers/controllers go here\n// Example: func GetUsers(w http.ResponseWriter, r *http.Request) {}" > internal/handler/handler.go
	@echo "package middleware\n\n// Middleware functions go here" > internal/middleware/middleware.go
	@echo "package controller\n\n// controllers go here" > internal/controller/controller.go
	@echo "package model\n\n// Data models go here" > internal/model/model.go
	@echo "package service\n\n// Business logic goes here" > internal/service/service.go
	@echo "package config\n\n// Configuration management goes here" > internal/config/config.go
	@echo "# Project Documentation\n\nThis is your project documentation." > docs/README.md
	@printf "$(CHECK) Project structure created\n"

create-dirs-pb:
	@printf "\n$(CYAN)Creating PocketBase project structure$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@mkdir -p internal/{handler,middleware,model,service,config,controller}
	@mkdir -p cmd/$(PROJECT_NAME)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p docs
	@mkdir -p pb_data
	@mkdir -p pb_migrations
	@printf 'package main\n\nimport (\n\t"log"\n\t"net/http"\n\n\t"github.com/pocketbase/pocketbase"\n\t"github.com/pocketbase/pocketbase/core"\n)\n\nfunc main() {\n\tapp := pocketbase.New()\n\n\tapp.OnServe().BindFunc(func(se *core.ServeEvent) error {\n\t\tse.Router.GET("/hello", func(e *core.RequestEvent) error {\n\t\t\treturn e.String(http.StatusOK, "Hello World")\n\t\t})\n\t\treturn se.Next()\n\t})\n\n\tif err := app.Start(); err != nil {\n\t\tlog.Fatal(err)\n\t}\n}' > cmd/$(PROJECT_NAME)/main.go
	@echo "package handler\n\n// PocketBase route handlers go here\n// Example: func CustomHandler(e *core.RequestEvent) error {}" > internal/handler/handler.go
	@echo "package middleware\n\n// PocketBase middleware functions go here" > internal/middleware/middleware.go
	@echo "package controller\n\n// PocketBase controllers go here" > internal/controller/controller.go
	@echo "package model\n\n// PocketBase data models go here" > internal/model/model.go
	@echo "package service\n\n// PocketBase business logic goes here" > internal/service/service.go
	@echo "package config\n\n// PocketBase configuration management goes here" > internal/config/config.go
	@echo "# PocketBase Project Documentation\n\nThis is your PocketBase project documentation.\n\n## Getting Started\n\n1. Run \`make serve\` to start the PocketBase server\n2. Visit http://localhost:8090/_/ to access the admin panel\n3. Your custom route is available at http://localhost:8090/hello\n\n## Directory Structure\n\n- \`pb_data/\` - PocketBase data directory\n- \`pb_migrations/\` - Database migrations\n- \`internal/\` - Your custom Go code" > docs/README.md
	@printf "$(CHECK) PocketBase project structure created\n"

setup-go:
	@printf "\n$(CYAN)Initializing Go module$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@$(GO_BIN) mod init $(PROJECT_NAME) 2>/dev/null || true
	@$(GO_BIN) mod tidy >/dev/null 2>&1
	@printf "$(CHECK) Go modules ready\n"

setup-git:
	@printf "\n$(CYAN)Initializing Git repository$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@if [ ! -d .git ]; then \
		git init; \
		echo "# $(PROJECT_NAME)\n\nProject description goes here.\n\n## Getting Started\n\nRun \`make serve\` to start the development server.\n\n## Build\n\nRun \`make build\` to build the production binary." > README.md; \
		echo "*.log\n$(BUILD_DIR)/\npb_data/\n.env\n.DS_Store" > .gitignore; \
		git add .; \
		git commit -m "Initial commit: Project setup"; \
		printf "$(CHECK) Git repository initialized\n"; \
	else \
		printf "$(CHECK) Git repository already exists\n"; \
	fi

setup-go-pb:
	@printf "\n$(CYAN)Initializing PocketBase Go module$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@$(GO_BIN) mod init $(PROJECT_NAME) 2>/dev/null || true
	@$(GO_BIN) get github.com/pocketbase/pocketbase
	@$(GO_BIN) mod tidy
	@printf "$(CHECK) PocketBase Go modules ready\n"

build: check-deps
	@printf "\n$(CYAN)Building project$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@$(GO_BIN) build -o $(BUILD_DIR)/$(PROJECT_NAME) $(MAIN_GO)
	@printf "$(CHECK) Build complete: $(BUILD_DIR)/$(PROJECT_NAME)\n"

serve:
	@printf "\n$(CYAN)Starting server$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@if grep -q "github.com/pocketbase/pocketbase" go.mod 2>/dev/null; then \
		$(GO_BIN) run $(MAIN_GO) serve; \
	else \
		$(GO_BIN) run $(MAIN_GO); \
	fi

clean:
	@printf "\n$(CYAN)Cleaning build files$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@rm -rf $(BUILD_DIR)
	@printf "$(CHECK) Clean complete\n"

lint:
	@printf "\n$(CYAN)Running linter$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@$(GO_BIN) vet ./...
	@printf "$(CHECK) Linting complete\n"

fmt:
	@printf "\n$(CYAN)Formatting code$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@$(GO_BIN) fmt ./...
	@printf "$(CHECK) Formatting complete\n"

mod-tidy:
	@printf "\n$(CYAN)Tidying Go modules$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@$(GO_BIN) mod tidy
	@printf "$(CHECK) Modules tidied\n"

init: check-deps create-dirs setup-go setup-git
	@printf "\n$(CHECK) Go project setup complete!\n"
	@printf "\nNext steps:\n"
	@printf "  make serve$(RESET)         $(ARROW) Start development server\n"
	@printf "  make build$(RESET)         $(ARROW) Build production binary\n"

init-pb: check-deps create-dirs-pb setup-go-pb setup-git
	@printf "\n$(CHECK) PocketBase project setup complete!\n"
	@printf "\nNext steps:\n"
	@printf "  make serve$(RESET)         $(ARROW) Start PocketBase server\n"
	@printf "  make build$(RESET)         $(ARROW) Build production binary\n"
	@printf "\nPocketBase URLs:\n"
	@printf "  http://localhost:8090/_/$(RESET)    $(ARROW) Admin panel\n"
	@printf "  http://localhost:8090/hello$(RESET) $(ARROW) Custom route\n"

help:
	@printf "\n$(CYAN)Available commands$(RESET)\n"
	@printf "$(DIM)────────────────────────────────────$(RESET)\n"
	@printf "  make init$(RESET)          $(ARROW) Initialize standard Go project (with Git)\n"
	@printf "  make init-pb$(RESET)       $(ARROW) Initialize PocketBase Go project (with Git)\n"
	@printf "  make build$(RESET)         $(ARROW) Build project binary\n"
	@printf "  make serve$(RESET)         $(ARROW) Start development server\n"
	@printf "  make lint$(RESET)          $(ARROW) Run code linter\n"
	@printf "  make fmt$(RESET)           $(ARROW) Format Go code\n"
	@printf "  make mod-tidy$(RESET)      $(ARROW) Tidy Go modules\n"
	@printf "  make clean$(RESET)         $(ARROW) Clean build files\n"
	@printf "  make help$(RESET)          $(ARROW) Show this help\n\n"