Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:32974 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdB0TQW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 14:16:22 -0500
Received: by mail-io0-f170.google.com with SMTP id g18so38225100ioe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 11:15:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAafysEG7qXF3ZRQPnOjALNCd0jLTHJKRi5ns8xrH4s-6eYgog@mail.gmail.com>
References: <CAAafysGxU9vaEs6actqX3ZFGkoXFvPFUAC1SjwtkZ97uuuFgJg@mail.gmail.com>
 <22708.23290.349489.765780@tree.ty.sabi.co.uk> <CAAafysEG7qXF3ZRQPnOjALNCd0jLTHJKRi5ns8xrH4s-6eYgog@mail.gmail.com>
From: John Marrett <johnf@zioncluster.ca>
Date: Mon, 27 Feb 2017 14:15:44 -0500
Message-ID: <CAAafysFaDqC3O-s4Jj8M4gXsw8J5uGPRLD_SPwiU+UqndSzuXw@mail.gmail.com>
Subject: Re: Low IOOP Performance
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>, bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liubo correctly identified direct IO as a solution for my test
performance issues, with it in use I achieved 908 read and 305 write,
not quite as fast as ZFS but more than adequate for my needs. I then
applied Peter's recommendation of switching to raid10 and tripled
performance again up to 3000 read and 1000 write IOOPs.

I do not understand why the page cache had such a large negative
impact on performance, it seems like it should have no impact or help
slightly with caching rather than severely impact both read and write
IO. Is this expected behaviour and what is the real world impact on
applications that don't use direct IO?

With regards to RAID10 my understanding is that I can't mix drive
sizes and use their full capacity on a RAID10 volume. My current
server runs a mixture of drive sizes and I am likely to need to do so
again in the future. Can I do this and still enjoy the performance
benefits of RAID 10?

> > a ten disk raid1 using 7.2k 3 TB SAS drives
>
> Those are really low IOPS-per-TB devices, but good choice for
> SAS, as they will have SCT/ERC.


I don't expect the best IOOP performance from them, they are intended
for bulk data storage, however the results I had previously didn't
seem acceptable or normal.

>
> I strongly suspect that we have a different notion of "IOPS",
> perhaps either logical vs. physical IOPS, or randomish vs.
> sequentialish IOPS. I'll have a look at your attachments in more
> detail.


I did not achieve 650 MB/s with random IO nor do I expect to, it was a
sequential write of 250 GB performed using dd with the conv=fsync
option to ensure that all writes were complete before reporting write
speed.

>
> > I created a zfs filesystem for comparison on another
> > checksumming filesystem using the same layout and measured
> > IOOP rates at 4315 read, 1449 write with sync enabled (without
> > sync it's clearly just writing to RAM), sequential performance
> > was comparable to btrfs.
>
> It seems unlikely to me that you got that with a 10-device
> mirror 'vdev', most likely you configured it as a stripe of 5x
> 2-device mirror vdevs, that is RAID10.


This is correct, it was a RAID10 across 5 mirrored volumes.

Thank you both very much for your help with my testing,

-JohnF

RAID1 Direct IO Test Results

johnf@altered-carbon:/btrfs/johnf$ fio --randrepeat=1
--ioengine=libaio --gtod_reduce=1 --name=test --filename=test --bs=4k
--iodepth=64 --size=1G --readwrite=randrw --rwmixread=75 --direct=1
test: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio-2.2.10
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 1024MB)
Jobs: 1 (f=1): [m(1)] [100.0% done] [8336KB/2732KB/0KB /s] [2084/683/0
iops] [eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=12270: Mon Feb 27 11:49:04 2017
  read : io=784996KB, bw=3634.6KB/s, iops=908, runt=215981msec
  write: io=263580KB, bw=1220.4KB/s, iops=305, runt=215981msec
  cpu          : usr=1.50%, sys=8.18%, ctx=244134, majf=0, minf=116
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=196249/w=65895/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: io=784996KB, aggrb=3634KB/s, minb=3634KB/s, maxb=3634KB/s,
mint=215981msec, maxt=215981msec
  WRITE: io=263580KB, aggrb=1220KB/s, minb=1220KB/s, maxb=1220KB/s,
mint=215981msec, maxt=215981msec


RAID10 Direct IO Test Results

johnf@altered-carbon:/btrfs/johnf$ fio --randrepeat=1
--ioengine=libaio --gtod_reduce=1 --name=test --filename=test --bs=4k
--iodepth=64 --size=1G --readwrite=randrw --rwmixread=75 --ba=4k
--direct=1
test: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio-2.2.10
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 1024MB)
Jobs: 1 (f=1): [m(1)] [100.0% done] [16136KB/5312KB/0KB /s]
[4034/1328/0 iops] [eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=12644: Mon Feb 27 13:50:35 2017
  read : io=784996KB, bw=12003KB/s, iops=3000, runt= 65401msec
  write: io=263580KB, bw=4030.3KB/s, iops=1007, runt= 65401msec
  cpu          : usr=3.66%, sys=19.54%, ctx=188302, majf=0, minf=22
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=196249/w=65895/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: io=784996KB, aggrb=12002KB/s, minb=12002KB/s, maxb=12002KB/s,
mint=65401msec, maxt=65401msec
  WRITE: io=263580KB, aggrb=4030KB/s, minb=4030KB/s, maxb=4030KB/s,
mint=65401msec, maxt=65401msec
