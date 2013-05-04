Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1464 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932545Ab3EDBPy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 21:15:54 -0400
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>)
	id 1UYR4l-0006zZ-Hv
	for linux-btrfs@vger.kernel.org; Sat, 04 May 2013 11:15:47 +1000
Date: Sat, 4 May 2013 11:15:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-btrfs@vger.kernel.org
Subject: [3.9] parallel fsmark perf is real bad on sparse devices
Message-ID: <20130504011547.GB19978@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

It's that time again - I ran fsmark on btrfs and found performance
was awful.

tl;dr: memory pressure causes random writeback of metadata ("bad"),
fragmenting the underlying sparse storage. This causes a downward
spiral as btrfs cycles through "good" IO patterns that get
fragmented at the device level due to the "bad" IO patterns
fragmenting the underlying sparse device.

FYI, The storage hardware is a DM RAID0 stripe across 4 SSDs sitting
behind 512MB of BBWC with an XFS filesystem on it. The only file on
the filesystem is the sparse 100TB file used for the device, and the
VM is using virtio,cache=none to access the filesystem image.

i.e. the storage I'm working on this time is a thinly provisioned
100TB device fed to an 8p, 4GB RAM VM, and this script is then run:

$ cat fsmark-50-test-btrfs.sh 
#!/bin/bash

sudo umount /mnt/scratch > /dev/null 2>&1
sudo mkfs.btrfs /dev/vdc
sudo mount /dev/vdc /mnt/scratch
sudo chmod 777 /mnt/scratch
cd /home/dave/src/fs_mark-3.3/
time ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  63 \
        -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
        -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
        -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
        -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
        | tee >(stats --trim-outliers | tail -1 1>&2)
sync
$
$ ./fsmark-50-test-btrfs.sh

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdc
        nodesize 4096 leafsize 4096 sectorsize 4096 size 100.00TB
Btrfs Btrfs v0.19

#  ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  63  -d  /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6  -d  /mnt/scratch/7
#       Version 3.3, 8 thread(s) starting at Fri May  3 17:08:46 2013
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     0       800000            0      53498.9          7898900
     0      1600000            0      11186.5          9409278
     0      2400000            0      17026.1          7907599
     0      3200000            0      25815.6          9749980
     0      4000000            0      11503.0          8556349
     0      4800000            0      43561.9          8295238
     0      5600000            0      17175.3          8304668
^C     0 800000-5600000(3.2e+06+/-1.1e+06)            0 11186.500000-53498.900000(23016.4+/-1.1e+04) 7898900-9749980(8.49463e+06+/-5e+05)

What I'm seeing is that the underlying image file is getting badly,
badly fragmented. This short test created approximately 8 million
extents in the image file in about 10 minutes runtime. Running
xfs_fsr on the image file pointed this out:

# xfs_fsr -d -v vm-100TB-sparse.img
vm-100TB-sparse.img
vm-100TB-sparse.img extents=7971773 can_save=7926036 tmp=./.fsr6198
DEBUG: fsize=109951162777600 blsz_dio=16773120 d_min=512
d_max=2147483136 pgsz=4096
Temporary file has 46107 extents (7971773 in original)
extents before:7971773 after:46107      vm-100TB-sparse.img
#

Most of the data written to the file is contiguous. This means that
btrfs is filling the filesystem in a contiguous manner, but it's IO
is anything but contiguous. So, what's happening here?

Turns out that when the machine first runs out of free memory (about
1.2m inodes in), btrfs goes from running a couple of hundred nice
large 512k IOs a second to an intense 10s long burst of 10-15kiops
of tiny random IOs. Looking at it from the IO completion side of
things:

253,32   4      238     5.936043934     0  C   W 103680 + 1024 [0]
253,32   4      239     5.936155917     0  C   W 2201728 + 1024 [0]
253,32   4      240     5.936172087     0  C   W 104704 + 1024 [0]
253,32   4      241     5.936283060     0  C   W 2202752 + 1024 [0]
253,32   4      242     5.936294881     0  C   W 105728 + 1024 [0]
253,32   4      243     5.936385182     0  C   W 106752 + 1024 [0]
253,32   4      244     5.936394695     0  C   W 107776 + 1024 [0]
253,32   4      245     5.936402936     0  C   W 108800 + 1024 [0]
253,32   4      246     5.936406721     0  C   W 109824 + 896 [0]
253,32   4      247     5.936414258     0  C   W 2203776 + 1024 [0]
253,32   4      248     5.936515302     0  C   W 2204800 + 1024 [0]
253,32   4      249     5.936606737     0  C   W 2205824 + 1024 [0]
253,32   4      250     5.936689345     0  C   W 2206848 + 1024 [0]

All nice and large, mostly sequential IO patterns. Fast foward to
where we've run out of memory:

253,32   3    59209    31.490788795     0  C  WS 1821992 + 16 [0]
253,32   3    59210    31.490790691     0  C  WS 1822024 + 24 [0]
253,32   3    59211    31.490792205     0  C  WS 1822056 + 16 [0]
253,32   3    59212    31.490793680     0  C  WS 1822080 + 8 [0]
253,32   3    59213    31.490794984     0  C  WS 1822096 + 32 [0]
253,32   3    59214    31.490796307     0  C  WS 1822136 + 8 [0]
253,32   3    59215    31.490798261     0  C  WS 1822152 + 16 [0]
253,32   3    59216    31.490799713     0  C  WS 3919120 + 8 [0]
253,32   3    59217    31.490831740     0  C  WS 3919144 + 16 [0]
253,32   3    59218    31.490835419     0  C  WS 3919176 + 24 [0]
253,32   3    59219    31.490838989     0  C  WS 3919208 + 16 [0]

