Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44560 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2HBUUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 16:20:10 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Marc MERLIN <marc@merlins.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Thu, 2 Aug 2012 22:20:07 +0200
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
References: <20120722185848.GA10089@merlins.org> <201208021318.07747.Martin@lichtvoll.de> <20120802173900.GB15989@merlins.org> (sfid-20120802_195158_253556_00C3282D)
In-Reply-To: <20120802173900.GB15989@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201208022220.08217.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 2. August 2012 schrieb Marc MERLIN:
> On Thu, Aug 02, 2012 at 01:18:07PM +0200, Martin Steigerwald wrote:
> > > I've the the fio tests in:
> > > /dev/mapper/cryptroot /var btrfs rw,noatime,compress=lzo,nossd,discard,space_cache 0 0
> > 
> > … you are still using dm_crypt?
[…]
> I just took out my swap partition and made a smaller btrfs there:
> /dev/sda3 /mnt/mnt3 btrfs rw,noatime,ssd,space_cache 0 0
> 
> I mounted without discard.
[…]
> > For reference, this refers to
> > 
> > [global]
> > ioengine=libaio
> > direct=1
> > iodepth=64
> 
> Since it's slightly different than the first job file you gave me, I re-ran
> with this one this time.
> 
> gandalfthegreat:~# /sbin/mkfs.btrfs -L test /dev/sda2
> gandalfthegreat:~# mount -o noatime /dev/sda2 /mnt/mnt2
> gandalfthegreat:~# grep sda2 /proc/mounts
> /dev/sda2 /mnt/mnt2 btrfs rw,noatime,ssd,space_cache 0 0
> 
> here's the btrfs test (ext4 is lower down):
> gandalfthegreat:/mnt/mnt2# fio ~/fio.job2
> zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> zufälligschreiben: (g=2): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentiellschreiben: (g=3): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> 2.0.8

Still abysmal except for sequential reads.

> Starting 4 processes
> zufälliglesen: Laying out IO file(s) (1 file(s) / 2048MB)
> sequentielllesen: Laying out IO file(s) (1 file(s) / 2048MB)
> zufälligschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
> sequentiellschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
> Jobs: 1 (f=1): [___W] [59.5% done] [0K/1800K /s] [0 /193  iops] [eta 02m:10s]     
> zufälliglesen: (groupid=0, jobs=1): err= 0: pid=30318
>   read : io=73682KB, bw=1227.1KB/s, iops=137 , runt= 60004msec
[…]
>     lat (usec) : 20=0.01%
>     lat (msec) : 10=0.01%, 20=0.02%, 50=0.04%, 100=0.46%, 250=3.82%
>     lat (msec) : 500=79.48%, 750=13.57%, 1000=2.58%

1 second latency? Oh well…


> Run status group 3 (all jobs):
>   WRITE: io=84902KB, aggrb=1414KB/s, minb=1414KB/s, maxb=1414KB/s, mint=60005msec, maxt=60005msec
> gandalfthegreat:/mnt/mnt2#
> (no lines beyond this, fio 2.0.8)
[…]
> > Can you also post the last lines:
> > 
> > Disk stats (read/write):
> >   dm-2: ios=616191/613142, merge=0/0, ticks=1300820/2565384, in_queue=3867448, util=98.81%, aggrios=504829/504643, aggrmerge=111362/111451, aggrticks=1058320/2164664, aggrin_queue=3223048, aggrutil=98.78%
> >     sda: ios=504829/504643, merge=111362/111451, ticks=1058320/2164664, in_queue=3223048, util=98.78%
> > martin@merkaba:~/Artikel/LinuxNewMedia/fio/Recherche/Messungen/merkaba>
>  
> I didn't get these lines.

Hmmm, back then I guess this was fio 1.5.9 or so.

