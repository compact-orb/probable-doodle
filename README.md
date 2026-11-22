# probable-doodle

Ansible playbook to manage `mail-mcp` and NGINX.

## Secrets Setup

Place secrets in `/etc/ansible/secrets.yml` on the target host:

```yaml
---
secrets:
  domain_name: "mail.example.com"
  certbot_email: "admin@example.com"
  mcp_secret_path: "generate-a-secure-random-token"

  gmail_personal:
    user: "personal@gmail.com"
    client_id: "google-oauth-client-id"
    client_secret: "google-oauth-client-secret"
    refresh_token: "google-oauth-refresh-token"

  outlook_personal:
    user: "personal@outlook.com"
    client_id: "microsoft-oauth-client-id"
    client_secret: "none"
    refresh_token: "microsoft-personal-refresh-token"

  outlook_work:
    user: "work@company.com"
    client_id: "microsoft-oauth-client-id"
    client_secret: "none"
    refresh_token: "microsoft-work-refresh-token"

  gmail_school:
    user: "school@university.edu"
    client_id: "google-oauth-client-id"
    client_secret: "google-oauth-client-secret"
    refresh_token: "google-oauth-refresh-token"
```

Set permissions:
```bash
chmod 0600 /etc/ansible/secrets.yml
```

## Deployment

```bash
sudo ansible-pull \
  --directory=/var/lib/ansible/probable-doodle \
  --url=https://github.com/compact-orb/probable-doodle.git
```
