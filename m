From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: btrfs write behavior on idle system
Date: Mon, 18 Jan 2010 18:17:56 +0100
Message-ID: <20100118171756.GA4165@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I am using btrfs for my /home partition since I upgraded my slow
laptop hdd for an ssd 3 weeks ago. I am always in sync with Linus'
tree of the day (plus a btrfs patch which is not in there yet) and
so far I haven't lost any data, so all is good. 

I have a question about the write behavior of the various [btrfs- ]
kernel threads, as I've been monitoring what is writing to the ssd
just in case.

So what I've been observing with 'iostat', 'iotop' and 'blktrace'
is the following. If my laptop is almost absolutely idle (just
a plain Window Maker and a few xterms and a couple dockapps open)
there is nothing writing to the disk (which is OK).

But as soon as I leave an open tab in chrome (or firefox) the various
[btrfs- ] threads start writing in my /home, and I don't know what.
For testing purposes, I mounted the config dir of chrome (~/.config/google-chrome)
in my SD card (at /dev/mmcblk0p1) to exclude the possibility of maybe chrome 
trying to update its history or something, so that it does not write
anything in my /home partition with btrfs.

But I see this in the output of 'iotop' from a 60 sec interval, showing
only the processes which wrote something:

Total DISK READ: 0 B/s | Total DISK WRITE: 10.26 K/s
  PID USER      DISK READ  DISK WRITE   SWAPIN    IO    COMMAND
  485 root           0 B/s    5.19 K/s  0.00 %  0.02 % [btrfs-transacti]
 3792 root           0 B/s       0 B/s  0.00 %  0.01 % [flush-btrfs-1]
  476 root           0 B/s    0.13 K/s  0.00 %  0.00 % [btrfs-delalloc-]
  481 root           0 B/s    4.93 K/s  0.00 %  0.00 % [btrfs-endio-wri]
  
and there are more instances like this. Is there a way to avoid (or reduce)
the writings of these threads? 

And when I start opening some pages in chrome and use it some more I
get many many writes on my /home partition from these threads (and swapper,
see below) even though I mounted the .config/google-chrome dir under 
/dev/mmcblk0p1 which uses ext4.

>From another experiment where chrome was showing a blank tab a ~7 minutes
run of 'blktrace -a write /dev/sda3' (sda3 is my /home) ends like this
(from 'blkparse -s sda3.blktrace.0'):


  8,3    1       73   432.719342409   485  I   W 27409442 + 8 [btrfs-transacti]
  8,3    1       74   432.719348765   485  C   W 27278498 + 8 [0]
  8,3    1        0   432.719355400     0  m   N cfq485 complete rqnoidle 1
  8,3    0     3244   432.719464704     0  D   W 27409442 + 8 [swapper]
  8,3    0     3245   432.719535525     0  C   W 27409442 + 8 [0]
  8,3    0     3246   432.719632676     0  C   W 27409442 + 8 [0]
btrfs-endio-met (2714)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        8,       40KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-endio-wri (481)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        1,        4KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-submit-0 (475)
 Reads Queued:           0,        0KiB  Writes Queued:         545,    2,412KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:      517,    2,308KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      415,    1,860KiB
 Read Merges:            0,        0KiB  Write Merges:            2,        8KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-transacti (485)
 Reads Queued:           0,        0KiB  Writes Queued:           8,       32KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        4,       16KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        3,       12KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
swapper (0)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       30,      120KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      128,      544KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0

CPU0 (sda3):
 Reads Queued:           0,        0KiB  Writes Queued:         540,    2,392KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:      542,    2,408KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      546,    2,424KiB
 Read Merges:            0,        0KiB  Write Merges:            2,        8KiB
 Read depth:             0               Write depth:            32
 IO unplugs:             0               Timer unplugs:           0
CPU1 (sda3):
 Reads Queued:           0,        0KiB  Writes Queued:          13,       52KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        9,       36KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        9,       36KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 Read depth:             0               Write depth:            32
 IO unplugs:             0               Timer unplugs:           0