> I tried deadline and noop, and indeed I'm not see much of a difference for my basic tests.
> Fro now I have deadline.
>  
> > So my recommendation of now:
> > 
> > Remove as much factors as possible and in order to compare results with
> > what I posted try with plain logical volume with Ext4.
> 
> gandalfthegreat:~# mkfs.ext4 -O extent -b 4096 -E stride=128,stripe-width=128 /dev/sda2
> /dev/sda2 /mnt/mnt2 ext4 rw,noatime,stripe=128,data=ordered 0 0
> 
> gandalfthegreat:/mnt/mnt2# fio ~/fio.job2
> zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> zufälligschreiben: (g=2): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentiellschreiben: (g=3): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> 2.0.8
> Starting 4 processes
> zufälliglesen: Laying out IO file(s) (1 file(s) / 2048MB)
> sequentielllesen: Laying out IO file(s) (1 file(s) / 2048MB)
> zufälligschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
> sequentiellschreiben: Laying out IO file(s) (1 file(s) / 2048MB)
> Jobs: 1 (f=1): [___W] [63.8% done] [0K/2526K /s] [0 /280  iops] [eta 01m:21s]  
> zufälliglesen: (groupid=0, jobs=1): err= 0: pid=30077
>   read : io=2048.0MB, bw=276232KB/s, iops=50472 , runt=  7592msec
>     slat (usec): min=2 , max=2276 , avg= 6.87, stdev=12.01
>     clat (usec): min=249 , max=52128 , avg=1258.87, stdev=1714.63
>      lat (usec): min=260 , max=52134 , avg=1266.00, stdev=1715.36
>     clat percentiles (usec):
>      |  1.00th=[  450],  5.00th=[  548], 10.00th=[  620], 20.00th=[  724],
>      | 30.00th=[  820], 40.00th=[  908], 50.00th=[ 1004], 60.00th=[ 1096],
>      | 70.00th=[ 1208], 80.00th=[ 1368], 90.00th=[ 1640], 95.00th=[ 2040],
>      | 99.00th=[ 8256], 99.50th=[14912], 99.90th=[21120], 99.95th=[23168],
>      | 99.99th=[33024]
>     bw (KB/s)  : min=76463, max=385328, per=100.00%, avg=277313.20, stdev=94661.29
>     lat (usec) : 250=0.01%, 500=2.46%, 750=19.82%, 1000=27.70%
>     lat (msec) : 2=44.79%, 4=3.55%, 10=0.72%, 20=0.78%, 50=0.17%
>     lat (msec) : 100=0.01%
>   cpu          : usr=11.91%, sys=51.64%, ctx=91337, majf=0, minf=277
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=383190/w=0/d=0, short=r=0/w=0/d=0

Hey, whats this? With Ext4 you have really good random read performance
now! Way better than the Intel SSD 320 and…

> sequentielllesen: (groupid=1, jobs=1): err= 0: pid=30081
>   read : io=2048.0MB, bw=150043KB/s, iops=16641 , runt= 13977msec
>     slat (usec): min=1 , max=2134 , avg= 7.09, stdev=10.83
>     clat (usec): min=298 , max=16751 , avg=3836.41, stdev=755.26
>      lat (usec): min=304 , max=16771 , avg=3843.77, stdev=754.77
>     clat percentiles (usec):
>      |  1.00th=[ 2608],  5.00th=[ 2960], 10.00th=[ 3152], 20.00th=[ 3376],
>      | 30.00th=[ 3536], 40.00th=[ 3664], 50.00th=[ 3792], 60.00th=[ 3920],
>      | 70.00th=[ 4080], 80.00th=[ 4256], 90.00th=[ 4448], 95.00th=[ 4704],
>      | 99.00th=[ 5216], 99.50th=[ 5984], 99.90th=[13888], 99.95th=[15296],
>      | 99.99th=[16512]
>     bw (KB/s)  : min=134280, max=169692, per=100.00%, avg=150111.30, stdev=7227.35
>     lat (usec) : 500=0.01%, 750=0.01%, 1000=0.01%
>     lat (msec) : 2=0.07%, 4=64.79%, 10=34.87%, 20=0.25%
>   cpu          : usr=6.81%, sys=20.01%, ctx=77116, majf=0, minf=279
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=232601/w=0/d=0, short=r=0/w=0/d=0

