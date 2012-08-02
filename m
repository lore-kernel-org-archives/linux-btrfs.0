Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36649 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2HBLSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 07:18:10 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Marc MERLIN <marc@merlins.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Thu, 2 Aug 2012 13:18:07 +0200
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
References: <20120722185848.GA10089@merlins.org> <201208012357.39786.Martin@lichtvoll.de> <20120802050741.GA22772@merlins.org> (sfid-20120802_121045_885836_CB856E78)
In-Reply-To: <20120802050741.GA22772@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201208021318.07747.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 2. August 2012 schrieb Marc MERLIN:
> On Wed, Aug 01, 2012 at 11:57:39PM +0200, Martin Steigerwald wrote:
> > Its getting quite strange.
>  
> I would agree :)
> 
> Before I paste a bunch of thing, I wanted to thank you for not giving up on me 
> and offering your time to help me figure this out :)

You are welcome.

Well I am holding Linux performance analysis & tuning trainings and I am
really interested into issues like this ;)

I will take care of myself and I take my time to respond or even do not
respond at all anymore if I run out of ideas ;).

> > I lost track of whether you did that already or not, but if you didn´t
> > please post some
> > 
> > vmstat 1
> > iostat -xd 1
> > on the device while it is being slow.
>  
> Sure thing, here's the 24 second du -s run:
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  2  1      0 2747264     44 348388    0    0    28    50  242  184 19  6 74  1
>  1  0      0 2744128     44 351700    0    0   144     0 2758 32115 30  5 61  4
>  2  1      0 2743100     44 351992    0    0   792     0 2616 30613 28  4 50 18
>  1  1      0 2741592     44 352668    0    0   776     0 2574 31551 29  4 45 21
>  1  1      0 2740720     44 353432    0    0   692     0 2734 32891 30  4 45 22
>  1  1      0 2740104     44 354284    0    0   460     0 2639 31585 30  4 45 21
>  3  1      0 2738520     44 354692    0    0   544   264 2834 30302 32  5 42 21
>  1  1      0 2736936     44 355476    0    0  1064  2012 2867 31172 28  4 45 23

A bit more wait I/O with not even 10% of the throughput as compared to
the Intel SSD 320 figures. Seems that Intel SSD is running circles around
your Samsung SSD while not – as expected for that use case – being fully
utilized.

> Linux 3.5.0-amd64-preempt-noide-20120410 (gandalfthegreat) 	08/01/2012 	_x86_64_	(4 CPU)
> rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>   2.18     0.68    6.45   17.77    78.12   153.39    19.12     0.18    7.51    8.52    7.15   4.46  10.81
>   0.00     0.00  118.00    0.00   540.00     0.00     9.15     1.18    9.93    9.93    0.00   4.98  58.80
>   0.00     0.00  217.00    0.00   868.00     0.00     8.00     1.90    8.77    8.77    0.00   4.44  96.40
>   0.00     0.00  192.00    0.00   768.00     0.00     8.00     1.63    8.44    8.44    0.00   5.10  98.00
>   0.00     0.00  119.00    0.00   476.00     0.00     8.00     1.06    9.01    9.01    0.00   8.20  97.60
>   0.00     0.00  125.00    0.00   500.00     0.00     8.00     1.08    8.67    8.67    0.00   7.55  94.40
>   0.00     0.00  165.00    0.00   660.00     0.00     8.00     1.50    9.12    9.12    0.00   5.87  96.80
>   0.00     0.00  195.00   13.00   780.00   272.00    10.12     1.68    8.10    7.94   10.46   4.65  96.80
>   0.00     0.00  173.00    0.00   692.00     0.00     8.00     1.72    9.87    9.87    0.00   5.71  98.80
>   0.00     0.00  171.00    0.00   684.00     0.00     8.00     1.62    9.33    9.33    0.00   5.75  98.40
>   0.00     0.00  161.00    0.00   644.00     0.00     8.00     1.52    9.57    9.57    0.00   6.14  98.80
>   0.00     0.00  136.00    0.00   544.00     0.00     8.00     1.26    9.29    9.29    0.00   7.24  98.40
>   0.00     0.00  199.00    0.00   796.00     0.00     8.00     1.94    9.73    9.73    0.00   4.94  98.40
>   0.00     0.00  201.00    0.00   804.00     0.00     8.00     1.70    8.54    8.54    0.00   4.80  96.40
>   0.00     0.00  272.00   15.00  1088.00   272.00     9.48     2.35    8.21    8.46    3.73   3.39  97.20
[…]
> > I am interested in wait I/O and latencies and disk utilization.
>  
> Cool tool, I didn't know about iostat.
> My r_await numbers don't look good obviously and yet %util is pretty much
> 100% the entire time.
> 
> Does that show that it's indeed the device that is unable to deliver the requests any quicker, despite
> being an ssd, or are you reading this differently?

