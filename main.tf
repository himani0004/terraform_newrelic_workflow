resource "newrelic_alert_policy" "my_policy1" {
  name                = "himanisharma_policy2"
  incident_preference = "PER_POLICY" # PER_POLICY is default
}


//alert condition
# data "newrelic_entity" "app" {
#   name   = "himani-react"
#   type   = "APPLICATION"
#   domain = "BROWSER"
# }

# resource "newrelic_alert_condition" "my_condition" {
#   policy_id = newrelic_alert_policy.my_policy.id

#   name            = "alert_condition"
#   type            = "apm_app_metric"
#   entities        = [data.newrelic_entity.app.application_id]
#   metric          = "apdex"
#   runbook_url     = "https://www.example.com"
#   condition_scope = "application"

#   term {
#     duration      = 5
#     operator      = "below"
#     priority      = "critical"
#     threshold     = "0.75"
#     time_function = "all"
#   }
# }
resource "newrelic_nrql_alert_condition" "alert_condition1" {

  policy_id   = newrelic_alert_policy.my_policy1.id
  type        = "static"
  name        = "workflow_alertcondition"
  description = "Alert when transactions are taking too long"
  enabled     = true


  nrql {
    query = "SELECT average(host.cpuPercent) AS 'CPU used %' FROM Metric WHERE `entityGuid` = 'NDIyMTI4NXxJTkZSQXxOQXw0MzEzMjA4ODAwNDM3OTAxNTY2'"
  }

  critical {
    operator              = "above"
    threshold             = 15
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = 7
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

//destination

resource "newrelic_notification_destination" "my_destination" {

  name       = "destination_workflow"
  type       = "EMAIL"

  property {
    key   = "email"
    value = "himanivashisht0004@gmail.com"
  }

   auth_basic {
     user     = "username"
     password = "password"
   }
}





//channel
resource "newrelic_notification_channel" "my_channel" {
 
  name           = "channel-himani"
  type           = "EMAIL"
  destination_id = newrelic_notification_destination.my_destination.id
  product        = "IINT" // (Workflows)

  // must be valid json
  property {
    key   = "payload"
    value = "{}"
    label = "Payload Template"
  }
}






//workflow

resource "newrelic_workflow" "my_workflow" {
  name                  = "himani_workflow"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name = "filter-name"
    type = "FILTER"

    predicate {
      attribute = "accumulations.tag.team"
      operator  = "EXACTLY_MATCHES"
      values    = [newrelic_alert_policy.my_policy1.id]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.my_channel.id
  }
}