Total (sda3):
 Reads Queued:           0,        0KiB  Writes Queued:         553,    2,444KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:      551,    2,444KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      555,    2,460KiB
 Read Merges:            0,        0KiB  Write Merges:            2,        8KiB
 IO unplugs:             0               Timer unplugs:           0

Throughput (R/W): 0KiB/s / 5KiB/s
Events (sda3): 6,463 entries
Skips: 0 forward (0 -   0.0%)




and see how the summary of processes lists only [btrfs- ] threads and
the swapper. And this is my 'idle' laptop while I am not saving anything
as far as I know.

[ I get really worried when I 'blktrace -a write' my /home when actively
  using chrome. Just a 2-minute experiment here while I was writing this
  email ended up like this:



  8,3    0        0   124.098327632     0  m   N cfq481 activate rq, drv=1
  8,3    0        0   124.099056219     0  m   N cfq481 complete rqnoidle 0
  8,3    0        0   124.099058803     0  m   N cfq481 set_slice=100
  8,3    0        0   124.099060968     0  m   N cfq schedule dispatch
Xorg (1111)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       13,       92KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       42,      532KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
blktrace (4226)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        8,      204KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-cache-127 (4267)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        1,        8KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-delalloc- (476)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       83,      724KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-endio-met (479)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        3,       16KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-endio-met (2714)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       23,      156KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       69,      304KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-endio-wri (481)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       27,      252KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-submit-0 (475)
 Reads Queued:           0,        0KiB  Writes Queued:       1,144,    7,280KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:      898,    5,772KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      563,    2,716KiB
 Read Merges:            0,        0KiB  Write Merges:           28,      236KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-transacti (485)
 Reads Queued:           0,        0KiB  Writes Queued:           6,       24KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       14,       68KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       41,      180KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
btrfs-worker-1 (2701)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        1,        4KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       12,      144KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
chrome (4180)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        6,      168KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
chrome (4228)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       12,       80KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
chrome (4238)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       92,      448KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       97,      424KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
exe (4248)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       20,      136KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:       32,      348KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
exe (4249)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        2,       12KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
exe (4253)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        5,       56KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
flush-btrfs-1 (4227)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        1,       88KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        8,       48KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
kondemand/1 (3910)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        2,       12KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
kthreadd (2)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        1,       12KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
swapper (0)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       60,      540KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      110,    1,072KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0
wmlaptop2 (1597)
 Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        1,        4KiB
 Read Merges:            0,        0KiB  Write Merges:            0,        0KiB
 IO unplugs:             0               Timer unplugs:           0
 Allocation wait:        0               Allocation wait:         0
 Dispatch wait:          0               Dispatch wait:           0
 Completion wait:        0               Completion wait:         0

CPU0 (sda3):
 Reads Queued:           0,        0KiB  Writes Queued:         432,    2,268KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:      418,    2,292KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      421,    2,288KiB
 Read Merges:            0,        0KiB  Write Merges:           16,      100KiB
 Read depth:             0               Write depth:            32
 IO unplugs:             0               Timer unplugs:           0
CPU1 (sda3):
 Reads Queued:           0,        0KiB  Writes Queued:         718,    5,036KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:      704,    5,012KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:      704,    5,028KiB
 Read Merges:            0,        0KiB  Write Merges:           12,      136KiB
 Read depth:             0               Write depth:            32
 IO unplugs:             0               Timer unplugs:           0

Total (sda3):
 Reads Queued:           0,        0KiB  Writes Queued:       1,150,    7,304KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:    1,122,    7,304KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:    1,125,    7,316KiB
 Read Merges:            0,        0KiB  Write Merges:           28,      236KiB
 IO unplugs:             0               Timer unplugs:           0

Throughput (R/W): 0KiB/s / 58KiB/s
Events (sda3): 17,035 entries
Skips: 0 forward (0 -   0.0%)


because having 7 Megs written in 2 minutes just by reading some webpages 
feels a bit strange.


So that is why I wanted to ask if other people using btrfs see the same
thing, if this is the expected behavior or if there is something
I can tweak to reduce the number of writes etc.