That, or…

> > Also I am interested in
> > merkaba:~> hdparm -I /dev/sda | grep -i queue
> >         Queue depth: 32
> >            *    Native Command Queueing (NCQ)
> > output for your SSD.
> 
> gandalfthegreat:/var/local# hdparm -I /dev/sda | grep -i queue   
> 	Queue depth: 32
> 	   *	Native Command Queueing (NCQ)
> gandalfthegreat:/var/local# 
> 
> I've the the fio tests in:
> /dev/mapper/cryptroot /var btrfs rw,noatime,compress=lzo,nossd,discard,space_cache 0 0

… you are still using dm_crypt?

Please test without dm_crypt. My figures are from within LVM, but no
dm_crypt. Its good to have a comparable base for the measurements.

> (discard is there, so fstrim shouldn't be needed)

I can´t imagine why it should matter, but maybe its worth having some
tests without „discard“. 

> > I also suggest to use fio with with the ssd-test example on the SSD. I
> > have some comparison data available for my setup. Heck it should be
> > publicly available in my ADMIN magazine article about fio. I used a bit
> > different fio jobs with block sizes of 2k to 16k, but its similar enough
> > and I might even have some 4k examples at hand or can easily create one.
> > I also raised size and duration a bit.
> > 
> > An example based on whats in my article:
> 
> Thanks, here's the output.
> I see bw jumping from bw=1700.8KB/s all the way to bw=474684KB/s depending
> on the io size.  That's "intereesting" to say the least.
> 
> So, doctor, is it bad? :)

Well I do not engineer those SSDs, but to me it looks like either dm_crypt
is wildly hogging performance or the SSD is way slower than what I would
expect. But then you did some tests without dm_crypt AFAIR, but then it
would be interesting to repeat these tests without dm_crypt as well.

> randomwrite: (g=0): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentialwrite: (g=1): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> randomread: (g=2): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentialread: (g=3): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> 2.0.8
> Starting 4 processes
> randomwrite: Laying out IO file(s) (1 file(s) / 2048MB)
> Jobs: 1 (f=1): [___R] [100.0% done] [558.8M/0K /s] [63.8K/0  iops] [eta 00m:00s]  
> randomwrite: (groupid=0, jobs=1): err= 0: pid=7193
>   write: io=102048KB, bw=1700.8KB/s, iops=189 , runt= 60003msec
>     slat (usec): min=21 , max=219834 , avg=5250.91, stdev=5936.55
>     clat (usec): min=25 , max=738932 , avg=329339.45, stdev=106004.63
>      lat (msec): min=4 , max=751 , avg=334.59, stdev=107.57
>     clat percentiles (msec):
>      |  1.00th=[  225],  5.00th=[  241], 10.00th=[  247], 20.00th=[  260],
>      | 30.00th=[  269], 40.00th=[  281], 50.00th=[  293], 60.00th=[  306],
>      | 70.00th=[  322], 80.00th=[  351], 90.00th=[  545], 95.00th=[  570],
>      | 99.00th=[  627], 99.50th=[  644], 99.90th=[  709], 99.95th=[  725],
>      | 99.99th=[  742]
>     bw (KB/s)  : min=   11, max= 2591, per=99.83%, avg=1697.13, stdev=491.48
>     lat (usec) : 50=0.01%
>     lat (msec) : 10=0.02%, 20=0.02%, 50=0.05%, 100=0.14%, 250=12.89%
>     lat (msec) : 500=72.44%, 750=14.43%

Gosh, look at these latencies!

72,44% of all requests above 500 (in words: five hundred) milliseconds!
And 14,43% above 750 msecs. The percentage of requests served at 100 msecs
or less is was below one percent! Hey, is this an SSD or what?

Please really test without dm_crypt so that we can see whether it
introduces any kind of latency and if so in what amount.

