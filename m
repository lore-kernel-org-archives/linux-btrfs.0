Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60444 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2HBUoQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 16:44:16 -0400
Date: Thu, 2 Aug 2012 13:44:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120802204414.GA1834@merlins.org>
References: <20120722185848.GA10089@merlins.org>
 <201208021318.07747.Martin@lichtvoll.de>
 <20120802173900.GB15989@merlins.org>
 <201208022220.08217.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201208022220.08217.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 10:20:07PM +0200, Martin Steigerwald wrote:
> Hey, whats this? With Ext4 you have really good random read performance
> now! Way better than the Intel SSD 320 and…

Yep, my du -sh tests do show that ext4 is 2x faster than btrfs.
Obviously it's sending IO in a way that either the IO subsystem, linux
driver, or drive prefer.

> The performance of your Samsung SSD seems to be quite erratic. It seems
> that the device is capable of being fast, but only sometimes shows this
> capability.
 
That's indeed exactly what I'm seeing in real life :)

> > > Have the IOPS run on the device it self. That will remove any filesystem
> > > layer. But only the read only tests, to make sure I suggest to use fio
> > > with the --readonly option as safety guard. Unless you have a spare SSD
> > > that you can afford to use for write testing which will likely destroy
> > > every filesystem on it. Or let it run on just one logical volume.
> >  
> > Can you send me a recommended job config you'd like me to run if the runs
> > above haven't already answered your questions?
 
> [global]
(...)

I used this and just changed filename to /dev/sda. Since I'm reading
from the beginning of the drive, reads have to be aligned.

> I won´t expect much of a difference, but then the random read performance
> is quite different between Ext4 and BTRFS on this disk. That would make
> it interesting to test without any filesystem in between and over the
> whole device.

Here is the output:
gandalfthegreat:~# fio --readonly ./fio.job3
zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=1
sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=1
2.0.8
Starting 2 processes
Jobs: 1 (f=1): [_R] [66.9% done] [966K/0K /s] [108 /0  iops] [eta 01m:00s] 
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=2172
  read : io=59036KB, bw=983.93KB/s, iops=108 , runt= 60002msec
    slat (usec): min=5 , max=158 , avg=27.62, stdev=10.64
    clat (usec): min=45 , max=27348 , avg=9150.78, stdev=4452.66
     lat (usec): min=53 , max=27370 , avg=9179.05, stdev=4454.88
    clat percentiles (usec):
     |  1.00th=[  126],  5.00th=[  235], 10.00th=[ 5216], 20.00th=[ 5920],
     | 30.00th=[ 5920], 40.00th=[ 5984], 50.00th=[ 7712], 60.00th=[12480],
     | 70.00th=[12608], 80.00th=[12736], 90.00th=[12864], 95.00th=[16768],
     | 99.00th=[18560], 99.50th=[18816], 99.90th=[20352], 99.95th=[22656],
     | 99.99th=[27264]
    bw (KB/s)  : min=  423, max= 5776, per=100.00%, avg=986.48, stdev=480.68
    lat (usec) : 50=0.11%, 100=0.64%, 250=4.47%, 500=1.65%, 750=0.02%
    lat (usec) : 1000=0.02%
    lat (msec) : 2=0.06%, 4=0.03%, 10=43.31%, 20=49.51%, 50=0.18%
  cpu          : usr=0.17%, sys=0.45%, ctx=6534, majf=0, minf=26
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=6532/w=0/d=0, short=r=0/w=0/d=0
sequentielllesen: (groupid=1, jobs=1): err= 0: pid=2199
  read : io=54658KB, bw=932798 B/s, iops=101 , runt= 60002msec
    slat (usec): min=5 , max=140 , avg=28.63, stdev= 9.91
    clat (usec): min=39 , max=34210 , avg=9799.18, stdev=4471.32
     lat (usec): min=45 , max=34228 , avg=9828.50, stdev=4472.06
    clat percentiles (usec):
     |  1.00th=[   61],  5.00th=[ 5088], 10.00th=[ 5856], 20.00th=[ 5920],
     | 30.00th=[ 5984], 40.00th=[ 6048], 50.00th=[11840], 60.00th=[12608],
     | 70.00th=[12608], 80.00th=[12736], 90.00th=[16512], 95.00th=[17536],
     | 99.00th=[18816], 99.50th=[19584], 99.90th=[24960], 99.95th=[29568],
     | 99.99th=[34048]
    bw (KB/s)  : min=  405, max= 2680, per=100.00%, avg=912.92, stdev=261.62
    lat (usec) : 50=0.41%, 100=1.77%, 250=1.20%, 500=0.23%, 750=0.02%
    lat (usec) : 1000=0.03%
    lat (msec) : 2=0.02%, 10=43.06%, 20=52.91%, 50=0.36%
  cpu          : usr=0.15%, sys=0.45%, ctx=6103, majf=0, minf=28
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=6101/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=59036KB, aggrb=983KB/s, minb=983KB/s, maxb=983KB/s, mint=60002msec, maxt=60002msec

Run status group 1 (all jobs):
   READ: io=54658KB, aggrb=910KB/s, minb=910KB/s, maxb=910KB/s, mint=60002msec, maxt=60002msec

Disk stats (read/write):
  sda: ios=12660/2072, merge=5/34, ticks=119452/22496, in_queue=141936, util=99.30%

> … or get yourself another SSD. Its your decision.
> 
> I admire your endurance. ;)

Since I've gotten 2 SSDs to make sure I didn't get one bad one, and that the
company is greating great reviews for them, I'm now pretty sure that
it's either a problem with a linux driver, which is interesting for us
all to debug :)
If I go buy another brand, the next guy will have the same problems than
me.

But yes, if we figure this out, Samsung owes you and me some money :)

I'll try plugging this SSD in a totally different PC and see what happens.
This may say if it's an AHCI/intel sata driver problem.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
