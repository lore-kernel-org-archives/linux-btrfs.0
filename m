Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59158 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2HBRjC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 13:39:02 -0400
Date: Thu, 2 Aug 2012 10:39:00 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120802173900.GB15989@merlins.org>
References: <20120722185848.GA10089@merlins.org> <201208012357.39786.Martin@lichtvoll.de> <20120802050741.GA22772@merlins.org> <201208021325.17433.Martin@lichtvoll.de> <20120722185848.GA10089@merlins.org> <201208012357.39786.Martin@lichtvoll.de> <20120802050741.GA22772@merlins.org> <201208021318.07747.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201208021325.17433.Martin@lichtvoll.de> <201208021318.07747.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 01:18:07PM +0200, Martin Steigerwald wrote:
> > I've the the fio tests in:
> > /dev/mapper/cryptroot /var btrfs rw,noatime,compress=lzo,nossd,discard,space_cache 0 0
> 
> … you are still using dm_crypt?
 
That was my biggest partition and so far I've found no performance impact
on file access between unencrypted and dm_crypt.
I just took out my swap partition and made a smaller btrfs there:
/dev/sda3 /mnt/mnt3 btrfs rw,noatime,ssd,space_cache 0 0

I mounted without discard.

> >     lat (usec) : 50=0.01%
> >     lat (msec) : 10=0.02%, 20=0.02%, 50=0.05%, 100=0.14%, 250=12.89%
> >     lat (msec) : 500=72.44%, 750=14.43%
> 
> Gosh, look at these latencies!
> 
> 72,44% of all requests above 500 (in words: five hundred) milliseconds!
> And 14,43% above 750 msecs. The percentage of requests served at 100 msecs
> or less is was below one percent! Hey, is this an SSD or what?
 
Yeah, that's kind of what I've been complaining about since the beginning :)
Once I'm reading sequentially, it goes fast, but random access/latency is
indeed abysmal.

> Still even with iodepth 64 totally different picture. And look at the IOPS
> and throughput.
 