But then let me compare. You are using iodepth=64 which fills the
device with request at maximum speed. So this will likely increase
latencies.

martin@merkaba:~[…]> fio iops-iodepth64.job 
zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
zufälligschreiben: (g=2): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentiellschreiben: (g=3): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
fio 1.57
Starting 4 processes
[…]
zufälligschreiben: (groupid=2, jobs=1): err= 0: pid=13103
  write: io=2048.0MB, bw=76940KB/s, iops=14032 , runt= 27257msec
    slat (usec): min=3 , max=6426 , avg=14.35, stdev=22.33
    clat (usec): min=82 , max=414190 , avg=4540.81, stdev=4996.47
     lat (usec): min=97 , max=414205 , avg=4555.53, stdev=4996.42
    bw (KB/s) : min=12890, max=112728, per=100.39%, avg=77240.48, stdev=20310.79
  cpu          : usr=9.67%, sys=29.47%, ctx=72053, majf=0, minf=532
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=0/382480/0, short=0/0/0
     lat (usec): 100=0.01%, 250=0.14%, 500=0.66%, 750=0.82%, 1000=1.52%
     lat (msec): 2=10.86%, 4=27.88%, 10=57.18%, 20=0.79%, 50=0.03%
     lat (msec): 100=0.07%, 250=0.04%, 500=0.01%

Still even with iodepth 64 totally different picture. And look at the IOPS
and throughput.

For reference, this refers to

[global]
ioengine=libaio
direct=1
iodepth=64
# Für zufällige Daten über die komplette Länge
# der Datei vorher Job sequentiell laufen lassen
filename=testdatei
size=2G
bsrange=2k-16k

refill_buffers=1

[zufälliglesen]
rw=randread
runtime=60

[sequentielllesen]
stonewall
rw=read
runtime=60

[zufälligschreiben]
stonewall
rw=randwrite
runtime=60

[sequentiellschreiben]
stonewall
rw=write
runtime=60

but on Ext4 instead of BTRFS.

This could be another good test. Text with Ext4 on plain logical volume
without dm_crypt.

>   cpu          : usr=0.30%, sys=2.65%, ctx=9699, majf=0, minf=19
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.3%, >=64=99.4%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=0/w=11396/d=0, short=r=0/w=0/d=0
> sequentialwrite: (groupid=1, jobs=1): err= 0: pid=7218
>   write: io=80994KB, bw=1349.7KB/s, iops=149 , runt= 60011msec
>     slat (usec): min=15 , max=296798 , avg=6658.06, stdev=7414.10
>     clat (usec): min=15 , max=962319 , avg=418984.76, stdev=128626.12
>      lat (msec): min=12 , max=967 , avg=425.64, stdev=130.36
>     clat percentiles (msec):
>      |  1.00th=[  269],  5.00th=[  306], 10.00th=[  322], 20.00th=[  338],
>      | 30.00th=[  355], 40.00th=[  371], 50.00th=[  388], 60.00th=[  404],
>      | 70.00th=[  420], 80.00th=[  445], 90.00th=[  603], 95.00th=[  766],
>      | 99.00th=[  881], 99.50th=[  906], 99.90th=[  938], 99.95th=[  947],
>      | 99.99th=[  963]
>     bw (KB/s)  : min=  418, max= 1952, per=99.31%, avg=1339.72, stdev=354.39
>     lat (usec) : 20=0.01%
>     lat (msec) : 20=0.01%, 50=0.11%, 100=0.27%, 250=0.29%, 500=86.93%
>     lat (msec) : 750=6.87%, 1000=5.51%

Sequential write latencies are abysmal as well.

sequentiellschreiben: (groupid=3, jobs=1): err= 0: pid=13105
  write: io=2048.0MB, bw=155333KB/s, iops=17290 , runt= 13501msec
    slat (usec): min=2 , max=4299 , avg=13.51, stdev=18.91
    clat (usec): min=334 , max=201706 , avg=3680.94, stdev=2088.53
     lat (usec): min=340 , max=201718 , avg=3694.83, stdev=2088.28
    bw (KB/s) : min=144952, max=162856, per=100.04%, avg=155394.92, stdev=5720.43
  cpu          : usr=16.77%, sys=31.17%, ctx=47790, majf=0, minf=535
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=0/233444/0, short=0/0/0
     lat (usec): 500=0.01%, 750=0.02%, 1000=0.03%
     lat (msec): 2=0.55%, 4=77.52%, 10=21.86%, 20=0.01%, 100=0.01%
     lat (msec): 250=0.01%

