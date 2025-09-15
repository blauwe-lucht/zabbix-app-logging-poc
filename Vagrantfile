Vagrant.configure("2") do |config|

    # Ansible Control Server (ACS)
    config.vm.define "acs" do |acs|
        acs.vm.box = "almalinux/9"
        acs.vm.hostname = "acs"

        # We're using a private network which will result in a 'host-only' adapter,
        # which will make the VM accessible directly from the host machine.
        # We specify the IP-address so we can easily refer to each machine in Ansible.
        # We're going to use Visual Studio Code Remote SSH to connect to the machines,
        # so we need a way to make the SSH ports predictable (they're not by default).
        # So we explicitly specify the local SSH port for forwarding.
        # Notice that it is derived from the last two numbers of the IP address.
        # See https://realguess.net/2015/10/06/overriding-the-default-forwarded-ssh-port-in-vagrant/

        acs.vm.network "forwarded_port", id: "ssh", guest: 22, host: 2319
        
        acs.vm.provider "virtualbox" do |vb, override|
            override.vm.network "private_network", ip: "192.168.23.19"
            # Make sure all sensitive info is only readable by user (SSH requires this
            # when using private keys to connect to a VM).
            override.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]

            # Default is 1 GB, that is too small for ansible-lint.
            vb.memory = "2048"
            vb.cpus = 2
        end

        acs.vm.provider "vmware_workstation" do |vmware, override|
            override.vm.network "private_network", ip: "192.168.66.19"
            override.vm.synced_folder ".", "/vagrant", mount_options: ["uid=1000,gid=1000"]

            # Default is 1 GB, that is too small for ansible-lint.
            vmware.memory = "2048"
            vmware.cpus = 2
        end

        # Do the initial setup of the ACS with a script.
        acs.vm.provision "shell" do |shell|
            shell.inline = <<-SHELL
                set -euxo pipefail

                # To be able to correctly use the Zabbix server API, we need to use a recent version
                # of the community.zabbix collection (>= 3.0.0). This requires a newer version of Ansible than 2.15.
                # However the latest version of Ansible requires a newer version of Python.
                # AlmaLinux 9 ships with Python 3.9, Ansible 2.18 requires Python 3.11.
                dnf install -y python3.11 python3.11-pip

                # Pip prefers to run in a virtual environment, so we create one for the vagrant user
                # and use pip from that venv to install ansible and ansible-lint.
                sudo -u vagrant bash -c '
                    set -euxo pipefail

                    python3.11 -m venv /home/vagrant/venv-ansible
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
    end

    # Application server
    config.vm.define "app" do |app|
        app.vm.box = "almalinux/9"
        app.vm.hostname = "app"

        app.vm.provider "virtualbox" do |vb, override|
            override.vm.network "private_network", ip: "192.168.23.20"
        end

        app.vm.provider "vmware_workstation" do |vmware, override|
            override.vm.network "private_network", ip: "192.168.66.20"
        end

        # The rest of the server will be configured using Ansible.
    end

    # Zabbix server
    config.vm.define "zabbix" do |zabbix|
        zabbix.vm.box = "blauwelucht/zabbix-server"
        zabbix.vm.box_version = "7.4.2"
        zabbix.vm.hostname = "zabbix"

        zabbix.vm.provider "virtualbox" do |vb, override|
            override.vm.network "private_network", ip: "192.168.23.21"
        end

        zabbix.vm.provider "vmware_workstation" do |vmware, override|
            override.vm.network "private_network", ip: "192.168.66.21"
        end

        # Ansible needs Python before it can do anything, so install it.
        zabbix.vm.provision "shell" do |shell|
            shell.inline = <<-SHELL
                yum install -y python3.12
            SHELL
        end

        # The rest of the server will be configured using Ansible.
    end
end
