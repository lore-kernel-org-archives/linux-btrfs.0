From: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Subject: Poor read performance on high-end server
Date: Thu, 05 Aug 2010 16:05:33 +0200
Message-ID: <4C5AC52D.9030906@sara.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

We're interested in getting the highest possible read performance on a
server. To that end, we have a high-end server with multiple solid state
disks (SSDs). Since BtrFS outperformed other Linux filesystem, we choose
that. Unfortunately, there seems to be an upper boundary in the
performance of BtrFS of roughly 1 GiByte/s read speed. Compare the
following results with either BTRFS on Ubuntu versus ZFS on FreeBSD:

             ZFS             BtrFS
1 SSD      256 MiByte/s     256 MiByte/s
2 SSDs     505 MiByte/s     504 MiByte/s
3 SSDs     736 MiByte/s     756 MiByte/s
4 SSDs     952 MiByte/s     916 MiByte/s
5 SSDs    1226 MiByte/s     986 MiByte/s
6 SSDs    1450 MiByte/s     978 MiByte/s
8 SSDs    1653 MiByte/s     932 MiByte/s
16 SSDs   2750 MiByte/s     919 MiByte/s

The results were originally measured on a Dell PowerEdge T610, but were
repeated using a SuperMicro machine with 4 independent SAS+SATA
controllers. We made sure that the PCI-e slots where not the bottleneck.
The above results were for Ubuntu 10.04.1 server, with BtrFS v0.19,
although earlier tests with Ubuntu 9.10 showed the same results.

Apparently, the limitation is not in the hardware (the same hardware
with ZFS did scale near linear). We also tested both hardware RAID-0,
software RAID-0 (md), and using the btrfs built-in software RAID-0, but
the differences were small (<10%) (md-based software RAID was marginally
slower on Linux; RAIDZ was marginally faster on FreeBSD). So we presume
that the bottleneck is somewhere in the BtrFS (or kernel) software.

Are there suggestions how to tune the read performance? We like to scale
this up to 32 solid state disks. The -o ssd option did not improve
overall performance, although it did gave more stable results (less
fluctuation in repeated tests).

Note that the write speeds did scale fine. In the scenario with 16 solid
state disks, the write speed is 1596 MiByte/s (1.7 times as fast as the
read speed! Suffice to say that for a single disk, write is much slower
than read...).

Here are the exact settings:
~# mkfs.btrfs -d raid0 /dev/sdd /dev/sde /dev/sdf /dev/sdg \
     /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm \
     /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds
nodesize 4096 leafsize 4096 sectorsize 4096 size 2.33TB
Btrfs Btrfs v0.19
~# mount -t btrfs -o ssd /dev/sdd /mnt/ssd6
~# iozone -s 32G -r 1024 -i 0 -i 1 -w -f /mnt/ssd6/iozone.tmp
              KB  reclen   write rewrite    read    reread
        33554432    1024 1628475 1640349   943416   951135

Regards,
Freek Dijkstra
SARA high performance- and computing