Yep. I know mine are bad :(

> For reference, this refers to
> 
> [global]
> ioengine=libaio
> direct=1
> iodepth=64

Since it's slightly different than the first job file you gave me, I re-ran
with this one this time.

gandalfthegreat:~# /sbin/mkfs.btrfs -L test /dev/sda2
gandalfthegreat:~# mount -o noatime /dev/sda2 /mnt/mnt2
gandalfthegreat:~# grep sda2 /proc/mounts
/dev/sda2 /mnt/mnt2 btrfs rw,noatime,ssd,space_cache 0 0

here's the btrfs test (ext4 is lower down):
gandalfthegreat:/mnt/mnt2# fio ~/fio.job2
zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
zufälligschreiben: (g=2): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentiellschreiben: (g=3): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
2.0.8
Starting 4 processes
zufälliglesen: Laying out IO file(s) (1 file(s) / 2048MB)
sequentielllesen: Laying out IO file(s) (1 file(s) / 2048MB)
zufälligschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
sequentiellschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
Jobs: 1 (f=1): [___W] [59.5% done] [0K/1800K /s] [0 /193  iops] [eta 02m:10s]     
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=30318
  read : io=73682KB, bw=1227.1KB/s, iops=137 , runt= 60004msec
    slat (usec): min=3 , max=37432 , avg=7252.52, stdev=5717.70
    clat (usec): min=13 , max=981927 , avg=454046.13, stdev=110527.92
     lat (msec): min=5 , max=999 , avg=461.30, stdev=112.00
    clat percentiles (msec):
     |  1.00th=[  145],  5.00th=[  269], 10.00th=[  371], 20.00th=[  408],
     | 30.00th=[  424], 40.00th=[  437], 50.00th=[  449], 60.00th=[  457],
     | 70.00th=[  474], 80.00th=[  490], 90.00th=[  570], 95.00th=[  644],
     | 99.00th=[  865], 99.50th=[  922], 99.90th=[  963], 99.95th=[  979],
     | 99.99th=[  979]
    bw (KB/s)  : min=    8, max= 2807, per=100.00%, avg=1227.75, stdev=317.57
    lat (usec) : 20=0.01%
    lat (msec) : 10=0.01%, 20=0.02%, 50=0.04%, 100=0.46%, 250=3.82%
    lat (msec) : 500=79.48%, 750=13.57%, 1000=2.58%
  cpu          : usr=0.12%, sys=1.13%, ctx=12186, majf=0, minf=276
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.4%, >=64=99.2%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=8262/w=0/d=0, short=r=0/w=0/d=0
sequentielllesen: (groupid=1, jobs=1): err= 0: pid=30340
  read : io=2048.0MB, bw=211257KB/s, iops=23473 , runt=  9927msec
    slat (usec): min=1 , max=56321 , avg=20.51, stdev=424.44
    clat (usec): min=0 , max=57987 , avg=2695.98, stdev=6624.00
     lat (usec): min=1 , max=58015 , avg=2716.75, stdev=6642.09
    clat percentiles (usec):
     |  1.00th=[    1],  5.00th=[   10], 10.00th=[   30], 20.00th=[  100],
     | 30.00th=[  217], 40.00th=[  362], 50.00th=[  494], 60.00th=[  636],
     | 70.00th=[  892], 80.00th=[ 1656], 90.00th=[ 7392], 95.00th=[21632],
     | 99.00th=[29056], 99.50th=[29568], 99.90th=[43776], 99.95th=[46848],
     | 99.99th=[57600]
    bw (KB/s)  : min=166675, max=260984, per=99.83%, avg=210892.26, stdev=22433.65
    lat (usec) : 2=2.16%, 4=0.43%, 10=2.33%, 20=2.80%, 50=5.72%
    lat (usec) : 100=6.47%, 250=12.35%, 500=18.29%, 750=15.52%, 1000=5.44%
    lat (msec) : 2=13.04%, 4=3.59%, 10=3.83%, 20=1.88%, 50=6.11%
    lat (msec) : 100=0.04%
  cpu          : usr=4.51%, sys=35.70%, ctx=11480, majf=0, minf=278
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=233025/w=0/d=0, short=r=0/w=0/d=0
zufälligschreiben: (groupid=2, jobs=1): err= 0: pid=30348
  write: io=110768KB, bw=1845.1KB/s, iops=208 , runt= 60007msec
    slat (usec): min=26 , max=50160 , avg=4789.12, stdev=4968.75
    clat (usec): min=29 , max=752494 , avg=301858.86, stdev=80422.24
     lat (msec): min=12 , max=757 , avg=306.65, stdev=81.52
    clat percentiles (msec):
     |  1.00th=[  208],  5.00th=[  241], 10.00th=[  245], 20.00th=[  255],
     | 30.00th=[  262], 40.00th=[  269], 50.00th=[  277], 60.00th=[  289],
     | 70.00th=[  306], 80.00th=[  326], 90.00th=[  363], 95.00th=[  519],
     | 99.00th=[  627], 99.50th=[  652], 99.90th=[  734], 99.95th=[  742],
     | 99.99th=[  750]
    bw (KB/s)  : min=  616, max= 2688, per=99.72%, avg=1839.80, stdev=399.60
    lat (usec) : 50=0.01%
    lat (msec) : 20=0.02%, 50=0.04%, 100=0.07%, 250=14.31%, 500=79.62%
    lat (msec) : 750=5.91%, 1000=0.01%
  cpu          : usr=0.28%, sys=2.60%, ctx=10167, majf=0, minf=20
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.3%, >=64=99.5%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=0/w=12495/d=0, short=r=0/w=0/d=0
sequentiellschreiben: (groupid=3, jobs=1): err= 0: pid=30364
  write: io=84902KB, bw=1414.1KB/s, iops=156 , runt= 60005msec
    slat (usec): min=18 , max=40825 , avg=6389.99, stdev=6072.56
    clat (usec): min=22 , max=887097 , avg=401897.77, stdev=108015.23
     lat (msec): min=11 , max=899 , avg=408.29, stdev=109.47
    clat percentiles (msec):
     |  1.00th=[  262],  5.00th=[  302], 10.00th=[  318], 20.00th=[  338],
     | 30.00th=[  351], 40.00th=[  363], 50.00th=[  375], 60.00th=[  388],
     | 70.00th=[  404], 80.00th=[  433], 90.00th=[  502], 95.00th=[  693],
     | 99.00th=[  783], 99.50th=[  824], 99.90th=[  873], 99.95th=[  881],
     | 99.99th=[  889]
    bw (KB/s)  : min=  346, max= 2115, per=99.44%, avg=1406.11, stdev=333.58
    lat (usec) : 50=0.01%
    lat (msec) : 20=0.02%, 50=0.03%, 100=0.07%, 250=0.59%, 500=89.12%
    lat (msec) : 750=7.91%, 1000=2.24%
  cpu          : usr=0.28%, sys=2.21%, ctx=13224, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.3%, >=64=99.3%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=0/w=9369/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=73682KB, aggrb=1227KB/s, minb=1227KB/s, maxb=1227KB/s, mint=60004msec, maxt=60004msec

Run status group 1 (all jobs):
   READ: io=2048.0MB, aggrb=211257KB/s, minb=211257KB/s, maxb=211257KB/s, mint=9927msec, maxt=9927msec

Run status group 2 (all jobs):
  WRITE: io=110768KB, aggrb=1845KB/s, minb=1845KB/s, maxb=1845KB/s, mint=60007msec, maxt=60007msec

Run status group 3 (all jobs):
  WRITE: io=84902KB, aggrb=1414KB/s, minb=1414KB/s, maxb=1414KB/s, mint=60005msec, maxt=60005msec
gandalfthegreat:/mnt/mnt2#
(no lines beyond this, fio 2.0.8)

> This could be another good test. Text with Ext4 on plain logical volume
> without dm_crypt.
> Can you also post the last lines:
> 
> Disk stats (read/write):
>   dm-2: ios=616191/613142, merge=0/0, ticks=1300820/2565384, in_queue=3867448, util=98.81%, aggrios=504829/504643, aggrmerge=111362/111451, aggrticks=1058320/2164664, aggrin_queue=3223048, aggrutil=98.78%
>     sda: ios=504829/504643, merge=111362/111451, ticks=1058320/2164664, in_queue=3223048, util=98.78%
> martin@merkaba:~/Artikel/LinuxNewMedia/fio/Recherche/Messungen/merkaba>
 
I didn't get these lines.
 
> Its gives information on who good the I/O scheduler was able to merge requests.
> 
> I didn´t see much of a difference between CFQ and noop, so it may not
> matter much, but since it gives also a number on total disk utilization
> its still quite nice to have.

I tried deadline and noop, and indeed I'm not see much of a difference for my basic tests.
Fro now I have deadline.
 
> So my recommendation of now:
> 
> Remove as much factors as possible and in order to compare results with
> what I posted try with plain logical volume with Ext4.

gandalfthegreat:~# mkfs.ext4 -O extent -b 4096 -E stride=128,stripe-width=128 /dev/sda2
/dev/sda2 /mnt/mnt2 ext4 rw,noatime,stripe=128,data=ordered 0 0

gandalfthegreat:/mnt/mnt2# fio ~/fio.job2
zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
zufälligschreiben: (g=2): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentiellschreiben: (g=3): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
2.0.8
Starting 4 processes
zufälliglesen: Laying out IO file(s) (1 file(s) / 2048MB)
sequentielllesen: Laying out IO file(s) (1 file(s) / 2048MB)
zufälligschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
sequentiellschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
Jobs: 1 (f=1): [___W] [63.8% done] [0K/2526K /s] [0 /280  iops] [eta 01m:21s]  
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=30077
  read : io=2048.0MB, bw=276232KB/s, iops=50472 , runt=  7592msec
    slat (usec): min=2 , max=2276 , avg= 6.87, stdev=12.01
    clat (usec): min=249 , max=52128 , avg=1258.87, stdev=1714.63
     lat (usec): min=260 , max=52134 , avg=1266.00, stdev=1715.36
    clat percentiles (usec):
     |  1.00th=[  450],  5.00th=[  548], 10.00th=[  620], 20.00th=[  724],
     | 30.00th=[  820], 40.00th=[  908], 50.00th=[ 1004], 60.00th=[ 1096],
     | 70.00th=[ 1208], 80.00th=[ 1368], 90.00th=[ 1640], 95.00th=[ 2040],
     | 99.00th=[ 8256], 99.50th=[14912], 99.90th=[21120], 99.95th=[23168],
     | 99.99th=[33024]
    bw (KB/s)  : min=76463, max=385328, per=100.00%, avg=277313.20, stdev=94661.29
    lat (usec) : 250=0.01%, 500=2.46%, 750=19.82%, 1000=27.70%
    lat (msec) : 2=44.79%, 4=3.55%, 10=0.72%, 20=0.78%, 50=0.17%
    lat (msec) : 100=0.01%
  cpu          : usr=11.91%, sys=51.64%, ctx=91337, majf=0, minf=277
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=383190/w=0/d=0, short=r=0/w=0/d=0
sequentielllesen: (groupid=1, jobs=1): err= 0: pid=30081
  read : io=2048.0MB, bw=150043KB/s, iops=16641 , runt= 13977msec
    slat (usec): min=1 , max=2134 , avg= 7.09, stdev=10.83
    clat (usec): min=298 , max=16751 , avg=3836.41, stdev=755.26
     lat (usec): min=304 , max=16771 , avg=3843.77, stdev=754.77
    clat percentiles (usec):
     |  1.00th=[ 2608],  5.00th=[ 2960], 10.00th=[ 3152], 20.00th=[ 3376],
     | 30.00th=[ 3536], 40.00th=[ 3664], 50.00th=[ 3792], 60.00th=[ 3920],
     | 70.00th=[ 4080], 80.00th=[ 4256], 90.00th=[ 4448], 95.00th=[ 4704],
     | 99.00th=[ 5216], 99.50th=[ 5984], 99.90th=[13888], 99.95th=[15296],
     | 99.99th=[16512]
    bw (KB/s)  : min=134280, max=169692, per=100.00%, avg=150111.30, stdev=7227.35
    lat (usec) : 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.07%, 4=64.79%, 10=34.87%, 20=0.25%
  cpu          : usr=6.81%, sys=20.01%, ctx=77116, majf=0, minf=279
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=232601/w=0/d=0, short=r=0/w=0/d=0
zufälligschreiben: (groupid=2, jobs=1): err= 0: pid=30088
  write: io=111828KB, bw=1863.7KB/s, iops=209 , runt= 60006msec
    slat (usec): min=7 , max=51044 , avg=4757.60, stdev=4816.78
    clat (usec): min=958 , max=582205 , avg=299854.73, stdev=56663.66
     lat (msec): min=12 , max=588 , avg=304.61, stdev=57.22
    clat percentiles (msec):
     |  1.00th=[   73],  5.00th=[  225], 10.00th=[  251], 20.00th=[  273],
     | 30.00th=[  285], 40.00th=[  297], 50.00th=[  306], 60.00th=[  314],
     | 70.00th=[  318], 80.00th=[  330], 90.00th=[  343], 95.00th=[  359],
     | 99.00th=[  482], 99.50th=[  519], 99.90th=[  553], 99.95th=[  570],
     | 99.99th=[  570]
    bw (KB/s)  : min= 1033, max= 3430, per=99.67%, avg=1856.90, stdev=307.24
    lat (usec) : 1000=0.01%
    lat (msec) : 20=0.06%, 50=0.72%, 100=0.44%, 250=8.50%, 500=89.52%
    lat (msec) : 750=0.75%
  cpu          : usr=0.27%, sys=1.27%, ctx=9505, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.3%, >=64=99.5%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=0/w=12580/d=0, short=r=0/w=0/d=0
sequentiellschreiben: (groupid=3, jobs=1): err= 0: pid=30102
  write: io=137316KB, bw=2288.2KB/s, iops=254 , runt= 60013msec
    slat (usec): min=5 , max=40817 , avg=3911.57, stdev=4785.23
    clat (msec): min=4 , max=682 , avg=246.61, stdev=77.35
     lat (msec): min=5 , max=688 , avg=250.53, stdev=78.39
    clat percentiles (msec):
     |  1.00th=[   73],  5.00th=[  143], 10.00th=[  186], 20.00th=[  206],
     | 30.00th=[  221], 40.00th=[  229], 50.00th=[  239], 60.00th=[  245],
     | 70.00th=[  258], 80.00th=[  273], 90.00th=[  318], 95.00th=[  416],
     | 99.00th=[  529], 99.50th=[  562], 99.90th=[  660], 99.95th=[  668],
     | 99.99th=[  676]
    bw (KB/s)  : min=  811, max= 4243, per=99.65%, avg=2279.92, stdev=610.32
    lat (msec) : 10=0.26%, 20=0.03%, 50=0.22%, 100=1.97%, 250=62.01%
    lat (msec) : 500=33.43%, 750=2.07%
  cpu          : usr=0.35%, sys=1.46%, ctx=10993, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.2%, >=64=99.6%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=0/w=15293/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=2048.0MB, aggrb=276231KB/s, minb=276231KB/s, maxb=276231KB/s, mint=7592msec, maxt=7592msec

Run status group 1 (all jobs):
   READ: io=2048.0MB, aggrb=150043KB/s, minb=150043KB/s, maxb=150043KB/s, mint=13977msec, maxt=13977msec

Run status group 2 (all jobs):
  WRITE: io=111828KB, aggrb=1863KB/s, minb=1863KB/s, maxb=1863KB/s, mint=60006msec, maxt=60006msec

Run status group 3 (all jobs):
  WRITE: io=137316KB, aggrb=2288KB/s, minb=2288KB/s, maxb=2288KB/s, mint=60013msec, maxt=60013msec

Disk stats (read/write):
  sda: ios=505649/30833, merge=110818/7835, ticks=917980/187892, in_queue=1106088, util=98.50%
gandalfthegreat:/mnt/mnt2# 
 
> If the values are still quite slow, I think its good to ask Linux
> block layer experts – for example by posting on fio mailing list where
> there are people subscribed that may be able to provide other test
> results – and SSD experts. There might be a Linux block layer mailing
> list or use libata or fsdevel, I don´t know.
 
I'll try there next. I think after this mail, and your help which is very
much appreciated, it's fair to take things out of this list to stop spamming
the wrong people :)

