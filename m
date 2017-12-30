Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:46041 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdL3AQB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 19:16:01 -0500
Received: by mail-it0-f45.google.com with SMTP id z6so32376240iti.4
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 16:16:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171229221429.30053615@demfloro.ru>
References: <20171229020914.3618-1-nefelim4ag@gmail.com> <20171229214159.33932054@demfloro.ru>
 <20171229221429.30053615@demfloro.ru>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 30 Dec 2017 03:15:20 +0300
Message-ID: <CAGqmi74eMoBDGRJsZ6sSc3k5VrQvfK+WREvyxJxe9QM12FEH7w@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: enchanse raid1/10 balance heuristic
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-12-29 22:14 GMT+03:00 Dmitrii Tcvetkov <demfloro@demfloro.ru>:
> On Fri, 29 Dec 2017 21:44:19 +0300
> Dmitrii Tcvetkov <demfloro@demfloro.ru> wrote:
>> > +/**
>> > + * guess_optimal - return guessed optimal mirror
>> > + *
>> > + * Optimal expected to be pid % num_stripes
>> > + *
>> > + * That's generaly ok for spread load
>> > + * Add some balancer based on queue leght to device
>> > + *
>> > + * Basic ideas:
>> > + *  - Sequential read generate low amount of request
>> > + *    so if load of drives are equal, use pid % num_stripes
>> > balancing
>> > + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as
>> > optimal
>> > + *    and repick if other dev have "significant" less queue lenght
>> > + *  - Repick optimal if queue leght of other mirror are less
>> > + */
>> > +static int guess_optimal(struct map_lookup *map, int optimal)
>> > +{
>> > +   int i;
>> > +   int round_down = 8;
>> > +   int num = map->num_stripes;
>>
>> num has to be initialized from map->sub_stripes if we're reading
>> RAID10, otherwise there will be NULL pointer dereference
>>
>
> Check can be like:
> if (map->type & BTRFS_BLOCK_GROUP_RAID10)
>         num = map->sub_stripes;
>
>>@@ -5804,10 +5914,12 @@ static int __btrfs_map_block(struct
>>btrfs_fs_info *fs_info,
>>                       stripe_index += mirror_num - 1;
>>               else {
>>                       int old_stripe_index = stripe_index;
>>+                      optimal = guess_optimal(map,
>>+                                      current->pid %
>>map->num_stripes);
>>                       stripe_index = find_live_mirror(fs_info, map,
>>                                             stripe_index,
>>                                             map->sub_stripes,
>> stripe_index +
>>-                                            current->pid %
>>map->sub_stripes,
>>+                                            optimal,
>>                                             dev_replace_is_ongoing);
>>                       mirror_num = stripe_index - old_stripe_index
>> + 1; }
>>--
>>2.15.1
>
> Also here calculation should be with map->sub_stripes too.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Why you think we need such check?
I.e. guess_optimal always called for find_live_mirror()
Both in same context, like that:

if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
  u32 factor = map->num_stripes / map->sub_stripes;

  stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
  stripe_index *= map->sub_stripes;

  if (need_full_stripe(op))
    num_stripes = map->sub_stripes;
  else if (mirror_num)
    stripe_index += mirror_num - 1;
  else {
    int old_stripe_index = stripe_index;
    stripe_index = find_live_mirror(fs_info, map,
      stripe_index,
      map->sub_stripes, stripe_index +
      current->pid % map->sub_stripes,
      dev_replace_is_ongoing);
    mirror_num = stripe_index - old_stripe_index + 1;
}

That useless to check that internally

---
Also, fio results for all hdd raid1, results from waxhead:

Original:

Disk-4k-randread-depth-32: (g=0): rw=randread, bs=(R) 4096B-512KiB,
(W) 4096B-512KiB, (T) 4096B-512KiB, ioengine=libaio, iodepth=32
Disk-4k-read-depth-8: (g=0): rw=read, bs=(R) 4096B-512KiB, (W)
4096B-512KiB, (T) 4096B-512KiB, ioengine=libaio, iodepth=8
Disk-4k-randwrite-depth-8: (g=0): rw=randwrite, bs=(R) 4096B-512KiB,
(W) 4096B-512KiB, (T) 4096B-512KiB, ioengine=libaio, iodepth=8
fio-3.1
Starting 3 processes
Disk-4k-randread-depth-32: Laying out IO file (1 file / 65536MiB)
Jobs: 3 (f=3): [r(1),R(1),w(1)][100.0%][r=120MiB/s,w=9.88MiB/s][r=998,w=96
IOPS][eta 00m:00s]
Disk-4k-randread-depth-32: (groupid=0, jobs=1): err= 0: pid=3132: Fri
Dec 29 16:16:33 2017
   read: IOPS=375, BW=41.3MiB/s (43.3MB/s)(24.2GiB/600128msec)
    slat (usec): min=15, max=206039, avg=88.71, stdev=990.35
    clat (usec): min=357, max=3487.1k, avg=85022.93, stdev=141872.25
     lat (usec): min=399, max=3487.2k, avg=85112.58, stdev=141880.31
    clat percentiles (msec):
     |  1.00th=[    5],  5.00th=[    7], 10.00th=[    9], 20.00th=[   13],
     | 30.00th=[   19], 40.00th=[   27], 50.00th=[   39], 60.00th=[   56],
     | 70.00th=[   83], 80.00th=[  127], 90.00th=[  209], 95.00th=[  300],
     | 99.00th=[  600], 99.50th=[  852], 99.90th=[ 1703], 99.95th=[ 2165],
     | 99.99th=[ 2937]
   bw (  KiB/s): min=  392, max=75824, per=30.46%, avg=42736.09,
stdev=12019.09, samples=1186
   iops        : min=    3, max=  500, avg=380.24, stdev=99.50, samples=1186
  lat (usec)   : 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.29%, 10=12.33%, 20=19.67%, 50=24.92%
  lat (msec)   : 100=17.51%, 250=18.05%, 500=5.72%, 750=0.85%, 1000=0.28%
  lat (msec)   : 2000=0.29%, >=2000=0.07%
  cpu          : usr=0.67%, sys=4.62%, ctx=215716, majf=0, minf=526
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued rwt: total=225609,0,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=32
Disk-4k-read-depth-8: (groupid=0, jobs=1): err= 0: pid=3133: Fri Dec
29 16:16:33 2017
   read: IOPS=694, BW=95.8MiB/s (100MB/s)(56.1GiB/600017msec)
    slat (usec): min=8, max=617652, avg=88.88, stdev=1996.00
    clat (usec): min=95, max=1127.4k, avg=11424.86, stdev=10606.45
     lat (usec): min=138, max=1127.5k, avg=11514.53, stdev=10796.64
    clat percentiles (usec):
     |  1.00th=[  1270],  5.00th=[  2507], 10.00th=[  3261], 20.00th=[  5932],
     | 30.00th=[  6783], 40.00th=[  7701], 50.00th=[  9896], 60.00th=[ 11076],
     | 70.00th=[ 13435], 80.00th=[ 15795], 90.00th=[ 20841], 95.00th=[ 25822],
     | 99.00th=[ 36963], 99.50th=[ 45351], 99.90th=[108528], 99.95th=[137364],
     | 99.99th=[387974]
   bw (  KiB/s): min=10720, max=131855, per=69.93%, avg=98104.00,
stdev=14476.04, samples=1200
   iops        : min=   78, max= 1082, avg=694.71, stdev=111.69, samples=1200
  lat (usec)   : 100=0.01%, 250=0.04%, 500=0.12%, 750=0.25%, 1000=0.26%
  lat (msec)   : 2=2.02%, 4=11.65%, 10=36.16%, 20=38.45%, 50=10.67%
  lat (msec)   : 100=0.27%, 250=0.11%, 500=0.01%, 750=0.01%, 2000=0.01%
  cpu          : usr=0.78%, sys=7.69%, ctx=264209, majf=0, minf=521
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwt: total=416698,0,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8
Disk-4k-randwrite-depth-8: (groupid=0, jobs=1): err= 0: pid=3134: Fri
Dec 29 16:16:33 2017
  write: IOPS=81, BW=10.6MiB/s (11.1MB/s)(6362MiB/600133msec)
    slat (usec): min=16, max=429897, avg=98.81, stdev=3109.35
    clat (usec): min=240, max=2206.9k, avg=98358.53, stdev=309465.43
     lat (usec): min=305, max=2206.0k, avg=98458.24, stdev=309483.50
    clat percentiles (usec):
     |  1.00th=[   1237],  5.00th=[   3326], 10.00th=[   5080],
     | 20.00th=[   7635], 30.00th=[  10159], 40.00th=[  12911],
     | 50.00th=[  16319], 60.00th=[  21890], 70.00th=[  36439],
     | 80.00th=[  91751], 90.00th=[ 166724], 95.00th=[ 287310],
     | 99.00th=[2021655], 99.50th=[2038432], 99.90th=[2088764],
     | 99.95th=[2105541], 99.99th=[2164261]
   bw (  KiB/s): min=    8, max=91796, per=100.00%, avg=16619.21,
stdev=18128.65, samples=797
   iops        : min=    2, max=  640, avg=123.92, stdev=132.83, samples=797
  lat (usec)   : 250=0.01%, 500=0.17%, 750=0.19%, 1000=0.33%
  lat (msec)   : 2=1.34%, 4=5.01%, 10=22.34%, 20=28.22%, 50=15.76%
  lat (msec)   : 100=8.23%, 250=12.71%, 500=2.37%, 750=0.51%, 1000=0.15%
  lat (msec)   : 2000=1.05%, >=2000=1.62%
  cpu          : usr=0.20%, sys=0.72%, ctx=41618, majf=0, minf=7
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwt: total=0,48759,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
   READ: bw=137MiB/s (144MB/s), 41.3MiB/s-95.8MiB/s
(43.3MB/s-100MB/s), io=80.3GiB (86.2GB), run=600017-600128msec
  WRITE: bw=10.6MiB/s (11.1MB/s), 10.6MiB/s-10.6MiB/s
(11.1MB/s-11.1MB/s), io=6362MiB (6671MB), run=600133-600133msec

Patched:
Disk-4k-randread-depth-32: (g=0): rw=randread, bs=(R) 4096B-512KiB,
(W) 4096B-512KiB, (T) 4096B-512KiB, ioengine=libaio, iodepth=32
Disk-4k-read-depth-8: (g=0): rw=read, bs=(R) 4096B-512KiB, (W)
4096B-512KiB, (T) 4096B-512KiB, ioengine=libaio, iodepth=8
Disk-4k-randwrite-depth-8: (g=0): rw=randwrite, bs=(R) 4096B-512KiB,
(W) 4096B-512KiB, (T) 4096B-512KiB, ioengine=libaio, iodepth=8
fio-3.1
Starting 3 processes
Jobs: 3 (f=3): [r(1),R(1),w(1)][100.0%][r=67.3MiB/s,w=17.7MiB/s][r=734,w=150
IOPS][eta 00m:00s]
Disk-4k-randread-depth-32: (groupid=0, jobs=1): err= 0: pid=1755: Fri
Dec 29 22:56:57 2017
   read: IOPS=613, BW=60.6MiB/s (63.5MB/s)(35.5GiB/600060msec)
    slat (usec): min=12, max=237473, avg=163.70, stdev=1695.77
    clat (usec): min=220, max=1152.1k, avg=51952.45, stdev=56779.39
     lat (usec): min=263, max=1152.3k, avg=52117.15, stdev=56934.65
    clat percentiles (msec):
     |  1.00th=[    5],  5.00th=[    7], 10.00th=[   10], 20.00th=[   14],
     | 30.00th=[   19], 40.00th=[   25], 50.00th=[   33], 60.00th=[   43],
     | 70.00th=[   57], 80.00th=[   80], 90.00th=[  121], 95.00th=[  165],
     | 99.00th=[  271], 99.50th=[  326], 99.90th=[  456], 99.95th=[  502],
     | 99.99th=[  651]
   bw (  KiB/s): min= 7006, max=106682, per=60.69%, avg=62211.51,
stdev=14166.42, samples=1199
   iops        : min=   72, max=  825, avg=615.08, stdev=106.32, samples=1199
  lat (usec)   : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.72%, 10=11.63%, 20=20.86%, 50=32.26%
  lat (msec)   : 100=20.54%, 250=12.60%, 500=1.31%, 750=0.05%, 1000=0.01%
  lat (msec)   : 2000=0.01%
  cpu          : usr=1.14%, sys=7.37%, ctx=333462, majf=0, minf=528
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued rwt: total=368214,0,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=32
Disk-4k-read-depth-8: (groupid=0, jobs=1): err= 0: pid=1756: Fri Dec
29 22:56:57 2017
   read: IOPS=285, BW=39.5MiB/s (41.4MB/s)(23.2GiB/600056msec)
    slat (usec): min=7, max=523518, avg=115.85, stdev=2072.83
    clat (usec): min=90, max=1880.8k, avg=27860.58, stdev=49717.09
     lat (usec): min=127, max=1880.9k, avg=27977.32, stdev=49780.09
    clat percentiles (usec):
     |  1.00th=[   469],  5.00th=[  1074], 10.00th=[  1762], 20.00th=[  3654],
     | 30.00th=[  5866], 40.00th=[  7767], 50.00th=[ 10159], 60.00th=[ 13829],
     | 70.00th=[ 20841], 80.00th=[ 35390], 90.00th=[ 76022], 95.00th=[124257],
     | 99.00th=[229639], 99.50th=[304088], 99.90th=[484443], 99.95th=[591397],
     | 99.99th=[742392]
   bw (  KiB/s): min=  672, max=100966, per=39.58%, avg=40570.62,
stdev=17431.49, samples=1197
   iops        : min=   17, max=  744, avg=286.45, stdev=126.09, samples=1197
  lat (usec)   : 100=0.01%, 250=0.31%, 500=0.97%, 750=1.79%, 1000=1.49%
  lat (msec)   : 2=7.55%, 4=8.70%, 10=28.45%, 20=19.95%, 50=15.85%
  lat (msec)   : 100=7.67%, 250=6.49%, 500=0.69%, 750=0.08%, 1000=0.01%
  lat (msec)   : 2000=0.01%
  cpu          : usr=0.39%, sys=3.36%, ctx=130493, majf=0, minf=524
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwt: total=171546,0,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8
Disk-4k-randwrite-depth-8: (groupid=0, jobs=1): err= 0: pid=1757: Fri
Dec 29 22:56:57 2017
  write: IOPS=136, BW=17.2MiB/s (18.0MB/s)(10.1GiB/600007msec)
    slat (usec): min=19, max=136510, avg=114.43, stdev=1121.55
    clat (usec): min=258, max=2084.5k, avg=58607.26, stdev=103204.91
     lat (usec): min=334, max=2084.7k, avg=58722.67, stdev=103202.00
    clat percentiles (msec):
     |  1.00th=[    3],  5.00th=[    6], 10.00th=[    8], 20.00th=[   12],
     | 30.00th=[   16], 40.00th=[   21], 50.00th=[   27], 60.00th=[   37],
     | 70.00th=[   53], 80.00th=[   80], 90.00th=[  131], 95.00th=[  205],
     | 99.00th=[  506], 99.50th=[  718], 99.90th=[ 1183], 99.95th=[ 1385],
     | 99.99th=[ 1989]
 bw (  KiB/s): min=    8, max=61572, per=100.00%, avg=18098.74,
stdev=11881.08, samples=1175
   iops        : min=    2, max=  495, avg=139.63, stdev=92.08, samples=1175
  lat (usec)   : 500=0.06%, 750=0.06%, 1000=0.13%
  lat (msec)   : 2=0.55%, 4=2.32%, 10=13.21%, 20=23.07%, 50=29.51%
  lat (msec)   : 100=16.15%, 250=11.65%, 500=2.26%, 750=0.59%, 1000=0.27%
  lat (msec)   : 2000=0.16%, >=2000=0.01%
  cpu          : usr=0.38%, sys=1.35%, ctx=77040, majf=0, minf=9
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwt: total=0,81727,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
   READ: bw=100MiB/s (105MB/s), 39.5MiB/s-60.6MiB/s
(41.4MB/s-63.5MB/s), io=58.7GiB (62.0GB), run=600056-600060msec
  WRITE: bw=17.2MiB/s (18.0MB/s), 17.2MiB/s-17.2MiB/s
(18.0MB/s-18.0MB/s), io=10.1GiB (10.8GB), run=600007-600007msec

So, as you can observe, with mixed load,
that rebalance iops to random read, decrease random write/read latency.
But make sequential thread a little bit hungry,

For systems with less random load, sequential read performance must not change.
(i.e. if load below threshold of queue length for hdd).


Thanks.

-- 
Have a nice day,
Timofey.
