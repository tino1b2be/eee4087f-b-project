#!/bin/bash

# Code modified from https://github.com/vbtdung/dctcp-assignment

bws="10 20 40 80 160 320"
t=20
n=6
maxq=425
expt="ecn" # change this to dctcp or tcp to test the other protocols

if [ "$UID" != "0" ]; then
    warn "Please run as root"
    exit 0
fi

finish() {
    # Clean up
    killall -9 python iperf
    mn -c
    exit
}

clean_text_files () {
    # Remove random output character in the text file
    dir=${1:-/tmp}
    pushd $dir
    mkdir -p clean
    for f in *.txt; do
        echo "Cleaning $f"
        cat $f | tr -d '\001' > clean/$f
    done
    popd
}

trap finish SIGINT

function tcp {
	bw=$1
	odir=tcp-n$n-bw$bw
	sudo python dctcp.py --bw $bw --maxq $maxq --dir $odir -t $t -n $n
	sudo python ../util/plot_rate.py --maxy $bw -f $odir/txrate.txt -o $odir/rate.png
	sudo python ../util/plot_queue.py -f $odir/qlen_s1-eth1.txt -o $odir/qlen.png
	sudo python ../util/plot_tcpprobe.py -f $odir/tcp_probe.txt -o $odir/cwnd.png
}

function ecn {
	bw=$1
	odir=tcpecn-n$n-bw$bw
	sudo python dctcp.py --bw $bw --maxq $maxq --dir $odir -t $t -n $n --ecn
	sudo python ../util/plot_rate.py --maxy $bw -f $odir/txrate.txt -o $odir/rate.png
	sudo python ../util/plot_queue.py -f $odir/qlen_s1-eth1.txt -o $odir/qlen.png
	sudo python ../util/plot_tcpprobe.py -f $odir/tcp_probe.txt -o $odir/cwnd.png
}

function dctcp {
    bw=$1
    odir=dctcp-n$n-bw$bw
	sudo python dctcp.py --bw $bw --maxq $maxq --dir $odir -t $t -n $n --dctcp
	sudo python ../util/plot_rate.py --maxy $bw -f $odir/txrate.txt -o $odir/rate.png
	sudo python ../util/plot_queue.py --maxy 50 -f $odir/qlen_s1-eth1.txt -o $odir/qlen.png
	sudo python ../util/plot_tcpprobe.py -f $odir/tcp_probe.txt -o $odir/cwnd.png
}

for bw in $bws; do
 
    dir=$expt-n$n-bw$bw
    mkdir -p $dir
    odir=$expt-n$n-bw$bw

    # Start the experiment
    if [ "$expt" == "tcp" ]; then 
	sudo python dctcp.py --bw $bw --maxq $maxq --dir $odir -t $t -n $n
    elif [ "$expt" == "ecn" ]; then
	sudo python dctcp.py --bw $bw --maxq $maxq --dir $odir -t $t -n $n --ecn
    elif [ "$expt" == "dctcp" ]; then
	sudo python dctcp.py --bw $bw --maxq $maxq --dir $odir -t $t -n $n --dctcp
    fi

    # Run plotting scripts
	sudo python ../util/plot_rate.py --maxy $bw -f $odir/txrate.txt -o $odir/rate.png
	sudo python ../util/plot_queue.py --maxy 50 -f $odir/qlen_s1-eth1.txt -o $odir/qlen.png
	sudo python ../util/plot_tcpprobe.py -f $odir/tcp_probe.txt -o $odir/cwnd.png

    #clean_text_files $dir
    wait

done

finish
