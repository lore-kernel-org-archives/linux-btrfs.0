Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33496 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeABVY0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jan 2018 16:24:26 -0500
Received: by mail-io0-f196.google.com with SMTP id t63so116245iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jan 2018 13:24:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180102183152.GB22892@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
References: <20171230203204.13151-1-nefelim4ag@gmail.com> <20180102183152.GB22892@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 3 Jan 2018 00:23:44 +0300
Message-ID: <CAGqmi74KanHmQm-r9Sxa11QWz68bjPAvWWpZ-Zg3PvJ90HPbpw@mail.gmail.com>
Subject: Re: [PATCH V3] Btrfs: enchanse raid1/10 balance heuristic
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-01-02 21:31 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
> On Sat, Dec 30, 2017 at 11:32:04PM +0300, Timofey Titovets wrote:
>> Currently btrfs raid1/10 balancer bаlance requests to mirrors,
>> based on pid % num of mirrors.
>>
>> Make logic understood:
>>  - if one of underline devices are non rotational
>>  - Queue leght to underline devices
>>
>> By default try use pid % num_mirrors guessing, but:
>>  - If one of mirrors are non rotational, repick optimal to it
>>  - If underline mirror have less queue leght then optimal,
>>    repick to that mirror
>>
>> For avoid round-robin request balancing,
>> lets round down queue leght:
>>  - By 8 for rotational devs
>>  - By 2 for all non rotational devs
>>
>
> Sorry for making a late comment on v3.
>
> It's good to choose non-rotational if it could.
>
> But I'm not sure whether it's a good idea to guess queue depth here
> because filesystem is still at a high position of IO stack.  It'd
> probably get good results when running tests, but in practical mixed
> workloads, the underlying queue depth will be changing all the time.

First version supposed for SSD, SSD + HDD only cases.
At that version that just a "attempt", make LB on hdd.
That can be easy dropped, if we decide that's a bad behaviour.

If i understood correctly, which counters used,
we check count of I/O ops that device processing currently
(i.e. after merging & etc),
not queue what not send (i.e. before merging & etc).

