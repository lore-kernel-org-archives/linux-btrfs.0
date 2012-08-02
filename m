Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53464 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2HBFHn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 01:07:43 -0400
Date: Wed, 1 Aug 2012 22:07:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120802050741.GA22772@merlins.org>
References: <20120722185848.GA10089@merlins.org> <CAG1y0sdnyv4O8zab+WwLxZ6qUJTcVryrAgnDfv5eiAw+eZh-Gg@mail.gmail.com> <20120801062156.GI12695@merlins.org> <201208012357.39786.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201208012357.39786.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2012 at 11:57:39PM +0200, Martin Steigerwald wrote:
> Its getting quite strange.
 
I would agree :)

Before I paste a bunch of thing, I wanted to thank you for not giving up on me 
and offering your time to help me figure this out :)

> I lost track of whether you did that already or not, but if you didn´t
> please post some
> 
> vmstat 1
> iostat -xd 1
> on the device while it is being slow.
 
Sure thing, here's the 24 second du -s run:
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  1      0 2747264     44 348388    0    0    28    50  242  184 19  6 74  1
 1  0      0 2744128     44 351700    0    0   144     0 2758 32115 30  5 61  4
 2  1      0 2743100     44 351992    0    0   792     0 2616 30613 28  4 50 18
 1  1      0 2741592     44 352668    0    0   776     0 2574 31551 29  4 45 21
 1  1      0 2740720     44 353432    0    0   692     0 2734 32891 30  4 45 22
 1  1      0 2740104     44 354284    0    0   460     0 2639 31585 30  4 45 21
 3  1      0 2738520     44 354692    0    0   544   264 2834 30302 32  5 42 21
 1  1      0 2736936     44 355476    0    0  1064  2012 2867 31172 28  4 45 23
 3  1      0 2734892     44 356840    0    0  1236     0 2865 31100 30  3 46 21
 3  1      0 2733840     44 357432    0    0   636    12 2930 31362 30  4 45 21
 3  1      0 2735152     44 357892    0    0   612     0 2546 31641 28  4 46 22
 3  1      0 2733608     44 358680    0    0   668     0 2846 29747 30  3 46 22
 2  1      0 2731480     44 359556    0    0   712   248 2744 27939 31  3 44 22
 2  1      0 2732688     44 360736    0    0  1204     0 2774 30979 30  3 46 21
 4  1      0 2730276     44 361872    0    0   872   256 3174 31657 30  5 45 20
 1  1      0 2728372     44 363008    0    0   912   132 2752 31811 30  3 46 22
 1  1      0 2727060     44 363240    0    0   476     0 2595 30313 33  4 43 21
 1  1      0 2725856     44 364000    0    0   580     0 2547 30803 29  4 46 21
 1  1      0 2723628     44 364724    0    0   756   272 2766 30652 31  4 44 22
 2  1      0 2722128     44 365616    0    0   744     8 2771 31760 30  4 45 21
 2  1      0 2721024     44 366284    0    0   788   196 2695 31819 31  4 44 22
 3  1      0 2719312     44 367084    0    0   732     0 2737 32038 30  5 45 20
 1  1      0 2717436     44 367880    0    0   728     0 2570 30810 29  3 46 22
 3  1      0 2716820     44 368500    0    0   608     0 2614 30949 29  4 45 22
 2  1      0 2715576     44 369240    0    0   628   264 2715 31180 34  4 40 22
 1  1      0 2714308     44 369952    0    0   624     0 2533 31155 28  4 46 22

