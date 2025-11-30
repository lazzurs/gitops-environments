variable "dataset_name" {
  type        = string
  description = "The name of the Axiom dataset"
}

resource "axiom_dataset" "this" {
  name = var.dataset_name
}
