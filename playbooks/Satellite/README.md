# Playbooks for Satellite

There's current one playbook.

## `commandline_assistant_proxy_satellite.yml`

Playbook to configure command-line assistant, new in RHEL 10 and 9.6, to talk
through Satellite for hosts that are registered to Satellite.

Currently, if you install command-line assistant, it wants to talk directly to
the customer portal. This is a problem if the host is already registered to
Satellite. The issue is that the host does not have a valid certificate to talk
to the customer portal, because its current certificate chain is trusted to the
Satellite server.

Therefore, this changes the configuration of command-line assistant to talk to
the new proxy port of Satellite 6.17+. This works, because Satellite itself has
a certificate chain that is trusted with the customer portal.
