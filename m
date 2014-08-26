Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51798 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaHZXjI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 19:39:08 -0400
Received: by mail-pa0-f48.google.com with SMTP id et14so24181638pad.35
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Aug 2014 16:39:08 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Aug 2014 19:39:08 -0400
Message-ID: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
Subject: ext4 vs btrfs performance on SSD array
From: Nikolai Grigoriev <ngrigoriev@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This is not exactly a problem - I am trying to understand why BTRFS
demonstrates significantly higher throughput in my environment.

I am observing something that I cannot explain. I am trying to come up
with a good filesystem configuration using HP P420i controller and
SSDs (Intel S3500). Out of curiosity I have tried BTRFS (still
unstable so I can't really expect to be able to use it) and noticed
that the read speed is about 150% of ext4 - while write speed is
comparable.

To be clear, I am using RAID0 with two SSDs with strip size of 256Kb.
I have 6 disks so I have created 3 logical disks, 2 SSDs each - just
for testing. And then I have formatted them with ext4, XFS and BTRFS.

When I write (something like dd if=/dev/zero of=test2 bs=512k
count=20000 conv=fdatasync,fsync) and watch the system using iostats,
I see that both BTRFS and EXT4 are writing at approximately the same
rate with similar number of write requests:

(ext4  - writing)
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb               0.00     0.00    0.00 1791.00     0.00   895.00
1023.43   141.73   78.97   0.56 100.00
(btrfs - writing)
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdc               0.00     0.00    0.00 1786.00     0.00   893.00
1024.00   137.87   77.21   0.56 100.10

When I read, I observe different picture:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
(ext4 - reading)
sdb               0.00     0.00 4782.00    0.00   597.75     0.00
256.00     1.57    0.33   0.18  84.10
(btrfs - reading)
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdc             207.00     0.00 1794.00    0.00   886.40     0.00
1011.90    10.59    5.90   0.56 100.00
(xfs - reading)
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdd               0.00     0.00 4623.00    0.00   577.88     0.00
256.00     1.71    0.37   0.21  97.00

And this is what I see if I just try to read the block device with dd:

(reading block device)
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb           132055.00     0.00 4259.00    0.00   532.38     0.00
256.00     1.61    0.38   0.23  99.80
sdc           131750.00     0.00 4250.00    0.00   531.25     0.00
256.00     1.58    0.37   0.24 100.00
sdc           142476.00     0.00 4596.00    0.00   574.50     0.00
256.00     1.61    0.35   0.20  92.40

All settings seem to be identical (I/O scheduler, readahead...) for
all 3 logical volumes.

So, everything else being equal, I clearly see that btrfs does much
fewer reads per second and clearly reads more bytes per second. And
that number of rrqm/s - this is the number of merged requests. I can
only see it on the device that is formatted with btrfs.

Kernel: 3.8.13-35.3.5.el6uek.x86_64 #2 SMP Fri Aug 8 21:58:11 PDT 2014
x86_64 x86_64 x86_64 GNU/Linux
Btrfs v0.20-rc1
#   btrfs fi show
Label: 'cassandra-data'  uuid: 6677e858-7a3e-4c76-861c-32977fd2fff9
    Total devices 1 FS bytes used 49.22GB
    devid    1 size 1.46TB used 60.02GB path /dev/sdc

Btrfs v0.20-rc1
# btrfs fi df /cassandra-data/disk2
Data: total=59.01GB, used=49.15GB
System: total=4.00MB, used=12.00KB
Metadata: total=1.01GB, used=72.20MB
dmesg:
btrfs: use ssd allocation scheme
btrfs: turning off barriers
btrfs: disk space caching is enabled

Puzzled... What is so special btrfs can do (and ext4 and xfs do not
do) to make such a difference?

P.S. No, compression is disabled with mount option compress=no



-- 
Nikolai Grigoriev
(514) 772-5178



-- 
Nikolai Grigoriev
(514) 772-5178