>   cpu          : usr=0.25%, sys=2.32%, ctx=13426, majf=0, minf=21
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.4%, >=64=99.3%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=0/w=8991/d=0, short=r=0/w=0/d=0
> randomread: (groupid=2, jobs=1): err= 0: pid=7234
>   read : io=473982KB, bw=7899.5KB/s, iops=934 , runt= 60005msec
>     slat (usec): min=2 , max=31048 , avg=1065.57, stdev=3519.63
>     clat (usec): min=21 , max=246981 , avg=67367.84, stdev=33459.21
>      lat (msec): min=1 , max=263 , avg=68.43, stdev=33.81
>     clat percentiles (msec):
>      |  1.00th=[   15],  5.00th=[   25], 10.00th=[   33], 20.00th=[   39],
>      | 30.00th=[   50], 40.00th=[   57], 50.00th=[   61], 60.00th=[   70],
>      | 70.00th=[   76], 80.00th=[   89], 90.00th=[  111], 95.00th=[  139],
>      | 99.00th=[  176], 99.50th=[  190], 99.90th=[  217], 99.95th=[  229],
>      | 99.99th=[  247]
>     bw (KB/s)  : min= 2912, max=11909, per=100.00%, avg=7900.46, stdev=2255.68
>     lat (usec) : 50=0.01%
>     lat (msec) : 2=0.17%, 4=0.16%, 10=0.35%, 20=2.49%, 50=27.44%
>     lat (msec) : 100=55.05%, 250=14.34%

Even read latencies are really high.

zufälliglesen: (groupid=0, jobs=1): err= 0: pid=13101
  read : io=2048.0MB, bw=162545KB/s, iops=29719 , runt= 12902msec
    slat (usec): min=2 , max=1485 , avg=10.58, stdev=10.81
    clat (usec): min=246 , max=18706 , avg=2140.05, stdev=1073.28
     lat (usec): min=267 , max=18714 , avg=2150.97, stdev=1074.42
    bw (KB/s) : min=108000, max=205060, per=101.08%, avg=164305.12, stdev=32494.26
  cpu          : usr=12.74%, sys=49.83%, ctx=82018, majf=0, minf=276
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=383439/0/0, short=0/0/0
     lat (usec): 250=0.01%, 500=0.03%, 750=0.30%, 1000=3.21%
     lat (msec): 2=48.26%, 4=44.68%, 10=3.35%, 20=0.18%


Here for comparison that 500 GB 2.5 inch eSATA Hitachi disk (5400rpm):

merkaba:[…]> fio --readonly iops-gerät-lesend-iodepth64.job
zufälliglesen: (g=0): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentielllesen: (g=1): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
fio 1.57
Starting 2 processes
Jobs: 1 (f=1): [_R] [66.9% done] [79411K/0K /s] [8617 /0  iops] [eta 01m:00s]
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=32578
  read : io=58290KB, bw=984592 B/s, iops=106 , runt= 60623msec
    slat (usec): min=3 , max=82 , avg=24.63, stdev= 6.64
    clat (msec): min=40 , max=2825 , avg=602.78, stdev=374.10
     lat (msec): min=40 , max=2825 , avg=602.80, stdev=374.10
    bw (KB/s) : min=    0, max= 1172, per=65.52%, avg=629.66, stdev=466.50
  cpu          : usr=0.24%, sys=0.64%, ctx=6443, majf=0, minf=275
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.5%, >=64=99.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=6435/0/0, short=0/0/0
     lat (msec): 50=0.20%, 100=2.61%, 250=15.37%, 500=26.64%, 750=25.07%
     lat (msec): 1000=16.13%, 2000=13.44%, >=2000=0.54%

Okay, so at least your SSD has shorter random read latencies than this
slow harddisk. ;)

Has a queue depth of 32 as well.

