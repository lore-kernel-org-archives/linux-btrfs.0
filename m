From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.38-rc6] failing RAID1 and fsync EIO...
Date: Wed, 23 Feb 2011 14:35:59 +0800
Message-ID: <AANLkTikOVG11_M=F5CyHqoJpmcfPX_RFe+cT+F6zeTMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When pulling a disk from a full (ie data and metadata) RAID 1 array, I
see fsync(2) failing with EIO [1].

Reproduced easily [2].

Lastly, RAID 1 in BTRFS gives two copies of data regardless of number
of drives, right?

Daniel

--- [1]

$ fio workload.fio
f1: (g=0): rw=write, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
...
f1: (g=0): rw=write, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
f2: (g=1): rw=randwrite, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
...
f2: (g=1): rw=randwrite, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
f3: (g=2): rw=read, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
...
f3: (g=2): rw=read, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
f4: (g=3): rw=randread, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
...
f4: (g=3): rw=randread, bs=4K-128K/4K-128K, ioengine=sync, iodepth=1
fio 1.50.2
Starting 16 processes
f1: Laying out IO file(s) (1 file(s) / 1024MB)
f1: Laying out IO file(s) (1 file(s) / 1024MB)
f1: Laying out IO file(s) (1 file(s) / 1024MB)
f1: Laying out IO file(s) (1 file(s) / 1024MB)
f2: Laying out IO file(s) (1 file(s) / 1024MB)
f2: Laying out IO file(s) (1 file(s) / 1024MB)
f2: Laying out IO file(s) (1 file(s) / 1024MB)
f2: Laying out IO file(s) (1 file(s) / 1024MB)
f3: Laying out IO file(s) (1 file(s) / 1024MB)
fio: pid=0, err=5/file:filesetup.c:136, func=fsync, error=Input/output error
f3: Laying out IO file(s) (1 file(s) / 1024MB)
fio: pid=0, err=5/file:filesetup.c:136, func=fsync, error=Input/output error
f3: Laying out IO file(s) (1 file(s) / 1024MB)
fio: pid=0, err=5/file:filesetup.c:136, func=fsync, error=Input/output error
f3: Laying out IO file(s) (1 file(s) / 1024MB)
fio: pid=0, err=5/file:filesetup.c:136, func=fsync, error=Input/output error
f4: Laying out IO file(s) (1 file(s) / 1024MB)

--- [2]

cat - <<EOF >workload.fio
[global]
direct=0
directory=/mnt
size=1024m
bsrange=4k-128k
timeout=60
numjobs=4
[f1]
rw=write
[f2]
stonewall
rw=randwrite
[f3]
stonewall
rw=read
[f4]
stonewall
rw=randread
EOF

mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc
mount /dev/sdb /mnt
fio workload.fio
...
<pull sdb>
-- 
Daniel J Blueman
