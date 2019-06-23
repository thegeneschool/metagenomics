# Setting up a working environment (Jupyter)

In these tutorials we will work in a Jupyter notebook server environment.
Jupyter is a versatile web interface system for data analysis, supporting work in languages such as Python and R, as well as the unix command-line.
If you are working through this tutorial in one of The Gene School workshops we will provide a pre-configured Jupyter server for you to use and there is no need to carry out the setup process described on this page.

## Launch a server via Amazon Web Services EC2

First, either log in or sign up for AWS and navigate to to the EC2 section.
Then select the option to launch a new instance. We will use the Ubuntu 18.04 LTS base image in this example.
As you continue to click through the instance configuration details, there are two important settings that need to be changed from defaults: (1) the disk volume size, which should be set to 500GB or more to give ample space for metagenomic datasets (note that this will incur costs), and (2) the security groups settings. In the security groups, you will need to add access to TCP port 8888 for the IP address from which you'll be connecting to the servers. If you don't know your source IP range then this can be set to `0.0.0.0/0` but note the that this will enable the whole world to connect to the server and there is a security risk, even if the Jupyter server is password or token protected.

If this is the first time you've used AWS you will need to generate and save an ssh key that will be used to log into the VMs. Keep this in a safe place. It will need to be made read only to the user account before it can be used with ssh, e.g. `chmod 400 my_aws_key.pem`

## Log in and launch Jupyter

Having started up an AWS instance you are now ready to log in and install Jupyter.
The process is fairly straightforward. First ssh into the instance: `ssh -i my_aws_key.pem ubuntu@XX.XX.XX.XX` where XX.XX.XX.XX is the public IP address shown in the AWS EC2 console for the VM you have launched.
Once logged in there are a few steps to installing the Jupyter server. First download and install anaconda:

```
wget https://repo.anaconda.com/archive/Anaconda3-2018.12-Linux-x86_64.sh
bash Anaconda3-2018.12-Linux-x86_64.sh
```

Be sure to answer `yes` to the license question and the question about installing the configuration to the `.bashrc` file.

Many of the steps in the tutorial involve command-line work, so let's also install the bash kernel:
```
pip install bash_kernel
python -m bash_kernel.install
```

Now we're ready to launch a jupyter server:

```
source .bashrc
jupyter lab --no-browser --ip 0.0.0.0 --LabApp.token=112233445566778899
```

IMPORTANT: replace the string of numbers `112233445566778899` with your own string -- this is the secret key that will allow you (and only you) to connect to your jupyter server and run commands, so you want something that neither human nor robot will guess. Hexadecimal (lowercase) values are ok here too.

## Connect to the Jupyter web interface

We're finally ready to connect to the web interface. To do so simply point your browser at `XX.XX.XX.XX:8888` where XX.XX.XX.XX is again the public IP address of the VM that you've launched in AWS. 8888 is the TCP port number that Jupyter listens on by default, and we added a special security rule to open this port when creating the VM in AWS (remember?). If you missed that step, don't worry, it's possible to go into the EC2 dashboard and update the security settings to open port 8888. Assumming everything has worked you'll arrive at a Jupyter page asking for the security token. This is where you provide the super secret number that you selected above. And that's it, you're ready to use Jupyter!

## Other software

Some of the steps in the tutorial use [singularity](https://singularity.lbl.gov) or [docker](https://docker.com) to run analysis tools.
To carry out those steps singularity will need to be installed on the machine:
```bash
sudo apt install -y singularity-container docker.io
```

Docker requires a few extra steps to begin working 
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## Ways to get started without using Amazon Web Services

Not everyone will have access to Amazon EC2, or may not have access all the time.
Another alternative is to run a Linux VM locally, provided that you have access to a computer with enough RAM and free storage space.
One way to do this is to install VirtualBox on your machine, and then obtain an Ubuntu 18.04 LTS image to start up.
This tutorial won't cover how to do this but don't worry, it's not hard.
Plenty of people have documented how to do it.
Look around, [duckduckgo](https://duckduckgo.com) is your friend.

