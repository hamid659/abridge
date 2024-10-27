terraform {

  backend "gcs" {
    bucket     = "hamid-test-24-terraform-state" 
    prefix     = "terraform/state"            # Optional: prefix for the state file
  }
}
