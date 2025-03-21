Vagrant.configure("2") do |config|

    # Ansible Control Server (ACS)
    config.vm.define "acs" do |acs|
        acs.vm.box = "almalinux/9"
        acs.vm.hostname = "acs"

        # We're using a private network which will result in a 'host-only' adapter,
        # which will make the VM accessible directly from the host machine.
        # We specify the IP-address so we can easily refer to each machine in Ansible.
        acs.vm.network "private_network", ip: "192.168.3.19"

        # We're going to use Visual Studio Code Remote SSH to connect to the machines,
        # so we need a way to make the SSH ports predictable (they're not by default).
        # So we explicitly specify the local SSH port for forwarding.
        # Notice that it is derived from the last two numbers of the IP address.
        # See https://realguess.net/2015/10/06/overriding-the-default-forwarded-ssh-port-in-vagrant/
        acs.vm.network "forwarded_port", id: "ssh", guest: 22, host: 2319
        
        # Make sure all sensitive info is only readable by user (SSH requires this
        # when using private keys to connect to a VM).
        acs.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]

        # Do the initial setup of the ACS with a script.
        acs.vm.provision "shell" do |shell|
            shell.inline = <<-SHELL
                set -euxo pipefail

                # Pip prefers to run in a virtual environment, so we create one for the vagrant user
                # and use pip from that venv to install ansible and ansible-lint.
                sudo -u vagrant bash -c '
                    set -euxo pipefail

                    python -m venv /home/vagrant/venv-ansible
                    . /home/vagrant/venv-ansible/bin/activate
                    pip install --upgrade pip
                    pip install ansible ansible-lint pywinrm

                    # Make sure we always use ansible from the virtualenv.
                    # The if is needed to prevent multiple venv names in the prompt.
                    echo "if [[ -z \"\\$VIRTUAL_ENV\" ]]; then" >> ~/.bashrc
                    echo "    . ~/venv-ansible/bin/activate" >> ~/.bashrc
                    echo "fi" >> ~/.bashrc
                '
            SHELL
        end
        acs.vm.provider "virtualbox" do |vb|
            # Default is 1 GB, that is too small for ansible-lint.
            vb.memory = "2048"
            vb.cpus = 2
        end
    end

    # Application server
    config.vm.define "app" do |app|
        app.vm.box = "almalinux/9"
        app.vm.hostname = "app"
        app.vm.network "private_network", ip: "192.168.3.20"

        # The rest of the server will be configured using Ansible.
    end

    # Zabbix server
    config.vm.define "zabbix" do |zabbix|
        zabbix.vm.box = "blauwelucht/zabbix-server"
        zabbix.vm.hostname = "zabbix"
        zabbix.vm.network "private_network", ip: "192.168.3.21"

        # The rest of the server will be configured using Ansible.
    end
end