… even faster than sequential reads. That just doesn´t make any sense
to me.

The performance of your Samsung SSD seems to be quite erratic. It seems
that the device is capable of being fast, but only sometimes shows this
capability.

> zufälligschreiben: (groupid=2, jobs=1): err= 0: pid=30088
>   write: io=111828KB, bw=1863.7KB/s, iops=209 , runt= 60006msec
[…]
> sequentiellschreiben: (groupid=3, jobs=1): err= 0: pid=30102
>   write: io=137316KB, bw=2288.2KB/s, iops=254 , runt= 60013msec
[…]
> Run status group 0 (all jobs):
>    READ: io=2048.0MB, aggrb=276231KB/s, minb=276231KB/s, maxb=276231KB/s, mint=7592msec, maxt=7592msec
> 
> Run status group 1 (all jobs):
>    READ: io=2048.0MB, aggrb=150043KB/s, minb=150043KB/s, maxb=150043KB/s, mint=13977msec, maxt=13977msec
> 
> Run status group 2 (all jobs):
>   WRITE: io=111828KB, aggrb=1863KB/s, minb=1863KB/s, maxb=1863KB/s, mint=60006msec, maxt=60006msec
> 
> Run status group 3 (all jobs):
>   WRITE: io=137316KB, aggrb=2288KB/s, minb=2288KB/s, maxb=2288KB/s, mint=60013msec, maxt=60013msec

Writes are slow again.

> Disk stats (read/write):
>   sda: ios=505649/30833, merge=110818/7835, ticks=917980/187892, in_queue=1106088, util=98.50%

Well there we have that line. You don´t seem to have the other line
possibly due to not using LVM.

> gandalfthegreat:/mnt/mnt2# 
>  
> > If the values are still quite slow, I think its good to ask Linux
> > block layer experts – for example by posting on fio mailing list where
> > there are people subscribed that may be able to provide other test
> > results – and SSD experts. There might be a Linux block layer mailing
> > list or use libata or fsdevel, I don´t know.
>  
> I'll try there next. I think after this mail, and your help which is very
> much appreciated, it's fair to take things out of this list to stop spamming
> the wrong people :)

Well the only thing interesting regarding BTRFS is the whopping
difference in random read performance between BTRFS and Ext4 on this
SSD.

> > Have the IOPS run on the device it self. That will remove any filesystem
> > layer. But only the read only tests, to make sure I suggest to use fio
> > with the --readonly option as safety guard. Unless you have a spare SSD
> > that you can afford to use for write testing which will likely destroy
> > every filesystem on it. Or let it run on just one logical volume.
>  
> Can you send me a recommended job config you'd like me to run if the runs
> above haven't already answered your questions?

[global]
ioengine=libaio
direct=1
filename=/dev/sdb
size=476940m
bsrange=2k-16k

[zufälliglesen]
rw=randread
runtime=60

[sequentielllesen]
stonewall
rw=read
runtime=60

I won´t expect much of a difference, but then the random read performance
is quite different between Ext4 and BTRFS on this disk. That would make
it interesting to test without any filesystem in between and over the
whole device.

It might make sense to test around with different alignment, I think the
option is called bsalign or so…

> On Thu, Aug 02, 2012 at 01:25:17PM +0200, Martin Steigerwald wrote:
> > Heck, I didn´t look at the IOPS figure!
> > 
> > 189 IOPS for a SATA-600 SSD. Thats pathetic.
>  
> Yeah, and the new tests above without dmcrypt are no better.
> 
> > A really fast 15000 rpm SAS harddisk might top that.
> 
> My slow 1TB 5400rpm laptop hard drive runs du -s 4x faster than 
> the SSD right now :)
> 
> I read your comments about the multiple things you had in mind. Given the
> new data, should I just go to an io list now, or even save myself some time
> and just return the damned SSDs and buy from another vendor? :)

… or get yourself another SSD. Its your decision.

I admire your endurance. ;)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