>   cpu          : usr=0.38%, sys=2.89%, ctx=8425, majf=0, minf=276
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=56073/w=0/d=0, short=r=0/w=0/d=0
> sequentialread: (groupid=3, jobs=1): err= 0: pid=7249
>   read : io=2048.0MB, bw=474684KB/s, iops=52754 , runt=  4418msec
>     slat (usec): min=1 , max=44869 , avg=15.35, stdev=320.96
>     clat (usec): min=0 , max=67787 , avg=1145.60, stdev=3487.25
>      lat (usec): min=2 , max=67801 , avg=1161.14, stdev=3508.06
>     clat percentiles (usec):
>      |  1.00th=[   10],  5.00th=[  187], 10.00th=[  217], 20.00th=[  249],
>      | 30.00th=[  278], 40.00th=[  302], 50.00th=[  330], 60.00th=[  362],
>      | 70.00th=[  398], 80.00th=[  450], 90.00th=[  716], 95.00th=[ 6624],
>      | 99.00th=[16064], 99.50th=[20096], 99.90th=[44800], 99.95th=[61696],
>      | 99.99th=[67072]
>     bw (KB/s)  : min=50063, max=635019, per=97.34%, avg=462072.50, stdev=202894.18
>     lat (usec) : 2=0.65%, 4=0.02%, 10=0.30%, 20=0.24%, 50=0.36%
>     lat (usec) : 100=0.52%, 250=18.08%, 500=65.03%, 750=4.88%, 1000=0.52%
>     lat (msec) : 2=0.81%, 4=0.95%, 10=4.72%, 20=2.43%, 50=0.45%
>     lat (msec) : 100=0.05%
>   cpu          : usr=7.52%, sys=67.56%, ctx=1494, majf=0, minf=277
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=233071/w=0/d=0, short=r=0/w=0/d=0

Intel SSD 320:

sequentielllesen: (groupid=1, jobs=1): err= 0: pid=13102
  read : io=2048.0MB, bw=252699KB/s, iops=28043 , runt=  8299msec
    slat (usec): min=2 , max=1416 , avg=10.75, stdev=10.95
    clat (usec): min=305 , max=201105 , avg=2268.82, stdev=2066.69
     lat (usec): min=319 , max=201114 , avg=2279.94, stdev=2066.61
    bw (KB/s) : min=249424, max=254472, per=100.03%, avg=252776.50, stdev=1416.63
  cpu          : usr=12.29%, sys=43.62%, ctx=43913, majf=0, minf=278
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=232729/0/0, short=0/0/0
     lat (usec): 500=0.01%, 750=0.06%, 1000=0.10%
     lat (msec): 2=11.00%, 4=88.32%, 10=0.50%, 20=0.01%, 50=0.01%
     lat (msec): 100=0.01%, 250=0.01%


Harddisk again:

sequentielllesen: (groupid=1, jobs=1): err= 0: pid=32580
  read : io=4510.3MB, bw=76964KB/s, iops=8551 , runt= 60008msec
    slat (usec): min=1 , max=3373 , avg=10.03, stdev= 8.96
    clat (msec): min=1 , max=49 , avg= 7.47, stdev= 1.14
     lat (msec): min=1 , max=49 , avg= 7.48, stdev= 1.14
    bw (KB/s) : min=72608, max=79588, per=100.05%, avg=77003.96, stdev=1626.66
  cpu          : usr=6.89%, sys=16.96%, ctx=229486, majf=0, minf=277
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=513184/0/0, short=0/0/0
     lat (msec): 2=0.01%, 4=0.02%, 10=99.67%, 20=0.29%, 50=0.01%

Maximum latencies on our SSD are longer. Minimum latencies shorter.

Well sequential stuff might not be located sequential on the SSD, the SSD
controller might put the stuff from a big file into totally different places.

> Run status group 0 (all jobs):
>   WRITE: io=102048KB, aggrb=1700KB/s, minb=1700KB/s, maxb=1700KB/s, mint=60003msec, maxt=60003msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=80994KB, aggrb=1349KB/s, minb=1349KB/s, maxb=1349KB/s, mint=60011msec, maxt=60011msec
> 
> Run status group 2 (all jobs):
>    READ: io=473982KB, aggrb=7899KB/s, minb=7899KB/s, maxb=7899KB/s, mint=60005msec, maxt=60005msec
> 
> Run status group 3 (all jobs):
>    READ: io=2048.0MB, aggrb=474683KB/s, minb=474683KB/s, maxb=474683KB/s, mint=4418msec, maxt=4418msec