i.e. we guessed based on low level block io stuff.
As example that not work on zram devs (AFAIK, as zram don't have that counters).

So, no matter at which level we check that.

> In fact, I think for rotational disks, more merging and less seeking
> make more sense, even in raid1/10 case.
>
> Thanks,
>
> -liubo

queue_depth changing must not create big problems there,
i.e. round_down must make all changes "equal".

For hdd, if we have a "big" (8..16?) queue depth,
with high probability that hdd overloaded,
and if other hdd have much less load
(may be instead of round_down, that better use abs diff > 8)
we try to requeue requests to other hdd.

That will not show true equal distribution, but in case where
one disks have more load, and pid based mechanism fail to make LB,
we will just move part of load to other hdd.

Until load distribution will not changed.

May be for HDD that need to make threshold more aggressive, like 16
(i.e. afaik SATA drives have hw rq len 31, so just use half of that).

Thanks.

>> Changes:
>>   v1 -> v2:
>>     - Use helper part_in_flight() from genhd.c
>>       to get queue lenght
>>     - Move guess code to guess_optimal()
>>     - Change balancer logic, try use pid % mirror by default
>>       Make balancing on spinning rust if one of underline devices
>>       are overloaded
>>   v2 -> v3:
>>     - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  block/genhd.c      |   1 +
>>  fs/btrfs/volumes.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 114 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/genhd.c b/block/genhd.c
>> index 96a66f671720..a7742bbbb6a7 100644
>> --- a/block/genhd.c
>> +++ b/block/genhd.c
>> @@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct hd_struct *part,
>>                               atomic_read(&part->in_flight[1]);
>>       }
>>  }
>> +EXPORT_SYMBOL_GPL(part_in_flight);
>>
>>  struct hd_struct *__disk_get_part(struct gendisk *disk, int partno)
>>  {
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 49810b70afd3..a3b80ba31d4d 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/raid/pq.h>
>>  #include <linux/semaphore.h>
>>  #include <linux/uuid.h>
>> +#include <linux/genhd.h>
>>  #include <asm/div64.h>
>>  #include "ctree.h"
>>  #include "extent_map.h"
>> @@ -5153,6 +5154,111 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>>       return ret;
>>  }
>>
>> +/**
>> + * bdev_get_queue_len - return rounded down in flight queue lenght of bdev
>> + *
>> + * @bdev: target bdev
>> + * @round_down: round factor big for hdd and small for ssd, like 8 and 2
>> + */
>> +static int bdev_get_queue_len(struct block_device *bdev, int round_down)
>> +{
>> +     int sum;
>> +     struct hd_struct *bd_part = bdev->bd_part;
>> +     struct request_queue *rq = bdev_get_queue(bdev);
>> +     uint32_t inflight[2] = {0, 0};
>> +
>> +     part_in_flight(rq, bd_part, inflight);
>> +
>> +     sum = max_t(uint32_t, inflight[0], inflight[1]);
>> +
>> +     /*
>> +      * Try prevent switch for every sneeze
>> +      * By roundup output num by some value
>> +      */
>> +     return ALIGN_DOWN(sum, round_down);
>> +}
>> +
>> +/**
>> + * guess_optimal - return guessed optimal mirror
>> + *
>> + * Optimal expected to be pid % num_stripes
>> + *
>> + * That's generaly ok for spread load
>> + * Add some balancer based on queue leght to device
>> + *
>> + * Basic ideas:
>> + *  - Sequential read generate low amount of request
>> + *    so if load of drives are equal, use pid % num_stripes balancing
>> + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
>> + *    and repick if other dev have "significant" less queue lenght
>> + *  - Repick optimal if queue leght of other mirror are less
>> + */
>> +static int guess_optimal(struct map_lookup *map, int num, int optimal)
>> +{
>> +     int i;
>> +     int round_down = 8;
>> +     int qlen[num];
>> +     bool is_nonrot[num];
>> +     bool all_bdev_nonrot = true;
>> +     bool all_bdev_rotate = true;
>> +     struct block_device *bdev;
>> +
>> +     if (num == 1)
>> +             return optimal;
>> +
>> +     /* Check accessible bdevs */
>> +     for (i = 0; i < num; i++) {
>> +             /* Init for missing bdevs */
>> +             is_nonrot[i] = false;
>> +             qlen[i] = INT_MAX;
>> +             bdev = map->stripes[i].dev->bdev;
>> +             if (bdev) {
>> +                     qlen[i] = 0;
>> +                     is_nonrot[i] = blk_queue_nonrot(bdev_get_queue(bdev));
>> +                     if (is_nonrot[i])
>> +                             all_bdev_rotate = false;
>> +                     else
>> +                             all_bdev_nonrot = false;
>> +             }
>> +     }
>> +
>> +     /*
>> +      * Don't bother with computation
>> +      * if only one of two bdevs are accessible
>> +      */
>> +     if (num == 2 && qlen[0] != qlen[1]) {
>> +             if (qlen[0] < qlen[1])
>> +                     return 0;
>> +             else
>> +                     return 1;
>> +     }
>> +
>> +     if (all_bdev_nonrot)
>> +             round_down = 2;
>> +
>> +     for (i = 0; i < num; i++) {
>> +             if (qlen[i])
>> +                     continue;
>> +             bdev = map->stripes[i].dev->bdev;
>> +             qlen[i] = bdev_get_queue_len(bdev, round_down);
>> +     }
>> +
>> +     /* For mixed case, pick non rotational dev as optimal */
>> +     if (all_bdev_rotate == all_bdev_nonrot) {
>> +             for (i = 0; i < num; i++) {
>> +                     if (is_nonrot[i])
>> +                             optimal = i;
>> +             }
>> +     }
>> +
>> +     for (i = 0; i < num; i++) {
>> +             if (qlen[optimal] > qlen[i])
>> +                     optimal = i;
>> +     }
>> +
>> +     return optimal;
>> +}
>> +
>>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>                           struct map_lookup *map, int first, int num,
>>                           int optimal, int dev_replace_is_ongoing)
>> @@ -5601,6 +5707,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>       int i;
>>       int ret = 0;
>>       int num_stripes;
>> +     int optimal;
>>       int max_errors = 0;
>>       int tgtdev_indexes = 0;
>>       struct btrfs_bio *bbio = NULL;
>> @@ -5713,9 +5820,11 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>               else if (mirror_num)
>>                       stripe_index = mirror_num - 1;
>>               else {
>> +                     optimal = guess_optimal(map, map->num_stripes,
>> +                                     current->pid % map->num_stripes);
>>                       stripe_index = find_live_mirror(fs_info, map, 0,
>>                                           map->num_stripes,
>> -                                         current->pid % map->num_stripes,
>> +                                         optimal,
>>                                           dev_replace_is_ongoing);
>>                       mirror_num = stripe_index + 1;
>>               }
>> @@ -5741,10 +5850,12 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>                       stripe_index += mirror_num - 1;
>>               else {
>>                       int old_stripe_index = stripe_index;
>> +                     optimal = guess_optimal(map, map->sub_stripes,
>> +                                     current->pid % map->sub_stripes);
>>                       stripe_index = find_live_mirror(fs_info, map,
>>                                             stripe_index,
>>                                             map->sub_stripes, stripe_index +
>> -                                           current->pid % map->sub_stripes,
>> +                                           optimal,
>>                                             dev_replace_is_ongoing);
>>                       mirror_num = stripe_index - old_stripe_index + 1;
>>               }
>> --
>> 2.15.1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Have a nice day,
Timofey.
