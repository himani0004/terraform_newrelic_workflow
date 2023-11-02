terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "3.27.3"
    }
  }
}

provider "newrelic" {
  account_id = 4221285

  api_key = "NRAK-N7LF93D6D1YP180O6QW3TI46HMS"
  region  = "US"
}