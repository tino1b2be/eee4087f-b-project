# eee4087f-b-project

* Launch an AWS EC2 Instance using the AMI image "cs244-mininet-mptcp-dctcp (ami-a04ac690)"
* ssh into the instance
* clone the git repo
	`git clone https://github.com/tino1b2be/eee4087f-b-project.git`
* cd into `~/eee4087f-b-project/dctcp`
* mark the `run-dctcp.sh` script as executable
	`chmod +x run-dctcp.sh`
* run the script to start the simulations:
	`sudo ./run-dctcp.sh`
* To change the protocols in the simulations edit `run-dctcp.sh` and change the `expt` variable to `tcp`, `dctcp` or `ecn`
* All the outputs and plots are stored in [a]-n[b]-bw[c] directories where [a] is the running mode, [b] is the number of hosts and [c] is the network throughput.
