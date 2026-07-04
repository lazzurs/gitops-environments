# DollarBox accounts

DollarBox orgs consumed by other UnicornOps projects. Org creation and comped
billing are staff actions in the DollarBox control panel (deliberately not in
the public API or the Terraform provider), so this directory records them as a
register rather than as Terraform. Namespaces/containers *within* an org can
be managed via [terraform-provider-dollarbox](https://github.com/unicornops/terraform-provider-dollarbox)
if IaC is wanted later.

## family-chat-staging

Ephemeral staging for [family-chat](https://github.com/unicornops/family-chat)
— see `docs/staging-environment.md` in that repo for the full runbook.

- **Org**: `family-chat-staging`, comped via
  `python manage.py grant_comped_billing family-chat-staging`
- **Quota**: ≥ 20 containers / 60 GB storage (full e2e run ≈ 15 containers)
- **Reserved IPv6**: ≥ 5 addresses in the org's `container-reserved-ipv6`
  pool — 4 family homeserver LoadBalancers + 1 control-panel LB (the panel
  address is pinned via the `K8S_PANEL_RESERVED_IPV6` GitHub secret)
- **Credentials**: tenant kubeconfig stored as the `KUBECONFIG_STAGING`
  secret in the family-chat repo's `staging` GitHub environment
- **Rotation**: regenerate the tenant kubeconfig in the DollarBox panel and
  update `KUBECONFIG_STAGING`; nothing else holds it. The org has no API
  token by design (`DOLLARBOX_API_TOKEN` stays unset so the family-chat
  control panel runs in single-namespace mode).

## family-chat (production)

Production family-chat also deploys onto a DollarBox tenant namespace (org
managed separately; see `docs/dollarbox-deployment.md` in the family-chat
repo). Recorded here for completeness — its credentials live in the
family-chat repo's `production` GitHub environment.
