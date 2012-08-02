Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52914 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2HBVVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 17:21:54 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Marc MERLIN <marc@merlins.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Thu, 2 Aug 2012 23:21:51 +0200
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
References: <20120722185848.GA10089@merlins.org> <201208022220.08217.Martin@lichtvoll.de> <20120802204414.GA1834@merlins.org> (sfid-20120802_224653_005467_6AF6C75B)
In-Reply-To: <20120802204414.GA1834@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201208022321.51795.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 2. August 2012 schrieb Marc MERLIN:
> On Thu, Aug 02, 2012 at 10:20:07PM +0200, Martin Steigerwald wrote:
> > Hey, whats this? With Ext4 you have really good random read performance
> > now! Way better than the Intel SSD 320 and…
> 
> Yep, my du -sh tests do show that ext4 is 2x faster than btrfs.
> Obviously it's sending IO in a way that either the IO subsystem, linux
> driver, or drive prefer.

But only on reads.

> > > > Have the IOPS run on the device it self. That will remove any filesystem
> > > > layer. But only the read only tests, to make sure I suggest to use fio
> > > > with the --readonly option as safety guard. Unless you have a spare SSD
> > > > that you can afford to use for write testing which will likely destroy
> > > > every filesystem on it. Or let it run on just one logical volume.
> > >  
> > > Can you send me a recommended job config you'd like me to run if the runs
> > > above haven't already answered your questions?
>  
> > [global]
> (...)
> 
> I used this and just changed filename to /dev/sda. Since I'm reading
> from the beginning of the drive, reads have to be aligned.
> 
> > I won´t expect much of a difference, but then the random read performance
> > is quite different between Ext4 and BTRFS on this disk. That would make
> > it interesting to test without any filesystem in between and over the
> > whole device.
> 
> Here is the output:
> gandalfthegreat:~# fio --readonly ./fio.job3
> zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=1
> sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=1
> 2.0.8
> Starting 2 processes
> Jobs: 1 (f=1): [_R] [66.9% done] [966K/0K /s] [108 /0  iops] [eta 01m:00s] 
> zufälliglesen: (groupid=0, jobs=1): err= 0: pid=2172
>   read : io=59036KB, bw=983.93KB/s, iops=108 , runt= 60002msec

WTF?

Hey, did you adapt the size= keyword? It seems fio 2.0.8 can do completely
without it.

Also I noticed that I had iodepth 1 in there to circumvent any in drive
cache / optimization.

>     slat (usec): min=5 , max=158 , avg=27.62, stdev=10.64
>     clat (usec): min=45 , max=27348 , avg=9150.78, stdev=4452.66
>      lat (usec): min=53 , max=27370 , avg=9179.05, stdev=4454.88
>     clat percentiles (usec):
>      |  1.00th=[  126],  5.00th=[  235], 10.00th=[ 5216], 20.00th=[ 5920],
>      | 30.00th=[ 5920], 40.00th=[ 5984], 50.00th=[ 7712], 60.00th=[12480],
>      | 70.00th=[12608], 80.00th=[12736], 90.00th=[12864], 95.00th=[16768],
>      | 99.00th=[18560], 99.50th=[18816], 99.90th=[20352], 99.95th=[22656],
>      | 99.99th=[27264]
>     bw (KB/s)  : min=  423, max= 5776, per=100.00%, avg=986.48, stdev=480.68
>     lat (usec) : 50=0.11%, 100=0.64%, 250=4.47%, 500=1.65%, 750=0.02%
>     lat (usec) : 1000=0.02%
>     lat (msec) : 2=0.06%, 4=0.03%, 10=43.31%, 20=49.51%, 50=0.18%
>   cpu          : usr=0.17%, sys=0.45%, ctx=6534, majf=0, minf=26
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=6532/w=0/d=0, short=r=0/w=0/d=0

Latency is still way to high even with iodepth 1, 10 milliseconds for
43% of requests. And the throughput and IOPS is still abysmal even
for iodepth 1 (see below for Intel SSD 320 values).