Thats pathetic except for the last job group (each group has one job here
cause of the stonewall commands) of reading sequentially. Strangely
sequential write is also abysmally slow.

This is how I expect this to look like with iodepth 64:

Run status group 0 (all jobs):
   READ: io=2048.0MB, aggrb=162544KB/s, minb=166445KB/s, maxb=166445KB/s, mint=12902msec, maxt=12902msec

Run status group 1 (all jobs):
   READ: io=2048.0MB, aggrb=252699KB/s, minb=258764KB/s, maxb=258764KB/s, mint=8299msec, maxt=8299msec

Run status group 2 (all jobs):
  WRITE: io=2048.0MB, aggrb=76939KB/s, minb=78786KB/s, maxb=78786KB/s, mint=27257msec, maxt=27257msec

Run status group 3 (all jobs):
  WRITE: io=2048.0MB, aggrb=155333KB/s, minb=159061KB/s, maxb=159061KB/s, mint=13501msec, maxt=13501msec


Can you also post the last lines:

Disk stats (read/write):
  dm-2: ios=616191/613142, merge=0/0, ticks=1300820/2565384, in_queue=3867448, util=98.81%, aggrios=504829/504643, aggrmerge=111362/111451, aggrticks=1058320/2164664, aggrin_queue=3223048, aggrutil=98.78%
    sda: ios=504829/504643, merge=111362/111451, ticks=1058320/2164664, in_queue=3223048, util=98.78%
martin@merkaba:~/Artikel/LinuxNewMedia/fio/Recherche/Messungen/merkaba>


Its gives information on who good the I/O scheduler was able to merge requests.

I didn´t see much of a difference between CFQ and noop, so it may not
matter much, but since it gives also a number on total disk utilization
its still quite nice to have.


So my recommendation of now:

Remove as much factors as possible and in order to compare results with
what I posted try with plain logical volume with Ext4.

If the values are still quite slow, I think its good to ask Linux
block layer experts – for example by posting on fio mailing list where
there are people subscribed that may be able to provide other test
results – and SSD experts. There might be a Linux block layer mailing
list or use libata or fsdevel, I don´t know.

If your Samsung SSD turns out to be this slow or almost this slow on
such a basic level, I am out of ideas.

Besides except:

Have the IOPS run on the device it self. That will remove any filesystem
layer. But only the read only tests, to make sure I suggest to use fio
with the --readonly option as safety guard. Unless you have a spare SSD
that you can afford to use for write testing which will likely destroy
every filesystem on it. Or let it run on just one logical volume.

If its then slow, then I´d tend to use a different SSD and test from
there. If its then faster, I´d tend to believe that its either a hardware
or probably more likely a compatibilty issue.

What does your SSD report discard alignment – well but even that should
not matter for reads:

merkaba:/sys/block/sda> cat discard_alignment 
0

Seems Intel tells us to not care at all. Or the value for some reason
cannot be read.

merkaba:/sys/block/sda> cd queue
merkaba:/sys/block/sda/queue> grep . *
add_random:1
discard_granularity:512
discard_max_bytes:2147450880
discard_zeroes_data:1
hw_sector_size:512

I would be interested whether these above differ.

grep: iosched: Ist ein Verzeichnis
iostats:1
logical_block_size:512
max_hw_sectors_kb:32767
max_integrity_segments:0
max_sectors_kb:512
max_segments:168
max_segment_size:65536
minimum_io_size:512
nomerges:0
nr_requests:128
optimal_io_size:0
physical_block_size:512
read_ahead_kb:128
rotational:0
rq_affinity:1
scheduler:noop deadline [cfq]

And whether there is any optimal io size.

One note regarding this: Back then I made the Ext4 I carried above tests
in the last year to be aligned to what I think could be good for the SSD.
I do not know whether this matters much.

merkaba:~> tune2fs -l /dev/merkaba/home 
RAID stripe width:        128

Which should be in blocks and alignto 512 KiB. Hmmm, I am a bit puzzled
about this value at the moment. Either 1 MiB or 128 KiB would make sense
to me. But then what I do not about the erase block size of that SSD.


Then add BTRFS and then dm_crypt and look at how the numbers change.

I think this is a plan to find out whether its either really the hardware
or some wierd happening in the low level parts of Linux, e.g. the block
layer or dm_crypt or filing system.

Reduce it to the most basic level and then work from there.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
