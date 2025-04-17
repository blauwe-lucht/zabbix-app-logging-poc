# zabbix-logging-ansible-poc

Proof of concept that shows how to configure Zabbix so it can monitor if an application is starting successfully.

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) (vscode)
- [VirtualBox](https://www.virtualbox.org/), tested with version 7.0 (7.1 didn't work)
- [Vagrant](https://www.vagrantup.com/), tested with version 2.4.3

## Usage

1. ```vagrant up```
This will create three VMs: acs (Linux machine with Ansible installed), app (server where the application is running) and zabbix (Zabbix server).
2. Install the [Remote SSH extension](https://code.visualstudio.com/docs/remote/ssh) in vscode
3. In vscode: F1 -> Remote-SSH: Open SSH Configuration File, select the one in your user directory, add

    ``` ssh
    Host acs
        HostName 192.168.3.19
        User vagrant
        IdentityFile <path to project>/.vagrant/machines/acs/virtualbox/private_key
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
    ```

4. In vscode left click the connection button in the bottom left (blue or green with something that
looks like ><) or press F1 and select Remote-SSH: Connect to Host. Select host 'acs', select Linux.
Vscode will now install everything that is needed to work with files on the acs. When it's ready, open
the directory /vagrant on the acs. Trust the directory. Install the recommended extensions
([Ansible](https://marketplace.visualstudio.com/items?itemName=redhat.ansible) and
[Ansible Go to Definition](https://marketplace.visualstudio.com/items?itemName=BlauweLucht.ansible-go-to-definition)).
5. In vscode open a terminal window and type:

    ``` bash
    cd /vagrant/ansible
    ansible-playbook playbook.yml -v
    ```

6. Wait for a bit and if everything went fine, app and zabbix will be configured.
The Zabbix web UI can be accessed at http://192.168.3.21, user Admin, password zabbix.

## Clean up

In the original vscode instance (so not in the Remote-SSH session) or in a command prompt, go to the
project directory and type:

``` bash
vagrant destroy -f
```
