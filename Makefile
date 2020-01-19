.PHONY: e2e build acceptance

build:
	go build -o wiki main.go

e2e: build
	sh e2e.sh

acceptance: build
	sh acceptance.sh