Linux 3.5.0-amd64-preempt-noide-20120410 (gandalfthegreat) 	08/01/2012 	_x86_64_	(4 CPU)
rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
  2.18     0.68    6.45   17.77    78.12   153.39    19.12     0.18    7.51    8.52    7.15   4.46  10.81
  0.00     0.00  118.00    0.00   540.00     0.00     9.15     1.18    9.93    9.93    0.00   4.98  58.80
  0.00     0.00  217.00    0.00   868.00     0.00     8.00     1.90    8.77    8.77    0.00   4.44  96.40
  0.00     0.00  192.00    0.00   768.00     0.00     8.00     1.63    8.44    8.44    0.00   5.10  98.00
  0.00     0.00  119.00    0.00   476.00     0.00     8.00     1.06    9.01    9.01    0.00   8.20  97.60
  0.00     0.00  125.00    0.00   500.00     0.00     8.00     1.08    8.67    8.67    0.00   7.55  94.40
  0.00     0.00  165.00    0.00   660.00     0.00     8.00     1.50    9.12    9.12    0.00   5.87  96.80
  0.00     0.00  195.00   13.00   780.00   272.00    10.12     1.68    8.10    7.94   10.46   4.65  96.80
  0.00     0.00  173.00    0.00   692.00     0.00     8.00     1.72    9.87    9.87    0.00   5.71  98.80
  0.00     0.00  171.00    0.00   684.00     0.00     8.00     1.62    9.33    9.33    0.00   5.75  98.40
  0.00     0.00  161.00    0.00   644.00     0.00     8.00     1.52    9.57    9.57    0.00   6.14  98.80
  0.00     0.00  136.00    0.00   544.00     0.00     8.00     1.26    9.29    9.29    0.00   7.24  98.40
  0.00     0.00  199.00    0.00   796.00     0.00     8.00     1.94    9.73    9.73    0.00   4.94  98.40
  0.00     0.00  201.00    0.00   804.00     0.00     8.00     1.70    8.54    8.54    0.00   4.80  96.40
  0.00     0.00  272.00   15.00  1088.00   272.00     9.48     2.35    8.21    8.46    3.73   3.39  97.20
  0.00     0.00  208.00    1.00   832.00     4.00     8.00     1.90    9.01    9.04    4.00   4.67  97.60
  0.00     0.00  228.00    0.00   912.00     0.00     8.00     1.94    8.56    8.56    0.00   4.23  96.40
  0.00     0.00  107.00    0.00   428.00     0.00     8.00     0.98    9.05    9.05    0.00   9.12  97.60
  0.00     0.00  163.00    0.00   652.00     0.00     8.00     1.60    9.89    9.89    0.00   6.01  98.00
  0.00     0.00  162.00    0.00   648.00     0.00     8.00     1.83   10.20   10.20    0.00   6.07  98.40
  1.00    10.00  224.00   71.00   900.00  2157.50    20.73     2.82   10.14    9.50   12.17   3.35  98.80
 41.00     8.00  166.00  176.00   832.00   333.50     6.82     2.48    7.24    8.48    6.07   2.92 100.00
 18.00     0.00   78.00   72.00   388.00    36.00     5.65     2.30   15.28   16.56   13.89   6.67 100.00
 13.00     0.00  190.00   25.00   824.00    12.50     7.78     1.95    9.17    9.43    7.20   4.58  98.40
  0.00     0.00  156.00    0.00   624.00     0.00     8.00     1.36    8.72    8.72    0.00   6.26  97.60
  0.00     0.00  158.00   19.00   632.00    64.00     7.86     1.50    8.45    8.61    7.16   5.60  99.20
  0.00     0.00  176.00    0.00   704.00     0.00     8.00     1.65    9.39    9.39    0.00   5.61  98.80
  0.00     0.00   44.00    0.00   176.00     0.00     8.00     0.38    8.55    8.55    0.00   8.27  36.40

> I am interested in wait I/O and latencies and disk utilization.
 
Cool tool, I didn't know about iostat.
My r_await numbers don't look good obviously and yet %util is pretty much
100% the entire time.

Does that show that it's indeed the device that is unable to deliver the requests any quicker, despite
being an ssd, or are you reading this differently?

> Also I am interested in
> merkaba:~> hdparm -I /dev/sda | grep -i queue
>         Queue depth: 32
>            *    Native Command Queueing (NCQ)
> output for your SSD.

