## Build Docker container ##

```bash
docker build -t ansible-env .
```

## Run ansible playbook ##

```bash
docker run --rm -it -v "$(pwd):/app" ansible-env -i test_hosts.ini site.yml
```
