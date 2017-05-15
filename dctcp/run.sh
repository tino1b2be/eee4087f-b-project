bw_sender=100
bw_receiver=100
delay=0.25
qsize=120
# Expt 1 : Queue occupancy over time - comparing DCTCP & TCP
dir1=dctcp-q$qsize
time=10
dir2=tcp-q$qsize
#Make directories for TCP, DCTCP and the comparison graph
mkdir $dir1 $dir2 $dirResult 2>/dev/null
# Measure queue occupancy with DCTCP
python dctcp.py --bw-sender $bw_sender \
                --bw-receiver $bw_receiver \
                --delay $delay \
                --dir $dir1 \
                --maxq $qsize \
                --time $time \
                --n 3 \
                --enable-ecn 1 \
                --enable-dctcp 1 \
                --expt 1

# Measure queue occupancy with TCP
python dctcp.py --bw-sender $bw_sender \
                --bw-receiver $bw_receiver \
                --delay $delay \
                --dir $dir2 \
                --maxq $qsize \
                --time $time \
                --n 3 \
                --enable-ecn 0 \
                --enable-dctcp 0 \
                --expt 1

# Plot comparison graph
python plot_queue.py -f $dir1/q.txt $dir2/q.txt \
                     --legend DCTCP TCP -o $dirResult/q.png

# Remove intermediate folder  
rm -rf $dir1 $dir2