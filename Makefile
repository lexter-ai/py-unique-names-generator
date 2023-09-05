.PHONY: get_session_token dev lint coverage pre-commit sort deploy destroy deps unit infra integration e2e pipeline-tests docs build

dev:
	pip install --upgrade pip pre-commit poetry
	pre-commit install
	poetry config virtualenvs.in-project true

shell:
	poetry shell

install:
	poetry install

unit:
	@TARGET_TESTS="tests/unit/"; \
	if [ ! -z "$(1)" ]; then \
		TARGET_TESTS="$(1)"; \
	fi; \
	poetry run pytest --verbose --color=yes --cov=unique_names_generator --cov-report=xml --cov-report=html -s -v $$TARGET_TESTS

black:
	poetry run black -l 150 -v .

sort:
	poetry run isort ${PWD}

pre-commit:
	poetry run pre-commit run -a --show-diff-on-failure

mypy-lint:
	poetry run  mypy --pretty unique_names_generator

lint:
	@echo "Running flake8"
	poetry run flake8 unique_names_generator/* --exclude patterns='build,cdk.json,cdk.context.json,.yaml'
	@echo "Running mypy"
	# make mypy-lint

complex:
	@echo "Running Radon"
	poetry run radon cc -e 'tests/*,cdk.out/*' .
	@echo "Running xenon"
	# poetry run xenon --max-absolute B --max-modules A --max-average A -e 'tests/*,.venv/*,cdk.out/*' .

format: black sort pre-commit complex lint

jupyter:
	LOG_FORMAT=notebook jupyter notebook

pr: format unit


get_session_token:
	aws_sts_output=$$(aws sts get-session-token \
		--serial-number arn:aws:iam::216495393214:${mfa_profile}/${1} \
		--token-code ${2}); \
	aws_access_key_id_new=$$(echo $$aws_sts_output | jq -r '.Credentials.AccessKeyId'); \
	aws_secret_access_key_new=$$(echo $$aws_sts_output | jq -r '.Credentials.SecretAccessKey'); \
	aws_session_token_new=$$(echo $$aws_sts_output | jq -r '.Credentials.SessionToken'); \
	aws configure set aws_access_key_id $$aws_access_key_id_new --profile $(mfa_profile); \
	aws configure set aws_secret_access_key $$aws_secret_access_key_new --profile $(mfa_profile); \
	aws configure set aws_session_token $$aws_session_token_new --profile $(mfa_profile)