Okay, one further idea: Remove the bsrange to just test with 4k blocks.

Additionally test these are aligned with

       blockalign=int[,int], ba=int[,int]
              At what boundary to align random IO offsets. Defaults to
              the  same  as  'blocksize'  the minimum blocksize given.
              Minimum alignment is typically 512b for using direct IO,
              though  it  usually  depends on the hardware block size.
              This option is mutually exclusive with  using  a  random
              map for files, so it will turn off that option.

I would first test with 4k blocks as is. And then do something like:

blocksize=4k
blockalign=4k

And then raise

blockalign to some values that may matter like 8k, 128k, 512k, 1m or so.

But thats just guess work. I do not even exactly now if it works this
way in fio.

There is something pretty wierd going on. But I am not sure what it is.
Maybe an alignment issue, since Ext4 with stripe alignment was able to
do so much faster on reads.

> sequentielllesen: (groupid=1, jobs=1): err= 0: pid=2199
>   read : io=54658KB, bw=932798 B/s, iops=101 , runt= 60002msec

Ey, whats this?

>     slat (usec): min=5 , max=140 , avg=28.63, stdev= 9.91
>     clat (usec): min=39 , max=34210 , avg=9799.18, stdev=4471.32
>      lat (usec): min=45 , max=34228 , avg=9828.50, stdev=4472.06
>     clat percentiles (usec):
>      |  1.00th=[   61],  5.00th=[ 5088], 10.00th=[ 5856], 20.00th=[ 5920],
>      | 30.00th=[ 5984], 40.00th=[ 6048], 50.00th=[11840], 60.00th=[12608],
>      | 70.00th=[12608], 80.00th=[12736], 90.00th=[16512], 95.00th=[17536],
>      | 99.00th=[18816], 99.50th=[19584], 99.90th=[24960], 99.95th=[29568],
>      | 99.99th=[34048]
>     bw (KB/s)  : min=  405, max= 2680, per=100.00%, avg=912.92, stdev=261.62
>     lat (usec) : 50=0.41%, 100=1.77%, 250=1.20%, 500=0.23%, 750=0.02%
>     lat (usec) : 1000=0.03%
>     lat (msec) : 2=0.02%, 10=43.06%, 20=52.91%, 50=0.36%
>   cpu          : usr=0.15%, sys=0.45%, ctx=6103, majf=0, minf=28
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=6101/w=0/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>    READ: io=59036KB, aggrb=983KB/s, minb=983KB/s, maxb=983KB/s, mint=60002msec, maxt=60002msec
> 
> Run status group 1 (all jobs):
>    READ: io=54658KB, aggrb=910KB/s, minb=910KB/s, maxb=910KB/s, mint=60002msec, maxt=60002msec
> 
> Disk stats (read/write):
>   sda: ios=12660/2072, merge=5/34, ticks=119452/22496, in_queue=141936, util=99.30%

What on earth is this?

You are testing the raw device and are getting these fun values out of it?
Let me repeat that here:

merkaba:/tmp> cat iops-read.job 
[global]
ioengine=libaio
direct=1
filename=/dev/sda
bsrange=2k-16k

[zufälliglesen]
rw=randread
runtime=60

[sequentielllesen]
stonewall
rw=read
runtime=60