> Have the IOPS run on the device it self. That will remove any filesystem
> layer. But only the read only tests, to make sure I suggest to use fio
> with the --readonly option as safety guard. Unless you have a spare SSD
> that you can afford to use for write testing which will likely destroy
> every filesystem on it. Or let it run on just one logical volume.
 
Can you send me a recommended job config you'd like me to run if the runs
above haven't already answered your questions?

> What does your SSD report discard alignment – well but even that should
> not matter for reads:
> 
> merkaba:/sys/block/sda> cat discard_alignment 
> 0

gandalfthegreat:/sys/block/sda# cat discard_alignment 
0
 
> Seems Intel tells us to not care at all. Or the value for some reason
> cannot be read.
> 
> merkaba:/sys/block/sda> cd queue
> merkaba:/sys/block/sda/queue> grep . *
> add_random:1
> discard_granularity:512
> discard_max_bytes:2147450880
> discard_zeroes_data:1
> hw_sector_size:512
> 
> I would be interested whether these above differ.
 
I have the exact same.

> And whether there is any optimal io size.

I also have
optimal_io_size:0

> One note regarding this: Back then I made the Ext4 I carried above tests
> in the last year to be aligned to what I think could be good for the SSD.
> I do not know whether this matters much.
> 
> merkaba:~> tune2fs -l /dev/merkaba/home 
> RAID stripe width:        128

> I think this is a plan to find out whether its either really the hardware
> or some wierd happening in the low level parts of Linux, e.g. the block
> layer or dm_crypt or filing system.
> 
> Reduce it to the most basic level and then work from there.

So, I went back to basics.

On Thu, Aug 02, 2012 at 01:25:17PM +0200, Martin Steigerwald wrote:
> Heck, I didn´t look at the IOPS figure!
> 
> 189 IOPS for a SATA-600 SSD. Thats pathetic.
 
Yeah, and the new tests above without dmcrypt are no better.

> A really fast 15000 rpm SAS harddisk might top that.

My slow 1TB 5400rpm laptop hard drive runs du -s 4x faster than 
the SSD right now :)

I read your comments about the multiple things you had in mind. Given the
new data, should I just go to an io list now, or even save myself some time
and just return the damned SSDs and buy from another vendor? :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
