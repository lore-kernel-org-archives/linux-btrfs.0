Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:41790 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdL1Cdg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 21:33:36 -0500
Received: by mail-it0-f66.google.com with SMTP id x28so26857008ita.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Dec 2017 18:33:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4bc00e2e-7a46-b02c-a97b-90947fc242d9@gmx.com>
References: <20171227223931.7878-1-nefelim4ag@gmail.com> <4bc00e2e-7a46-b02c-a97b-90947fc242d9@gmx.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 28 Dec 2017 05:32:54 +0300
Message-ID: <CAGqmi77=vfULMxVUsCSqE3DAYoddwBMaPLoCjMEntQbKUF+C=Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-12-28 3:44 GMT+03:00 Qu Wenruo <quwenruo.btrfs@gmx.com>:
>
>
> On 2017年12月28日 06:39, Timofey Titovets wrote:
>> Currently btrfs raid1/10 balancer blance requests to mirrors,
>> based on pid % num of mirrors.
>>
>> Update logic and make it understood if underline device are non rotational.
>>
>> If one of mirrors are non rotational, then all read requests will be moved to
>> non rotational device.
>>
>> If both of mirrors are non rotational, calculate sum of
>> pending and in flight request for queue on that bdev and use
>> device with least queue leght.
>>
>> P.S.
>> Inspired by md-raid1 read balancing
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  fs/btrfs/volumes.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 59 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 9a04245003ab..98bc2433a920 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5216,13 +5216,30 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>>       return ret;
>>  }
>>
>> +static inline int bdev_get_queue_len(struct block_device *bdev)
>> +{
>> +     int sum = 0;
>> +     struct request_queue *rq = bdev_get_queue(bdev);
>> +
>> +     sum += rq->nr_rqs[BLK_RW_SYNC] + rq->nr_rqs[BLK_RW_ASYNC];
>> +     sum += rq->in_flight[BLK_RW_SYNC] + rq->in_flight[BLK_RW_ASYNC];
>> +
>> +     /*
>> +      * Try prevent switch for every sneeze
>> +      * By roundup output num by 2
>> +      */
>> +     return ALIGN(sum, 2);
>> +}
>> +
>>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>                           struct map_lookup *map, int first, int num,
>>                           int optimal, int dev_replace_is_ongoing)
>>  {
>>       int i;
>>       int tolerance;
>> +     struct block_device *bdev;
>>       struct btrfs_device *srcdev;
>> +     bool all_bdev_nonrot = true;
>>
>>       if (dev_replace_is_ongoing &&
>>           fs_info->dev_replace.cont_reading_from_srcdev_mode ==
>> @@ -5231,6 +5248,48 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>       else
>>               srcdev = NULL;
>>
>> +     /*
>> +      * Optimal expected to be pid % num
>> +      * That's generaly ok for spinning rust drives
>> +      * But if one of mirror are non rotating,
>> +      * that bdev can show better performance
>> +      *
>> +      * if one of disks are non rotating:
>> +      *  - set optimal to non rotating device
>> +      * if both disk are non rotating
>> +      *  - set optimal to bdev with least queue
>> +      * If both disks are spinning rust:
>> +      *  - leave old pid % nu,
>
> And I'm wondering why this case can't use the same bdev queue length?
>
> Any special reason spinning disk can't benifit from a shorter queue?
>
> Thanks,
> Qu

I didn't have spinning rust to test it,
But i expect that queue based balancing will kill sequential io balancing.

(Also, it's better to balance by avg Latency per request, i think,
but we just didn't have that property and need much more calculation)

i.e. with spinning rust "true way" (in theory),
is just trying to calculate where head at now.
As example:
based on last queryes,
and send request to hdd which have a shorter path to blocks.

That in theory will show best random read and sequential read, from
hdd raid1 array.

But for that we need some tracking of io queue:
 - Write it own, as done in mdraid
   and just believe no-one else will touch our disk
 - Make some analisys
   of queue linked to bdev, not sure if we have another way.

In theory, user with that patch just can switch rotational to 0 on
spinning rust,
but that can lead to misbehaving of io scheduler.. so may be it's a
bad idea to test that by flags.

---
About benchmarks:
Sorry, didn't have a real hardware to test,
so i don't think it's representative, but:

Fio config:
[global]
ioengine=libaio
buffered=0
direct=1
bssplit=32k/100
size=1G
directory=/mnt/
iodepth=16
time_based
runtime=60

[test-fio]
rw=randread

VM KVM:
 - Debian 9.3
 - Scheduler: noop
 - Image devid 1 on Notebook SSD.
 - Image devid 2 on Fast Enough USB Stick.
 - Both formatted to btrfs raid1.
 - Kernel patched 4.15-rc3 from misc-next kdave (that i have compiled..)
 - (I see same on backported 4.13 debian kernel)
---
Pid choice image on SSD:
test-fio: (g=0): rw=randread, bs=32K-32K/32K-32K/32K-32K,
ioengine=libaio, iodepth=16
fio-2.16
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [157.4MB/0KB/0KB /s] [5025/0/0
iops] [eta 00m:00s]
test-fio: (groupid=0, jobs=1): err= 0: pid=1217: Thu Dec 28 04:57:38 2017
 read : io=10001MB, bw=170664KB/s, iops=5333, runt= 60008msec
   slat (usec): min=7, max=13005, avg=25.58, stdev=83.45
   clat (usec): min=3, max=41567, avg=2971.16, stdev=4456.01
    lat (usec): min=251, max=41609, avg=2997.21, stdev=4457.03
   clat percentiles (usec):
    |  1.00th=[  278],  5.00th=[  298], 10.00th=[  310], 20.00th=[  338],
    | 30.00th=[  362], 40.00th=[  390], 50.00th=[  430], 60.00th=[  540],
    | 70.00th=[ 1020], 80.00th=[ 9280], 90.00th=[10816], 95.00th=[11456],
    | 99.00th=[14528], 99.50th=[16320], 99.90th=[20608], 99.95th=[23168],
    | 99.99th=[29824]
   lat (usec) : 4=0.01%, 100=0.01%, 250=0.02%, 500=57.53%, 750=8.93%
   lat (usec) : 1000=3.34%
   lat (msec) : 2=3.57%, 4=2.13%, 10=8.34%, 20=16.01%, 50=0.12%
 cpu          : usr=2.57%, sys=15.69%, ctx=249390, majf=0, minf=135
 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=320037/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  READ: io=10001MB, aggrb=170663KB/s, minb=170663KB/s,
maxb=170663KB/s, mint=60008msec, maxt=60008msec
---
Pid choice USB Stick:
test-fio: (g=0): rw=randread, bs=32K-32K/32K-32K/32K-32K,
ioengine=libaio, iodepth=16
fio-2.16
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [51891KB/0KB/0KB /s] [1621/0/0
iops] [eta 00m:00s]
test-fio: (groupid=0, jobs=1): err= 0: pid=668: Thu Dec 28 04:46:16 2017
 read : io=3131.3MB, bw=53430KB/s, iops=1669, runt= 60012msec
   slat (usec): min=7, max=12463, avg=60.39, stdev=97.64
   clat (usec): min=11, max=116362, avg=9513.58, stdev=5797.06
    lat (usec): min=274, max=116423, avg=9575.25, stdev=5800.91
   clat percentiles (usec):
    |  1.00th=[  306],  5.00th=[  362], 10.00th=[  430], 20.00th=[  932],
    | 30.00th=[10176], 40.00th=[11584], 50.00th=[11840], 60.00th=[12096],
    | 70.00th=[12480], 80.00th=[12992], 90.00th=[14272], 95.00th=[16192],
    | 99.00th=[21888], 99.50th=[25216], 99.90th=[32128], 99.95th=[36096],
    | 99.99th=[52480]
   lat (usec) : 20=0.01%, 250=0.01%, 500=12.44%, 750=4.88%, 1000=3.43%
   lat (msec) : 2=3.45%, 4=3.47%, 10=2.12%, 20=68.61%, 50=1.58%
   lat (msec) : 100=0.01%, 250=0.01%
 cpu          : usr=1.81%, sys=11.42%, ctx=89411, majf=0, minf=135
 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=100201/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  READ: io=3131.3MB, aggrb=53429KB/s, minb=53429KB/s, maxb=53429KB/s,
mint=60012msec, maxt=60012msec
---
Rotational 1 0 - Force use USB Stick:
test-fio: (g=0): rw=randread, bs=32K-32K/32K-32K/32K-32K,
ioengine=libaio, iodepth=16
fio-2.16
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [41824KB/0KB/0KB /s] [1307/0/0
iops] [eta 00m:00s]
test-fio: (groupid=0, jobs=1): err= 0: pid=2007: Thu Dec 28 05:20:37 2017
 read : io=2401.1MB, bw=40981KB/s, iops=1280, runt= 60017msec
   slat (usec): min=9, max=10397, avg=57.82, stdev=76.46
   clat (usec): min=893, max=49568, avg=12427.70, stdev=2740.99
    lat (usec): min=921, max=49752, avg=12486.61, stdev=2747.34
   clat percentiles (usec):
    |  1.00th=[ 2224],  5.00th=[10816], 10.00th=[11712], 20.00th=[11840],
    | 30.00th=[11968], 40.00th=[11968], 50.00th=[12224], 60.00th=[12480],
    | 70.00th=[12736], 80.00th=[12992], 90.00th=[14016], 95.00th=[15808],
    | 99.00th=[22144], 99.50th=[25728], 99.90th=[31104], 99.95th=[32384],
    | 99.99th=[40704]
   lat (usec) : 1000=0.01%
   lat (msec) : 2=0.21%, 4=3.12%, 10=0.98%, 20=94.06%, 50=1.62%
 cpu          : usr=1.58%, sys=8.68%, ctx=75492, majf=0, minf=137
 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=76862/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  READ: io=2401.1MB, aggrb=40981KB/s, minb=40981KB/s, maxb=40981KB/s,
mint=60017msec, maxt=60017msec
---
Rotational 0 1 - Force use Notebook SSD:
test-fio: (g=0): rw=randread, bs=32K-32K/32K-32K/32K-32K,
ioengine=libaio, iodepth=16
fio-2.16
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [403.6MB/0KB/0KB /s] [12.9K/0/0
iops] [eta 00m:00s]
test-fio: (groupid=0, jobs=1): err= 0: pid=1945: Thu Dec 28 05:18:50 2017
 read : io=24476MB, bw=417710KB/s, iops=13053, runt= 60002msec
   slat (usec): min=6, max=10812, avg=22.81, stdev=70.05
   clat (usec): min=163, max=40433, avg=1200.02, stdev=867.99
    lat (usec): min=322, max=40453, avg=1223.28, stdev=871.33
   clat percentiles (usec):
    |  1.00th=[  532],  5.00th=[  708], 10.00th=[  788], 20.00th=[  876],
    | 30.00th=[  924], 40.00th=[  972], 50.00th=[  996], 60.00th=[ 1048],
    | 70.00th=[ 1112], 80.00th=[ 1256], 90.00th=[ 1656], 95.00th=[ 2288],
    | 99.00th=[ 5216], 99.50th=[ 6944], 99.90th=[10048], 99.95th=[11456],
    | 99.99th=[16512]
   lat (usec) : 250=0.01%, 500=0.66%, 750=6.78%, 1000=43.18%
   lat (msec) : 2=42.73%, 4=4.97%, 10=1.56%, 20=0.10%, 50=0.01%
 cpu          : usr=4.30%, sys=34.59%, ctx=507897, majf=0, minf=136
 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=783233/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  READ: io=24476MB, aggrb=417710KB/s, minb=417710KB/s,
maxb=417710KB/s, mint=60002msec, maxt=60002msec
---
Rotational 0 0:
test-fio: (g=0): rw=randread, bs=32K-32K/32K-32K/32K-32K,
ioengine=libaio, iodepth=16
fio-2.16
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [393.1MB/0KB/0KB /s] [12.7K/0/0
iops] [eta 00m:00s]
test-fio: (groupid=0, jobs=1): err= 0: pid=2188: Thu Dec 28 05:25:49 2017
 read : io=22535MB, bw=384563KB/s, iops=12017, runt= 60006msec
   slat (usec): min=7, max=13287, avg=22.39, stdev=74.68
   clat (usec): min=91, max=265780, avg=1306.16, stdev=2148.92
    lat (usec): min=276, max=265853, avg=1328.99, stdev=2150.68
   clat percentiles (usec):
    |  1.00th=[  394],  5.00th=[  438], 10.00th=[  462], 20.00th=[  490],
    | 30.00th=[  516], 40.00th=[  540], 50.00th=[  572], 60.00th=[  620],
    | 70.00th=[  684], 80.00th=[  884], 90.00th=[ 5216], 95.00th=[ 5984],
    | 99.00th=[ 9024], 99.50th=[10944], 99.90th=[15296], 99.95th=[16768],
    | 99.99th=[21376]
   lat (usec) : 100=0.01%, 250=0.01%, 500=24.00%, 750=51.25%, 1000=6.88%
   lat (msec) : 2=5.03%, 4=2.09%, 10=10.05%, 20=0.69%, 50=0.01%
   lat (msec) : 250=0.01%, 500=0.01%
 cpu          : usr=4.21%, sys=31.78%, ctx=476317, majf=0, minf=137
 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=721127/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  READ: io=22535MB, aggrb=384562KB/s, minb=384562KB/s,
maxb=384562KB/s, mint=60006msec, maxt=60006msec
---

Not sure why we see so big difference, for 0 1, 1 0 and pid choice mod,
as i see in iostat on pid choice i see parasitic load on usb stick,
when ssd in testing,
may be some kernel threads re-read meta date and that cause noise... No idea.

Thanks..
