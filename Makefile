#MAKEFLAGS += --silent

.PHONY: 010-new-session
010-new-session:
	./script.sh newsession

.PHONY: 020-login
020-login:
	./script.sh login

.PHONY: 030-2fa
030-2fa:
	./script.sh 2fa

.PHONY: 040-scrape
040-scrape:
	./script.sh scrape

.PHONY: 050-parse-portfolio
050-parse-portfolio:
	./script.sh parseportfolio

.PHONY: 100-rebalance
100-rebalance:
	echo "This operation is not yet supported. Please use contribute"
	exit 1
	#./script.sh rebalance

.PHONY: 110-prepare-contribution
110-prepare-contribution:
	./script.sh prepare-contribution

.PHONY: 120-contribute
120-contribute:
	./script.sh contribute

.PHONY: 200-make-operations
200-make-operations:
	./script.sh makeoperations

.PHONY: 900-end-session
900-end-session:
	./script.sh endsession