gandalfthegreat:/var/local# hdparm -I /dev/sda | grep -i queue   
	Queue depth: 32
	   *	Native Command Queueing (NCQ)
gandalfthegreat:/var/local# 

I've the the fio tests in:
/dev/mapper/cryptroot /var btrfs rw,noatime,compress=lzo,nossd,discard,space_cache 0 0

(discard is there, so fstrim shouldn't be needed)
 
> I also suggest to use fio with with the ssd-test example on the SSD. I
> have some comparison data available for my setup. Heck it should be
> publicly available in my ADMIN magazine article about fio. I used a bit
> different fio jobs with block sizes of 2k to 16k, but its similar enough
> and I might even have some 4k examples at hand or can easily create one.
> I also raised size and duration a bit.
> 
> An example based on whats in my article:

Thanks, here's the output.
I see bw jumping from bw=1700.8KB/s all the way to bw=474684KB/s depending
on the io size.  That's "intereesting" to say the least.

So, doctor, is it bad? :)

randomwrite: (g=0): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentialwrite: (g=1): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
randomread: (g=2): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
sequentialread: (g=3): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
2.0.8
Starting 4 processes
randomwrite: Laying out IO file(s) (1 file(s) / 2048MB)
Jobs: 1 (f=1): [___R] [100.0% done] [558.8M/0K /s] [63.8K/0  iops] [eta 00m:00s]  
randomwrite: (groupid=0, jobs=1): err= 0: pid=7193
  write: io=102048KB, bw=1700.8KB/s, iops=189 , runt= 60003msec
    slat (usec): min=21 , max=219834 , avg=5250.91, stdev=5936.55
    clat (usec): min=25 , max=738932 , avg=329339.45, stdev=106004.63
     lat (msec): min=4 , max=751 , avg=334.59, stdev=107.57
    clat percentiles (msec):
     |  1.00th=[  225],  5.00th=[  241], 10.00th=[  247], 20.00th=[  260],
     | 30.00th=[  269], 40.00th=[  281], 50.00th=[  293], 60.00th=[  306],
     | 70.00th=[  322], 80.00th=[  351], 90.00th=[  545], 95.00th=[  570],
     | 99.00th=[  627], 99.50th=[  644], 99.90th=[  709], 99.95th=[  725],
     | 99.99th=[  742]
    bw (KB/s)  : min=   11, max= 2591, per=99.83%, avg=1697.13, stdev=491.48
    lat (usec) : 50=0.01%
    lat (msec) : 10=0.02%, 20=0.02%, 50=0.05%, 100=0.14%, 250=12.89%
    lat (msec) : 500=72.44%, 750=14.43%
  cpu          : usr=0.30%, sys=2.65%, ctx=9699, majf=0, minf=19
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.3%, >=64=99.4%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=0/w=11396/d=0, short=r=0/w=0/d=0
sequentialwrite: (groupid=1, jobs=1): err= 0: pid=7218
  write: io=80994KB, bw=1349.7KB/s, iops=149 , runt= 60011msec
    slat (usec): min=15 , max=296798 , avg=6658.06, stdev=7414.10
    clat (usec): min=15 , max=962319 , avg=418984.76, stdev=128626.12
     lat (msec): min=12 , max=967 , avg=425.64, stdev=130.36
    clat percentiles (msec):
     |  1.00th=[  269],  5.00th=[  306], 10.00th=[  322], 20.00th=[  338],
     | 30.00th=[  355], 40.00th=[  371], 50.00th=[  388], 60.00th=[  404],
     | 70.00th=[  420], 80.00th=[  445], 90.00th=[  603], 95.00th=[  766],
     | 99.00th=[  881], 99.50th=[  906], 99.90th=[  938], 99.95th=[  947],
     | 99.99th=[  963]
    bw (KB/s)  : min=  418, max= 1952, per=99.31%, avg=1339.72, stdev=354.39
    lat (usec) : 20=0.01%
    lat (msec) : 20=0.01%, 50=0.11%, 100=0.27%, 250=0.29%, 500=86.93%
    lat (msec) : 750=6.87%, 1000=5.51%
  cpu          : usr=0.25%, sys=2.32%, ctx=13426, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.4%, >=64=99.3%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=0/w=8991/d=0, short=r=0/w=0/d=0
