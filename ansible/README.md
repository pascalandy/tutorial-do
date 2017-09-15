## Install Ansible ##

```bash
pip install ansible
```

## Install required Ansible roles ##

Roles are ways of automatically loading certain vars_files, tasks, and handlers based on a known file structure. Grouping content by roles also allows easy sharing of roles with other users.

```bash
ansible-galaxy install -r requirements.yml
```

## Run ansible against Docker conainer (for tests) ##

```bash
ansible-playbook -i test_hosts.ini test.yml
```
