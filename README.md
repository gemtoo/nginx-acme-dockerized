# Dockerized Nginx + ACME companion

## Why this exists?
To be able to easily spin up Nginx with automatic Let's Encrypt certificate generation.

## How to use it?
0. Ensure you are running as `root` user. Non-`root` users that are in `docker` group will have permission issues with Nginx.
1. Add your domain name(s) to `.env` file. Contents of the file should look something similar:
```
LETSENCRYPT_HOST=your-hosts.com,comma-separated.com,example.com
```
2. Spin up the containers. Read logs and wait for `acme` container to generate certificates for each of your domains.
```
docker compose up -d && docker compose logs -f
```
3. After `acme` has finished, create Nginx config(s) for your domain(s), using the provided sample. Then restart the stack to enable new config(s).
```
cd nginx-conf
cp -v sample.conf-inactive my-site.conf
sed -i "s/example.com/my-site.com/g" my-site.conf
docker compose restart
```