# Setting up a working environment

## Logging into Jupyter Hub

Log into your Jupyter Hub account with the supplied username and password.

Once Jupyter Lab appears, from the **Launcher** page on the right, open a terminal session by clicking the **Terminal** icon found in the section **Other**. Doing so will open a Bash shell (a command-line interface) which we will use to perform our analyses. 

!!! info 
    Much of bioinformatical analysis is driven by the command-line and a researcher interested in carrying out their own work will find it essential to develop some profficiency. 
    Though it may seem antiquated to the uninitiated, the command-line is a powerful means of controlling a computer.

## Installing conda

Conda is a user-space package management tool which aims to simplify obtaining and setting up complicated software tools. 
Although it is not a perfect solution, it allows users to install both a software package and the required dependencies without the help of a system-administrator. 

Two other approaches to this problem are Docker and Singularity. 
These tools use the operating system concept of [lightweight containers](https://en.wikipedia.org/wiki/LXC){:target="_blank"} to compartmentalise software into tiny walled gardens. 
This approach is likely to become the standard means of accessing bioinformatics software in the future.

To install conda, copy and paste the commands below to download and then run the installer:

!!! example "Setting up conda"
    ```
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh
    ```

!!! warning "Don't go too fast here"
    Be sure to answer `yes` to the license agreement **^^and^^** the question about installing the configuration to the `.bashrc` file. 
    If not, conda will not be configured properly.

### Close and reopen your shell

After the installation has completed, close your terminal session and reopen it. 
This is the easiest method of properly initialising the shell to use conda.

If the installation has been successful, there should be no error messages and your shell prompt will now include the label `(base)`. 
This label changes depending on conda environment you have activated and by default you start in "base". 

### Lets prepare conda for bioinformatics 

Conda obtains software that you request from online repositories, which it calls channels. 
Since this is a general purpose tool, the default repositories contain little in the way of scientific software. 
To remedy this situation, we will add two channels: conda-forge (a broad general repository) and bioconda (specialist tools related to biological analysis).

Once added, conda will search for software in these extra channels as well.

!!! example "Additional conda channels"
    ```
    conda config --add channels conda-forge --add channels bioconda
    ```

## And we're ready

You should now be ready to start analysing biological data. Let's move on to the next section dealing [Quality Control](/qc)

## Ways to get started without using Amazon Web Services

Not everyone will have access to Amazon EC2, or may not have access all the time.
Another alternative is to run a Linux VM locally, provided that you have access to a computer with enough RAM and free storage space.
One way to do this is to install VirtualBox on your machine, and then obtain an Ubuntu 18.04 LTS image to start up.
This tutorial won't cover how to do this but don't worry, it's not hard.
Plenty of people have documented how to do it.
Look around, [duckduckgo](https://duckduckgo.com){:target="_blank"} is your friend.
