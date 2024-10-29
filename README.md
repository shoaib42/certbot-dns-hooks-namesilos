# certbot-dns-hooks-namesilos

## Example use

Using this for DNS challenge to get a wild card certificate for subdomain `home.example.com`

Set the `SUBDOMAIN` in both scripts as (appending `.home` to subdomain)

```
SUBDOMAIN="_acme-challenge.home"
```

Then execute
```
certbot certonly --manual --preferred-challenges=dns --manual-auth-hook /usr/local/sbin/ns-dns-challenge/authenticator.sh --manual-cleanup-hook /usr/local/sbin/ns-dns-challenge/cleanup.sh -d "home.example.com" -d "*.home.example.com"
```