randomread: (groupid=2, jobs=1): err= 0: pid=7234
  read : io=473982KB, bw=7899.5KB/s, iops=934 , runt= 60005msec
    slat (usec): min=2 , max=31048 , avg=1065.57, stdev=3519.63
    clat (usec): min=21 , max=246981 , avg=67367.84, stdev=33459.21
     lat (msec): min=1 , max=263 , avg=68.43, stdev=33.81
    clat percentiles (msec):
     |  1.00th=[   15],  5.00th=[   25], 10.00th=[   33], 20.00th=[   39],
     | 30.00th=[   50], 40.00th=[   57], 50.00th=[   61], 60.00th=[   70],
     | 70.00th=[   76], 80.00th=[   89], 90.00th=[  111], 95.00th=[  139],
     | 99.00th=[  176], 99.50th=[  190], 99.90th=[  217], 99.95th=[  229],
     | 99.99th=[  247]
    bw (KB/s)  : min= 2912, max=11909, per=100.00%, avg=7900.46, stdev=2255.68
    lat (usec) : 50=0.01%
    lat (msec) : 2=0.17%, 4=0.16%, 10=0.35%, 20=2.49%, 50=27.44%
    lat (msec) : 100=55.05%, 250=14.34%
  cpu          : usr=0.38%, sys=2.89%, ctx=8425, majf=0, minf=276
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=56073/w=0/d=0, short=r=0/w=0/d=0
sequentialread: (groupid=3, jobs=1): err= 0: pid=7249
  read : io=2048.0MB, bw=474684KB/s, iops=52754 , runt=  4418msec
    slat (usec): min=1 , max=44869 , avg=15.35, stdev=320.96
    clat (usec): min=0 , max=67787 , avg=1145.60, stdev=3487.25
     lat (usec): min=2 , max=67801 , avg=1161.14, stdev=3508.06
    clat percentiles (usec):
     |  1.00th=[   10],  5.00th=[  187], 10.00th=[  217], 20.00th=[  249],
     | 30.00th=[  278], 40.00th=[  302], 50.00th=[  330], 60.00th=[  362],
     | 70.00th=[  398], 80.00th=[  450], 90.00th=[  716], 95.00th=[ 6624],
     | 99.00th=[16064], 99.50th=[20096], 99.90th=[44800], 99.95th=[61696],
     | 99.99th=[67072]
    bw (KB/s)  : min=50063, max=635019, per=97.34%, avg=462072.50, stdev=202894.18
    lat (usec) : 2=0.65%, 4=0.02%, 10=0.30%, 20=0.24%, 50=0.36%
    lat (usec) : 100=0.52%, 250=18.08%, 500=65.03%, 750=4.88%, 1000=0.52%
    lat (msec) : 2=0.81%, 4=0.95%, 10=4.72%, 20=2.43%, 50=0.45%
    lat (msec) : 100=0.05%
  cpu          : usr=7.52%, sys=67.56%, ctx=1494, majf=0, minf=277
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=233071/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=102048KB, aggrb=1700KB/s, minb=1700KB/s, maxb=1700KB/s, mint=60003msec, maxt=60003msec

Run status group 1 (all jobs):
  WRITE: io=80994KB, aggrb=1349KB/s, minb=1349KB/s, maxb=1349KB/s, mint=60011msec, maxt=60011msec

Run status group 2 (all jobs):
   READ: io=473982KB, aggrb=7899KB/s, minb=7899KB/s, maxb=7899KB/s, mint=60005msec, maxt=60005msec

Run status group 3 (all jobs):
   READ: io=2048.0MB, aggrb=474683KB/s, minb=474683KB/s, maxb=474683KB/s, mint=4418msec, maxt=4418msec

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
