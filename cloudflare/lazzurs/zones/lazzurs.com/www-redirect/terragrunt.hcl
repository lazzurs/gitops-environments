include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/cloudflare/lazzurs/modules/www-redirect"
}

# DNS for lazzurs.com is in neamh/octodns; www must be proxied there for the
# redirect to apply.
inputs = {
  zone_id = "d18a872b8086170c71295059733551e3"
  apex    = "lazzurs.com"
}
