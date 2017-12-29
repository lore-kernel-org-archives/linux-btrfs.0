Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:56828 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbdL2Soy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 13:44:54 -0500
Date: Fri, 29 Dec 2017 21:44:19 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: enchanse raid1/10 balance heuristic
Message-ID: <20171229214159.33932054@demfloro.ru>
In-Reply-To: <20171229020914.3618-1-nefelim4ag@gmail.com>
References: <20171229020914.3618-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Dec 2017 05:09:14 +0300
Timofey Titovets <nefelim4ag@gmail.com> wrote:

> Currently btrfs raid1/10 balancer balance requests to mirrors,
> based on pid % num of mirrors.
> 
> Make logic understood:
>  - if one of underline devices are non rotational
>  - Queue leght to underline devices
> 
> By default try use pid % num_mirrors guessing, but:
>  - If one of mirrors are non rotational, repick optimal to it
>  - If underline mirror have less queue leght then optimal,
>    repick to that mirror
> 
> For avoid round-robin request balancing,
> lets round down queue leght:
>  - By 8 for rotational devs
>  - By 2 for all non rotational devs
> 
> Changes:
>   v1 -> v2:
>     - Use helper part_in_flight() from genhd.c
>       to get queue lenght
>     - Move guess code to guess_optimal()
>     - Change balancer logic, try use pid % mirror by default
>       Make balancing on spinning rust if one of underline devices
>       are overloaded
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  block/genhd.c      |   1 +
>  fs/btrfs/volumes.c | 116
> ++++++++++++++++++++++++++++++++++++++++++++++++++++- 2 files
> changed, 115 insertions(+), 2 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 96a66f671720..a7742bbbb6a7 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct
> hd_struct *part, atomic_read(&part->in_flight[1]);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(part_in_flight);
>  
>  struct hd_struct *__disk_get_part(struct gendisk *disk, int partno)
>  {
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9a04245003ab..1c84534df9a5 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -27,6 +27,7 @@
>  #include <linux/raid/pq.h>
>  #include <linux/semaphore.h>
>  #include <linux/uuid.h>
> +#include <linux/genhd.h>
>  #include <asm/div64.h>
>  #include "ctree.h"
>  #include "extent_map.h"
> @@ -5216,6 +5217,112 @@ int btrfs_is_parity_mirror(struct
> btrfs_fs_info *fs_info, u64 logical, u64 len) return ret;
>  }
>  
> +/**
> + * bdev_get_queue_len - return rounded down in flight queue lenght
> of bdev
> + *
> + * @bdev: target bdev
> + * @round_down: round factor big for hdd and small for ssd, like 8
> and 2
> + */
> +static int bdev_get_queue_len(struct block_device *bdev, int
> round_down) +{
> +	int sum;
> +	struct hd_struct *bd_part = bdev->bd_part;
> +	struct request_queue *rq = bdev_get_queue(bdev);
> +	uint32_t inflight[2] = {0, 0};
> +
> +	part_in_flight(rq, bd_part, inflight);
> +
> +	sum = max_t(uint32_t, inflight[0], inflight[1]);
> +
> +	/*
> +	 * Try prevent switch for every sneeze
> +	 * By roundup output num by some value
> +	 */
> +	return ALIGN_DOWN(sum, round_down);
> +}
> +
> +/**
> + * guess_optimal - return guessed optimal mirror
> + *
> + * Optimal expected to be pid % num_stripes
> + *
> + * That's generaly ok for spread load
> + * Add some balancer based on queue leght to device
> + *
> + * Basic ideas:
> + *  - Sequential read generate low amount of request
> + *    so if load of drives are equal, use pid % num_stripes balancing
> + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
> + *    and repick if other dev have "significant" less queue lenght
> + *  - Repick optimal if queue leght of other mirror are less
> + */
> +static int guess_optimal(struct map_lookup *map, int optimal)
> +{
> +	int i;
> +	int round_down = 8;
> +	int num = map->num_stripes;

num has to be initialized from map->sub_stripes if we're reading RAID10,
otherwise there will be NULL pointer dereference

> +	int qlen[num];
> +	bool is_nonrot[num];
> +	bool all_bdev_nonrot = true;
> +	bool all_bdev_rotate = true;
> +	struct block_device *bdev;
> +
> +	if (num == 1)
> +		return optimal;
> +
> +	/* Check accessible bdevs */
> +	for (i = 0; i < num; i++) {
> +		/* Init for missing bdevs */
> +		is_nonrot[i] = false;
> +		qlen[i] = INT_MAX;
> +		bdev = map->stripes[i].dev->bdev;
> +		if (bdev) {
> +			qlen[i] = 0;
> +			is_nonrot[i] =
> blk_queue_nonrot(bdev_get_queue(bdev));
> +			if (is_nonrot[i])
> +				all_bdev_rotate = false;
> +			else
> +				all_bdev_nonrot = false;
> +		}
> +	}
> +
> +	/*
> +	 * Don't bother with computation
> +	 * if only one of two bdevs are accessible
> +	 */
> +	if (num == 2 && qlen[0] != qlen[1]) {
> +		if (qlen[0] < qlen[1])
> +			return 0;
> +		else
> +			return 1;
> +	}
> +
> +	if (all_bdev_nonrot)
> +		round_down = 2;
> +
> +	for (i = 0; i < num; i++) {
> +		if (qlen[i])
> +			continue;
> +		bdev = map->stripes[i].dev->bdev;
> +		qlen[i] = bdev_get_queue_len(bdev, round_down);
> +	}
> +
> +	/* For mixed case, pick non rotational dev as optimal */
> +	if (all_bdev_rotate == all_bdev_nonrot) {
> +		for (i = 0; i < num; i++) {
> +			if (is_nonrot[i])
> +				optimal = i;

just a nitpick: we might want to "break" here so we get first nonrot
bdev, current variant will get last nonrot bdev. This is not relevant
right now since we don't have N-way-mirroring yet and the code always
picks between two bdevs, but when it comes we might want to change it.

Here are my benchmark results with your fio config (except that
dataset is 8 Gb) in VM with 2 LVs, LVs are on different physical
devices. Patch applied on top of current mainline
(2758b3e3e630ba304fc4), all RAID1 on idle system. Unfortunately I
don't have 2 SSDs right now, so can test only HDD+SSD, 2 HDD RAID1,
4 HDD RAID10 or 3 HDD + 1 SSD RAID10:

mainline, fio got lucky to read from first HDD (quite slow HDD):
Jobs: 1 (f=1): [r(1)][100.0%][r=8456KiB/s,w=0KiB/s][r=264,w=0 IOPS][eta
00m:00s] test-fio: (groupid=0, jobs=1): err= 0: pid=1961: Fri Dec 29
18:21:57 2017 read: IOPS=265, BW=8508KiB/s (8712kB/s)(499MiB/60070msec)
    slat (usec): min=9, max=102818, avg=332.68, stdev=3583.09
    clat (msec): min=2, max=825, avg=59.84, stdev=64.95
     lat (msec): min=2, max=825, avg=60.17, stdev=65.06
    clat percentiles (msec):
     |  1.00th=[    6],  5.00th=[    8], 10.00th=[    9],
20.00th=[   14], | 30.00th=[   20], 40.00th=[   27], 50.00th=[   36],
60.00th=[   50], | 70.00th=[   68], 80.00th=[   95], 90.00th=[  144],
95.00th=[  194], | 99.00th=[  300], 99.50th=[  355], 99.90th=[  493],
99.95th=[  531], | 99.99th=[  617]
   bw (  KiB/s): min= 4800, max= 9792, per=100.00%, avg=8508.15,
stdev=963.02, samples=120 iops        : min=  150, max=  306,
avg=265.83, stdev=30.11, samples=120 lat (msec)   : 4=0.20%, 10=11.84%,
20=19.76%, 50=28.48%, 100=20.94% lat (msec)   : 250=16.66%, 500=2.03%,
750=0.08%, 1000=0.01% cpu          : usr=0.15%, sys=0.84%, ctx=15358,
majf=0, minf=136 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%,
16=99.9%, 32=0.0%, >=64=0.0% submit    : 0=0.0%, 4=100.0%, 8=0.0%,
16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0% complete  : 0=0.0%, 4=100.0%,
8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0% issued rwt:
total=15971,0,0, short=0,0,0, dropped=0,0,0 latency   : target=0,
window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=8508KiB/s (8712kB/s), 8508KiB/s-8508KiB/s
   (8712kB/s-8712kB/s), io=499MiB (523MB), run=60070-60070msec
----------------------------------------------------------------------------

mainline, fio got lucky to read from second HDD (much more modern):
Jobs: 1 (f=1): [r(1)][8.7%][r=11.9MiB/s,w=0KiB/s][r=380,w=0 IOPS][eta
10m:43s] test-fio: (groupid=0, jobs=1): err= 0: pid=1950: Fri Dec 29
18:20:09 2017 read: IOPS=378, BW=11.8MiB/s (12.4MB/s)(710MiB/60051msec)
    slat (usec): min=9, max=54852, avg=37.29, stdev=646.17
    clat (usec): min=387, max=644258, avg=42274.85, stdev=48504.35
     lat (usec): min=416, max=644286, avg=42312.74, stdev=48518.56
    clat percentiles (msec):
     |  1.00th=[    4],  5.00th=[    6], 10.00th=[    7],
20.00th=[   10], | 30.00th=[   14], 40.00th=[   19], 50.00th=[   26],
60.00th=[   34], | 70.00th=[   47], 80.00th=[   66], 90.00th=[  101],
95.00th=[  138], | 99.00th=[  232], 99.50th=[  275], 99.90th=[  393],
99.95th=[  430], | 99.99th=[  558]
   bw (  KiB/s): min= 7232, max=14016, per=99.99%, avg=12097.14,
stdev=1134.12, samples=120 iops        : min=  226, max=  438,
avg=378.01, stdev=35.44, samples=120 lat (usec)   : 500=0.01%
  lat (msec)   : 4=1.42%, 10=19.57%, 20=22.36%, 50=28.65%, 100=17.96%
  lat (msec)   : 250=9.23%, 500=0.78%, 750=0.02%
  cpu          : usr=0.23%, sys=1.23%, ctx=22717, majf=0, minf=135
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%,
>=64=0.0% submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>64=0.0%, >=64=0.0%  
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%,
>=64=0.0% issued rwt: total=22704,0,0, short=0,0,0, dropped=0,0,0  
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=11.8MiB/s (12.4MB/s), 11.8MiB/s-11.8MiB/s
   (12.4MB/s-12.4MB/s), io=710MiB (744MB), run=60051-60051msec
----------------------------------------------------------------------------
mainline, fio got lucky to read from an SSD:
Jobs: 1 (f=1): [r(1)][100.0%][r=436MiB/s,w=0KiB/s][r=13.9k,w=0
IOPS][eta 00m:00s] test-fio: (groupid=0, jobs=1): err= 0: pid=1860: Fri
Dec 29 18:10:53 2017 read: IOPS=13.9k, BW=433MiB/s
(454MB/s)(25.4GiB/60002msec) slat (usec): min=8, max=6811, avg=22.27,
stdev=16.00 clat (usec): min=289, max=16306, avg=1129.79, stdev=243.36
     lat (usec): min=343, max=16319, avg=1152.52, stdev=245.36
    clat percentiles (usec):
     |  1.00th=[  627],  5.00th=[  783], 10.00th=[  881],
20.00th=[  996], | 30.00th=[ 1057], 40.00th=[ 1106], 50.00th=[ 1123],
60.00th=[ 1172], | 70.00th=[ 1205], 80.00th=[ 1270], 90.00th=[ 1352],
95.00th=[ 1434], | 99.00th=[ 1582], 99.50th=[ 1647], 99.90th=[ 2671],
99.95th=[ 3818], | 99.99th=[ 9372]
   bw (  KiB/s): min=311552, max=447296, per=99.98%, avg=443356.12,
stdev=13068.69, samples=120 iops        : min= 9736, max=13978,
avg=13854.85, stdev=408.40, samples=120 lat (usec)   : 500=0.08%,
750=3.68%, 1000=17.33% lat (msec)   : 2=78.76%, 4=0.12%, 10=0.04%,
20=0.01% cpu          : usr=3.00%, sys=37.46%, ctx=810456, majf=0,
minf=137 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%,
32=0.0%, >=64=0.0% submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%,
32=0.0%, 64=0.0%, >=64=0.0% complete  : 0=0.0%, 4=100.0%, 8=0.0%,
16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0% issued rwt: total=831502,0,0,
short=0,0,0, dropped=0,0,0 latency   : target=0, window=0,
percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=433MiB/s (454MB/s), 433MiB/s-433MiB/s (454MB/s-454MB/s),
   io=25.4GiB (27.2GB), run=60002-60002msec
------------------------------------------------------------------------------
With the patch, 2 HDDs:
Jobs: 1 (f=1): [r(1)][100.0%][r=17.5MiB/s,w=0KiB/s][r=560,w=0 IOPS][eta
00m:00s] test-fio: (groupid=0, jobs=1): err= 0: pid=1906: Fri Dec 29
17:42:56 2017 read: IOPS=560, BW=17.5MiB/s (18.4MB/s)(1053MiB/60052msec)
    slat (usec): min=10, max=48614, avg=29.42, stdev=289.59
    clat (usec): min=408, max=341006, avg=28481.65, stdev=29999.58
     lat (usec): min=435, max=341037, avg=28511.64, stdev=30000.14
    clat percentiles (msec):
     |  1.00th=[    4],  5.00th=[    6], 10.00th=[    7],
20.00th=[    9], | 30.00th=[   11], 40.00th=[   14], 50.00th=[   18],
60.00th=[   23], | 70.00th=[   31], 80.00th=[   43], 90.00th=[   66],
95.00th=[   89], | 99.00th=[  146], 99.50th=[  174], 99.90th=[  245],
99.95th=[  268], | 99.99th=[  292]
   bw (  KiB/s): min=10304, max=19968, per=100.00%, avg=17955.02,
stdev=1408.17, samples=120 iops        : min=  322, max=  624,
avg=561.00, stdev=44.01, samples=120 lat (usec)   : 500=0.02%,
750=0.01%, 1000=0.01% lat (msec)   : 2=0.01%, 4=1.10%, 10=25.46%,
20=28.65%, 50=28.75% lat (msec)   : 100=12.38%, 250=3.54%, 500=0.09%
  cpu          : usr=0.36%, sys=1.79%, ctx=32225, majf=1, minf=136
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%,
>=64=0.0% submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>64=0.0%, >=64=0.0%  
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%,
>=64=0.0% issued rwt: total=33688,0,0, short=0,0,0, dropped=0,0,0  
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=17.5MiB/s (18.4MB/s), 17.5MiB/s-17.5MiB/s
   (18.4MB/s-18.4MB/s), io=1053MiB (1104MB), run=60052-60052msec
--------------------------------------------------------------------------------
With the patch, HDD(old one)+SSD:
Jobs: 1 (f=1): [r(1)][100.0%][r=371MiB/s,w=0KiB/s][r=11.9k,w=0
IOPS][eta 00m:00s] test-fio: (groupid=0, jobs=1): err= 0: pid=1905: Fri
Dec 29 17:50:56 2017 read: IOPS=11.6k, BW=361MiB/s
(379MB/s)(21.2GiB/60084msec) slat (usec): min=9, max=1587, avg=19.14,
stdev= 8.96 clat (usec): min=280, max=346726, avg=1362.09, stdev=6947.89
     lat (usec): min=363, max=346752, avg=1381.73, stdev=6948.32
    clat percentiles (usec):
     |  1.00th=[   449],  5.00th=[   506], 10.00th=[   537],
20.00th=[   586], | 30.00th=[   619], 40.00th=[   644],
50.00th=[   676], 60.00th=[   709], | 70.00th=[   734],
80.00th=[   775], 90.00th=[   840], 95.00th=[   922], |
99.00th=[ 20841], 99.50th=[ 43779], 99.90th=[106431], 99.95th=[135267],
| 99.99th=[210764] bw (  KiB/s): min=281229, max=384064, per=100.00%,
avg=370417.13, stdev=9942.41, samples=120 iops        : min= 8788,
max=12002, avg=11575.50, stdev=310.74, samples=120 lat (usec)   :
500=4.52%, 750=69.32%, 1000=22.82% lat (msec)   : 2=1.16%, 4=0.07%,
10=0.51%, 20=0.58%, 50=0.60% lat (msec)   : 100=0.31%, 250=0.11%,
500=0.01% cpu          : usr=3.75%, sys=25.94%, ctx=484100, majf=1,
minf=138 IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%,
32=0.0%, >=64=0.0% submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%,
32=0.0%, 64=0.0%, >=64=0.0% complete  : 0=0.0%, 4=100.0%, 8=0.0%,
16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0% issued rwt: total=694625,0,0,
short=0,0,0, dropped=0,0,0 latency   : target=0, window=0,
percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=361MiB/s (379MB/s), 361MiB/s-361MiB/s (379MB/s-379MB/s),
   io=21.2GiB (22.8GB), run=60084-60084msec
