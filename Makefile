#MAKEFLAGS += --silent

.PHONY: new-session
new-session:
	./script.sh newsession

.PHONY: login
login:
	./script.sh login

.PHONY: 2fa
2fa:
	./script.sh 2fa

.PHONY: scrape
scrape:
	./script.sh scrape

.PHONY: parse-portfolio
parse-portfolio:
	./script.sh parseportfolio

.PHONY: rebalance
rebalance:
	echo "This operation is not yet supported. Please use contribute"
	exit 1
	#./script.sh rebalance

.PHONY: contribute
contribute:
	./script.sh contribute

.PHONY: make-operations
make-operations:
	./script.sh makeoperations

.PHONY: end-session
end-session:
	./script.sh endsession