You can see that there are lots of small IOs being completed, with
lots of tiny holes in between them. This is what causes the
fragmentation of the backing device image. Performance hasn't quite
tanked yet - that happens after the massive burst of IO when
reclaiming memory. btrfs goes back to nice IO patterns:

53,32   4   114006    40.036082347  6902  C   W 4268032 + 896 [0]
253,32   4   114007    40.036088989  6902  C   W 4268928 + 896 [0]
253,32   4   114008    40.036104027  6902  C   W 4269824 + 896 [0]
253,32   4   114009    40.036108753  6902  C   W 4270720 + 896 [0]
253,32   4   114010    40.036112097  6902  C   W 4271616 + 896 [0]
253,32   4   114011    40.036116985  6902  C   W 5316608 + 896 [0]
253,32   4   114012    40.036189985  6902  C   W 5317504 + 896 [0]
253,32   4   114013    40.036259904  6902  C   W 5318400 + 896 [0]

But because it's already fragmented the crap out of the underlying
file image and thanks to the wonder of the kernel direct IO doing in
individual allocation for every vector in the pwritev() iovec (i.e.
one allocation per 4k page), this further fragments the underlying
file as it fills small holes first. The result is that btrfs is
doing a couple of hundred IOPS, but the back end storage is now
doing 25,000 IOPS because of the fragmentation of the image file.

Worth noting is that btrfs is filling the filesystem from block 0
upwards - punching the first 100GB out of the image file removes all
the fragmentation from the file (6m extents down to 21000) - all the
higher address space extents are from XFS....

So, BTRFS doesn't play at all well with sparse image files or
fine-grained thin provisioned devices, and the cause of the problem
is the IO behaviour in low memory situations.

Cheers,

Dave.

(*) The btrfs result when the underlying image file is not
fragmented is this:

FSUse%        Count         Size    Files/sec     App Overhead
     0       800000            0      57842.6          6955654
     0      1600000            0      50669.6          7507264
     0      2400000            0      46375.2          7038246
     0      3200000            0      51564.7          7028544
     0      4000000            0      44751.0          7019479
     0      4800000            0      49647.7          7748393
     0      5600000            0      45121.4          6980789
     0      6400000            0      36758.9          8387095
     0      7200000            0      15014.6          8291624

Note that I'd only defragmented the first 6 million inode region,
so perf tanked at around that point as fragmentation started again.
Here's the equivalent XFS run:

FSUse%        Count         Size    Files/sec     App Overhead
     0       800000            0     106989.2          6862546
     0      1600000            0      99506.5          7024546
     0      2400000            0      88726.5          8085128
     0      3200000            0      90616.9          7709196
     0      4000000            0      93900.0          7323644
     0      4800000            0      94869.2          7166322
     0      5600000            0      92693.4          7213337
     0      6400000            0      92217.6          7178681
     0      7200000            0      95983.9          7075248
     0      8000000            0      95096.8          7182689
     0      8800000            0      95350.1          7160214

which runs at about 500 iops and results in almost no underlying
device fragmentation at all. Hence BTRFS is running at roughly half
the speed of a debug XFS kernel on this workload on my setup.

I'd be remiss not to mention ext4 performance on this workload, too:

FSUse%        Count         Size    Files/sec     App Overhead
     5       800000            0      37948.7          5674131
     5      1600000            0      35918.5          5941488
     5      2400000            0      33313.1          6427143
     5      3200000            0      36491.2          6587327
     5      4000000            0      35426.2          6027680
     5      4800000            0      33323.9          6501011
     5      5600000            0      35292.6          6016546
     5      6400000            0      37851.4          6327824
     5      7200000            0      34384.9          5897006

Yeah, it sucks worse than btrfs when the underlying image is not
fragmented. However, ext4 is fragmenting the underlying device just
as badly as btrfs is - it's creating about 100k fragments per
million inodes allocated. However, the fragmentation is not
affecting performance as there's a 1:1 ratio between ext4 IOs and
IOs to the physical device through the image file.

As it is, ext4 is sustaining about 6000 iops - an order of
magnitude more than XFS and the "good" BTRFS IO patterns, and only
managing to use about 2 CPUs of the 8p in the system. The back end
storage is at about 50% utilisation so it isn't the bottleneck -
there's other bottlenecks in ext4 that limit it's performance under
these sorts of workloads.

IOWs, XFS runs this workload at about 2% storage utilisation and
750% CPU utilisation, btrfs at about 600% CPU utilisation and ext4
at 50% storage and 200% CPU utilisation. This says a lot about the
inherent parallelism in the filesystem architectures...

FWIW, A comparision with the fsmark testing I did on this 8p/4GB RAM
VM I reported on 18 months ago at LCA:

	- XFS is at roughly the same performance/efficiency point,
	  but with added functionality
	- btrfs is about 30% slower (on a non-fragmented device),
	  consumes more CPU and has some interesting new warts, but
	  it is definitely more stable as it is completing tests
	  rather than hanging half way through.
	- ext4 performance has dropped by half for this 8-way
	  workload....
-- 
Dave Chinner
david@fromorbit.com
