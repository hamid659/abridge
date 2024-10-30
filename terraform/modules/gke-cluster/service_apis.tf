# Enable required APIs
resource "google_project_service" "enable_apis" {
  for_each = toset([
    "iam.googleapis.com",                 
    "compute.googleapis.com",             
    "cloudresourcemanager.googleapis.com",
    "artifactregistry.googleapis.com",   
    "container.googleapis.com" 
  ])
  project = var.project_id
  service = each.value
  disable_dependent_services = true 
  
  lifecycle {
    prevent_destroy = true  # Prevent this resource from being destroyed
  }
}
