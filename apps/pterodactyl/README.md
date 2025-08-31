## pterodactyl

This is a tweaked version of [ghcr.io/pterodactyl/panel](ghcr.io/pterodactyl/panel), but better suited for Kubernetes\*
Removes nginx and supervisord in favour of catatonit (not really direct comparison but 🤷)

Requires seperate nginx instance

\* still needs to run as root for now due to crond