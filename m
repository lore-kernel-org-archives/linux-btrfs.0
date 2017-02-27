Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29535 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbdB0PrZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 10:47:25 -0500
Date: Mon, 27 Feb 2017 07:46:20 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: John Marrett <johnf@zioncluster.ca>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Low IOOP Performance
Message-ID: <20170227154620.GA13488@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAAafysGxU9vaEs6actqX3ZFGkoXFvPFUAC1SjwtkZ97uuuFgJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAafysGxU9vaEs6actqX3ZFGkoXFvPFUAC1SjwtkZ97uuuFgJg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 27, 2017 at 08:20:49AM -0500, John Marrett wrote:
> In preparation for a system and storage upgrade I performed some btrfs
> performance tests. I created a ten disk raid1 using 7.2k 3 TB SAS
> drives and used aio to test IOOP rates. I was surprised to measure 215
> read and 72 write IOOPs on the clean new filesystem. Sequential writes
> ran as expected at roughly 650 MB/s. I created a zfs filesystem for
> comparison on another checksumming filesystem using the same layout
> and measured IOOP rates at 4315 read, 1449 write with sync enabled
> (without sync it's clearly just writing to RAM), sequential
> performance was comparable to btrfs.
> 
> While I started testing with a Ubuntu 16.04 kernel I also tested using
> 4.10.0 (ubuntu packaged, from
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/) and observed
> identical performance with both kernels.
> 
> Reviewing the mailing list I found a previous discussion [1] about
> disappointing tests with fio; I've attempted to use the ba=4k option
> discussed in that thread in an effort to improve performance however
> it doesn't appear to have an impact.
> 
> In case the issue is hardware related the specs on the server are 24GB
> of RAM, dual E5620 as well as 12 SAS bays driven by a Dell H700
> controller with 12 RAID0 drives with individual disks configured. This
> controller configuration is clearly suboptimal and I will replace this
> with a LSI JBOD controller (reflashed H300) once it arrives.
> 
> Is the performance I'm experiencing expected or is there an issue with
> either my configuration, tools or testing methodology?
>

For iops testing, libaio + direct=1 is preferred to bypass page cache.

Thanks,

-liubo

> Below you will find the commands used to create and test each
> filesystem as well as their output.
> 
> [1] http://linux-btrfs.vger.kernel.narkive.com/2lwzu0Is/why-does-btrfs-benchmark-so-badly-in-this-case
> 
> Thanks in advance for any help you can offer,
> 
> -JohnF
> 
> BTRFS Filesystem Creation and Testing
> 
> johnf@altered-carbon:~$ uname -a
> Linux altered-carbon 4.10.0-041000-generic #201702191831 SMP Sun Feb
> 19 23:33:19 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> johnf@altered-carbon:~$ sudo mkfs.btrfs -f /dev/sdg1 /dev/sdh1
> /dev/sdd1 /dev/sdi1 /dev/sdf1 /dev/sdl1 /dev/sde1 /dev/sdm1 /dev/sdj1
> /dev/sdk1
> [sudo] password for johnf:
> btrfs-progs v4.4
> See http://btrfs.wiki.kernel.org for more information.
> 
> Label:              (null)
> UUID:               ded602d6-1b78-4149-ae29-b58735d2f3f1
> Node size:          16384
> Sector size:        4096
> Filesystem size:    27.28TiB
> Block group profiles:
>   Data:             RAID0            10.01GiB
>   Metadata:         RAID1             1.01GiB
>   System:           RAID1            12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  10
> Devices:
>    ID        SIZE  PATH
>     1     2.73TiB  /dev/sdg1
>     2     2.73TiB  /dev/sdh1
>     3     2.73TiB  /dev/sdd1
>     4     2.73TiB  /dev/sdi1
>     5     2.73TiB  /dev/sdf1
>     6     2.73TiB  /dev/sdl1
>     7     2.73TiB  /dev/sde1
>     8     2.73TiB  /dev/sdm1
>     9     2.73TiB  /dev/sdj1
>    10     2.73TiB  /dev/sdk1
> 
> johnf@altered-carbon:~$ sudo mount /dev/sdg1 /btrfs/
> johnf@altered-carbon:~$ sudo btrfs balance start -dconvert=raid1
> -mconvert=raid1 /btrfs
> Done, had to relocate 3 out of 3 chunks
> johnf@altered-carbon:~$ cd /btrfs/
> johnf@altered-carbon:/btrfs$ sudo mkdir johnf; sudo chown johnf:johnf
> johnf; cd johnf
> johnf@altered-carbon:/btrfs/johnf$ fio --randrepeat=1
> --ioengine=libaio --gtod_reduce=1 --name=test --filename=test --bs=4k
> --iodepth=64 --size=1G --readwrite=randrw --rwmixread=75
> test: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=64
> fio-2.2.10
> Starting 1 process
> test: Laying out IO file(s) (1 file(s) / 1024MB)
> Jobs: 1 (f=1): [m(1)] [99.9% done] [4988KB/1664KB/0KB /s] [1247/416/0
> iops] [eta 00m:01s]
> test: (groupid=0, jobs=1): err= 0: pid=5521: Sun Feb 26 08:23:14 2017
>   read : io=784996KB, bw=883989B/s, iops=215, runt=909327msec
>   write: io=263580KB, bw=296819B/s, iops=72, runt=909327msec
>   cpu          : usr=0.33%, sys=1.60%, ctx=196681, majf=0, minf=22
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=196249/w=65895/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=64
> 
> Run status group 0 (all jobs):
>    READ: io=784996KB, aggrb=863KB/s, minb=863KB/s, maxb=863KB/s,
> mint=909327msec, maxt=909327msec
>   WRITE: io=263580KB, aggrb=289KB/s, minb=289KB/s, maxb=289KB/s,
> mint=909327msec, maxt=909327msec
> 
> 
> johnf@altered-carbon:/btrfs/johnf$ dd if=/dev/zero
> of=/btrfs/johnf/test bs=1M count=250000 conv=fsync
> 250000+0 records in
> 250000+0 records out
> 262144000000 bytes (262 GB, 244 GiB) copied, 404.289 s, 648 MB/s
> 
> johnf@altered-carbon:/btrfs/johnf$ sudo btrfs fi show
> [sudo] password for johnf:
> Label: none  uuid: 330a8131-9f68-4d2d-a141-e83ea829de79
>     Total devices 2 FS bytes used 7.04GiB
>     devid    1 size 2.73TiB used 8.03GiB path /dev/sdb3
>     devid    2 size 2.73TiB used 8.03GiB path /dev/sdc3
> 
> Label: none  uuid: ded602d6-1b78-4149-ae29-b58735d2f3f1
>     Total devices 10 FS bytes used 244.45GiB
>     devid    1 size 2.73TiB used 50.00GiB path /dev/sdg1
>     devid    2 size 2.73TiB used 49.00GiB path /dev/sdh1
>     devid    3 size 2.73TiB used 49.03GiB path /dev/sdd1
>     devid    4 size 2.73TiB used 49.00GiB path /dev/sdi1
>     devid    5 size 2.73TiB used 49.00GiB path /dev/sdf1
>     devid    6 size 2.73TiB used 49.00GiB path /dev/sdl1
>     devid    7 size 2.73TiB used 49.00GiB path /dev/sde1
>     devid    8 size 2.73TiB used 49.03GiB path /dev/sdm1
>     devid    9 size 2.73TiB used 49.00GiB path /dev/sdj1
>     devid   10 size 2.73TiB used 50.00GiB path /dev/sdk1
> 
> Label: none  uuid: 5a99aa45-40b6-4400-a0d8-74e9636fe209
>     Total devices 1 FS bytes used 1.39GiB
>     devid    1 size 2.73TiB used 4.02GiB path /dev/sdb1
> 
> 
> ZFS Filesystem Creation and Testing
> 
> johnf@altered-carbon:~$ sudo zpool create -f zfs mirror /dev/sdg1
> /dev/sdh1 mirror /dev/sdd1  /dev/sdi1 mirror /dev/sdf1 /dev/sdl1
> mirror /dev/sde1 /dev/sdm1 mirror /dev/sdj1 /dev/sdk1
> johnf@altered-carbon:~$ cd /zfs/
> johnf@altered-carbon:/zfs$ sudo mkdir johnf; sudo chown johnf:johnf
> johnf; cd johnf
> johnf@altered-carbon:/zfs/johnf$ fio --randrepeat=1 --ioengine=libaio
> --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64
> --size=1G --readwrite=randrw --rwmixread=75 --sync=1
> test: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=64
> fio-2.2.10
> Starting 1 process
> Jobs: 1 (f=1): [m(1)] [100.0% done] [19492KB/6396KB/0KB /s]
> [4873/1599/0 iops] [eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=7431: Sat Feb 25 17:12:34 2017
>   read : io=784996KB, bw=17263KB/s, iops=4315, runt= 45474msec
>   write: io=263580KB, bw=5796.3KB/s, iops=1449, runt= 45474msec
>   cpu          : usr=2.24%, sys=16.44%, ctx=131967, majf=0, minf=561
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=196249/w=65895/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=64
> 
> Run status group 0 (all jobs):
>    READ: io=784996KB, aggrb=17262KB/s, minb=17262KB/s, maxb=17262KB/s,
> mint=45474msec, maxt=45474msec
>   WRITE: io=263580KB, aggrb=5796KB/s, minb=5796KB/s, maxb=5796KB/s,
> mint=45474msec, maxt=45474msec
> johnf@altered-carbon:/zfs/johnf$ dd if=/dev/zero of=test bs=1M
> count=250000 conv=fsync
> 250000+0 records in
> 250000+0 records out
> 262144000000 bytes (262 GB, 244 GiB) copied, 401.401 s, 653 MB/s
> johnf@altered-carbon:/zfs/johnf$ sudo zpool status
>   pool: zfs
>  state: ONLINE
>   scan: none requested
> config:
> 
>     NAME        STATE     READ WRITE CKSUM
>     zfs         ONLINE       0     0     0
>       mirror-0  ONLINE       0     0     0
>         sdg1    ONLINE       0     0     0
>         sdh1    ONLINE       0     0     0
>       mirror-1  ONLINE       0     0     0
>         sdd1    ONLINE       0     0     0
>         sdi1    ONLINE       0     0     0
>       mirror-2  ONLINE       0     0     0
>         sdf1    ONLINE       0     0     0
>         sdl1    ONLINE       0     0     0
>       mirror-3  ONLINE       0     0     0
>         sde1    ONLINE       0     0     0
>         sdm1    ONLINE       0     0     0
>       mirror-4  ONLINE       0     0     0
>         sdj1    ONLINE       0     0     0
>         sdk1    ONLINE       0     0     0
> 
> errors: No known data errors
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