merkaba:/tmp> fio iops-read.job
zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=1
sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=1
2.0.8
Starting 2 processes
Jobs: 1 (f=1): [_R] [66.9% done] [57784K/0K /s] [6471 /0  iops] [eta 01m:00s]
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=31915
  read : io=1681.2MB, bw=28692KB/s, iops=3193 , runt= 60001msec
    slat (usec): min=5 , max=991 , avg=31.18, stdev=10.07
    clat (usec): min=2 , max=3312 , avg=276.67, stdev=124.41
     lat (usec): min=48 , max=3337 , avg=308.54, stdev=125.51
    clat percentiles (usec):
     |  1.00th=[   61],  5.00th=[   82], 10.00th=[  103], 20.00th=[  159],
     | 30.00th=[  201], 40.00th=[  237], 50.00th=[  270], 60.00th=[  306],
     | 70.00th=[  354], 80.00th=[  402], 90.00th=[  446], 95.00th=[  478],
     | 99.00th=[  524], 99.50th=[  548], 99.90th=[  644], 99.95th=[  716],
     | 99.99th=[ 1020]
    bw (KB/s)  : min=27760, max=31784, per=100.00%, avg=28694.49, stdev=625.77
    lat (usec) : 4=0.01%, 10=0.01%, 20=0.01%, 50=0.15%, 100=8.76%
    lat (usec) : 250=34.69%, 500=54.13%, 750=2.23%, 1000=0.03%
    lat (msec) : 2=0.01%, 4=0.01%
  cpu          : usr=2.91%, sys=12.49%, ctx=199678, majf=0, minf=26
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=191587/w=0/d=0, short=r=0/w=0/d=0
sequentielllesen: (groupid=1, jobs=1): err= 0: pid=31921
  read : io=3895.9MB, bw=66487KB/s, iops=7384 , runt= 60001msec
    slat (usec): min=5 , max=518 , avg=30.18, stdev= 8.16
    clat (usec): min=1 , max=3394 , avg=100.21, stdev=83.51
     lat (usec): min=44 , max=3429 , avg=131.69, stdev=84.44
    clat percentiles (usec):
     |  1.00th=[   54],  5.00th=[   60], 10.00th=[   61], 20.00th=[   68],
     | 30.00th=[   72], 40.00th=[   79], 50.00th=[   86], 60.00th=[   92],
     | 70.00th=[   99], 80.00th=[  105], 90.00th=[  112], 95.00th=[  163],
     | 99.00th=[  556], 99.50th=[  716], 99.90th=[  900], 99.95th=[  940],
     | 99.99th=[ 1080]
    bw (KB/s)  : min=30276, max=81176, per=99.95%, avg=66453.19, stdev=10893.90
    lat (usec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.57%
    lat (usec) : 100=69.52%, 250=26.59%, 500=2.01%, 750=0.89%, 1000=0.39%
    lat (msec) : 2=0.02%, 4=0.01%
  cpu          : usr=7.12%, sys=27.34%, ctx=461537, majf=0, minf=27
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=443106/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=1681.2MB, aggrb=28691KB/s, minb=28691KB/s, maxb=28691KB/s, mint=60001msec, maxt=60001msec

Run status group 1 (all jobs):
   READ: io=3895.9MB, aggrb=66487KB/s, minb=66487KB/s, maxb=66487KB/s, mint=60001msec, maxt=60001msec

Disk stats (read/write):
  sda: ios=632851/228, merge=0/140, ticks=106392/351, in_queue=105682, util=87.78%


I have seen about 4000 IOPS with pure 4k blocks from that drive with 4k
blocks, so that seems to be fine. And look at latencies, barely some
requests in low millisecond range.

Now just for the sake of it with iodepth 64:

merkaba:/tmp> fio iops-read.job
zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
2.0.8
Starting 2 processes
Jobs: 1 (f=1): [_R] [66.9% done] [217.8M/0K /s] [24.1K/0  iops] [eta 01m:00s]
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=31945
  read : io=12412MB, bw=211819KB/s, iops=23795 , runt= 60003msec
    slat (usec): min=2 , max=2158 , avg=15.69, stdev= 8.96
    clat (usec): min=138 , max=19349 , avg=2670.01, stdev=861.85
     lat (usec): min=189 , max=19366 , avg=2686.29, stdev=861.67
    clat percentiles (usec):
     |  1.00th=[ 1256],  5.00th=[ 1448], 10.00th=[ 1592], 20.00th=[ 1864],
     | 30.00th=[ 2128], 40.00th=[ 2384], 50.00th=[ 2640], 60.00th=[ 2896],
     | 70.00th=[ 3152], 80.00th=[ 3408], 90.00th=[ 3728], 95.00th=[ 3952],
     | 99.00th=[ 4448], 99.50th=[ 4896], 99.90th=[ 8768], 99.95th=[10048],
     | 99.99th=[12096]
    bw (KB/s)  : min=116464, max=216400, per=100.00%, avg=211823.16, stdev=9787.89
    lat (usec) : 250=0.01%, 500=0.01%, 750=0.02%, 1000=0.05%
    lat (msec) : 2=25.18%, 4=70.40%, 10=4.28%, 20=0.05%
  cpu          : usr=14.39%, sys=44.38%, ctx=624900, majf=0, minf=278
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=1427811/w=0/d=0, short=r=0/w=0/d=0
sequentielllesen: (groupid=1, jobs=1): err= 0: pid=32301
  read : io=12499MB, bw=213307KB/s, iops=23691 , runt= 60002msec
    slat (usec): min=1 , max=1509 , avg=12.42, stdev= 8.12
    clat (usec): min=306 , max=201523 , avg=2685.75, stdev=1220.14
     lat (usec): min=316 , max=201536 , avg=2698.70, stdev=1220.06
    clat percentiles (usec):
     |  1.00th=[ 1816],  5.00th=[ 2024], 10.00th=[ 2096], 20.00th=[ 2192],
     | 30.00th=[ 2256], 40.00th=[ 2352], 50.00th=[ 2416], 60.00th=[ 2544],
     | 70.00th=[ 2736], 80.00th=[ 2992], 90.00th=[ 3632], 95.00th=[ 4320],
     | 99.00th=[ 5664], 99.50th=[ 6112], 99.90th=[ 7136], 99.95th=[ 7712],
     | 99.99th=[26240]
    bw (KB/s)  : min=144720, max=256568, per=99.96%, avg=213210.08, stdev=23175.58
    lat (usec) : 500=0.01%, 750=0.02%, 1000=0.06%
    lat (msec) : 2=4.10%, 4=88.72%, 10=7.09%, 20=0.01%, 50=0.01%
    lat (msec) : 100=0.01%, 250=0.01%
  cpu          : usr=11.77%, sys=34.79%, ctx=440558, majf=0, minf=280
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=1421534/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=12412MB, aggrb=211818KB/s, minb=211818KB/s, maxb=211818KB/s, mint=60003msec, maxt=60003msec

Run status group 1 (all jobs):
   READ: io=12499MB, aggrb=213306KB/s, minb=213306KB/s, maxb=213306KB/s, mint=60002msec, maxt=60002msec

Disk stats (read/write):
  sda: ios=2151624/243, merge=692022/115, ticks=5719203/651132, in_queue=6372962, util=99.87%

(Seems that extra line is gone from fio 2, I darkly remember that Jens
Axboe removed some output he found to be superfluuos, but the disk stats
are still there.)

In that case random versus sequential do not even seem to make much of
a difference.

> > … or get yourself another SSD. Its your decision.
> > 
> > I admire your endurance. ;)
> 
> Since I've gotten 2 SSDs to make sure I didn't get one bad one, and that the
> company is greating great reviews for them, I'm now pretty sure that
> it's either a problem with a linux driver, which is interesting for us
> all to debug :)

Either that or there possible is some firmware update? But then those
reviews would mention it I bet.

I´d still look whether there is some firmware update available labeled:

"This will raise performance on lots of Linux based workloads by factors
of 10x to 250x" ;)

Anyway, I think now we are pretty near to the hardware.

So issue has to be somewhere in the block layer, the controller,
the SSD firmware or the SSD itself IMHO.

> If I go buy another brand, the next guy will have the same problems than
> me.
> 
> But yes, if we figure this out, Samsung owes you and me some money :)

;)
 
> I'll try plugging this SSD in a totally different PC and see what happens.
> This may say if it's an AHCI/intel sata driver problem.

Seems we will continue until someone starts to complain here. Maybe
another list will be more approbiate? But then this thread has it all
in one ;). Adding a CC with some introductory note might be approbiate.
Its your problem, so you decide ;). I´d suggest the fio mailing list,
there are other performance people how may want to chime in.

Another idea: Is there anything funny in SMART values (smartctl -a
and possibly even -x)? Well I gather these SSDs are new, but still.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
