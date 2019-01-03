Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C132EC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 09:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C647206BB
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 09:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xqoxZN37"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbfACJbj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 04:31:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfACJbi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 04:31:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x039T4eE033120;
        Thu, 3 Jan 2019 09:31:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hZ4aiklL6nIURRmnnVJhm6qrIz8Ou7g6pJoR2tngXk4=;
 b=xqoxZN37ZhdH+BiVwWkp+D8YZrmy4T6QjM9dnqe3tRfRtM1mOYp7tNhxC+ZHQ/rNbTqt
 p4j5KSxqyb4Xux7HwDAMWgzXRgBudukR7jSRh33Xy+1CYQD9L7M0jh1H/8ohfhyHYofI
 2YgMxClwM5TetY8SXBY/bTr9Cr9pWV/sqLfu832mpXlDtfw/tCqvYvsgZmO2MtGvEap0
 uY4SRv7PQfT35X2gcDVFSCdfc+DcQO/ESMpA6TVAwRlOqwwJ8vBCGskIhCo/oHdHhoZF
 iYj3a0d+qapvj2mNmv5Zil1CvO546KTkx7Gz1EVH/4YKv5ub70tdc9I9h6rYulnLQyNe Pw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btx310-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jan 2019 09:31:30 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x039VUg8003832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Jan 2019 09:31:30 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x039VTcZ015690;
        Thu, 3 Jan 2019 09:31:29 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 01:31:29 -0800
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH V7] Btrfs: enhance raid1/10 balance heuristic
To:     Timofey Titovets <timofey.titovets@synesis.ru>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
References: <20181112115839.13969-1-timofey.titovets@synesis.ru>
 <a1854e9d-b3f3-f751-0364-118dc98da057@oracle.com>
 <CAGqmi765-YAPVrYjFrgV9ZVBSbtKdy42fM-6R=7Jrvvm1N+qVA@mail.gmail.com>
Message-ID: <e8da3b96-b147-21a5-4a7d-2dab6904e6a9@oracle.com>
Date:   Thu, 3 Jan 2019 17:31:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAGqmi765-YAPVrYjFrgV9ZVBSbtKdy42fM-6R=7Jrvvm1N+qVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9124 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901030084
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/02/2019 02:39 AM, Timofey Titovets wrote:
> Oh, just forgot to answer.
> 
> ср, 14 нояб. 2018 г. в 04:27, Anand Jain <anand.jain@oracle.com>:
>>
>> I am ok with the least used path approach here for the IO routing
>> that's probably most reasonable in generic configurations. It can
>> be default read mirror policy as well.
> (thanks, that's pleasant for me %) )
> 
>> But as I mentioned. Not all configurations would agree to the heuristic
>> approach here. For example: To make use of the SAN storage cache to
>> get high IO throughput read must access based on the LBA, And this
>> heuristic would make matter worst. There are plans to add more
>> options read_mirror_policy [1].
>>
>> [1]
>> https://patchwork.kernel.org/patch/10403299/
> 
> Can you please add some example of SAN stack were that
> will make something 'worst'?

As we are discussing about the read mirror policy, consider only read 
IO. Now, if you access a LBA on a disk, that LBA gets cached on the 
storage target controller and on the disk cache, now if the host is 
trying to access the same LBA (which is been mirrored) on another disk, 
the mirror data also gets cached, wasting the cache space, instead the 
cache on the disk/target could have been used to cache new data by 
routing the read based on logical LBA so that disk/storage-target cache 
compliment each other. more below..

> Moreover pid lb will also not play good for your example.

I don't like PID based as it is less deterministic on where the read IO 
is going so its hard to debug (read_mirror_policy patch in the ML will 
fix that). In this context (that is disk/storage cache optimization) the 
current PID based is better as the read IO will consistently go to a 
disk for the life span of the application. Which means the 
disk/storage-target cache is guaranteed to have not wasted as long as 
the application PID remains same, albeit the queue load is not been 
taken care in the PID approach. Where as the proposed 
least-used-path-approach here, its only optimization is about the buffer 
queue on the HBA and the target and falls short on the target/disk cache 
optimization.

> In SAN stack client always see one device with N path.
> And no raid1 balancing can happen.
> Maybe i didn't see all setups in world, but configure raid1
> from 2 remote devices sounds very bad for me.
> Even drbd
> only provide one logical device to end user.

BTRFS is yet to support N path to a LUN/disk moreover N paths doesn't 
represent a data mirror, its just N paths to a copy of the data. and 
discussion here is not about the multi-path. Its about data mirror usage 
policy for the read IO.

>> I would rather provide the configuration tune-ables to the use
>> cases rather than fixing it using heuristic. Heuristic are good
>> only with the known set of IO pattern for which heuristic is
>> designed for.
> 
> Yep, but how compex that tunables must be?
> i.e. we'll _always_ have cerner cases with bad behaviour.

mount -o read_mirror_policy=least_used or
mount -o read_mirror_policy=by_q_depth

> (Also i prefer have sysfs tunables for that, instead of adding another
> mount option.)

There is a lot of work pending w.r.t disk/volume and sysfs. I won't 
corrupt it without a broader discussion of major requisites from the "S" 
part of the RAS features. We still don't have "S" part completely 
addressed. I wrote about it a long time back, I wish there is more 
common interest in commenting on it.

We should discuss - btrfs sysfs is less matured as compared to mount 
options, comments on the read_mirror_policy patch will be better, I am 
ok if it has to be sysfs.

>> This is not the first time you are assuming heuristic would provide
>> the best possible performance in all use cases. As I mentioned
>> in the compression heuristic there was no problem statement that
>> you wanted to address using heuristic, theoretically the integrated
>> compression heuristic would have to do a lot more computation when
>> all the file-extents are compressible, its not convenience to me
>> how compression heuristic would help on a desktop machine where
>> most of the files are compressible.
> 
> Different tools exists, because we have different use cases.
> If something adds more problems than it solves, it must be changed or
> just purged.
> 
> Moreover, claim what on every desktop machine most of files are compressible
> not true. I don't want to make long discussion about "spherical cow" in space.
> Just my example:
> ➜  ~ sudo compsize /mnt
> Processed 1198830 files, 1404382 regular extents (1481132 refs), 675870 inline.
> Type       Perc     Disk Usage   Uncompressed Referenced
> TOTAL       77%      240G         308G         285G
> none       100%      202G         202G         176G
> zlib        37%      1.8G         5.1G         5.6G
> lzo         61%       64M         104M         126M
> zstd        35%       36G         100G         103G

This does not address the question above. That is - When all the 
files/extents were compressible by a compression-engine, heuristic 
needlessly makes it more CPU intensive than without heuristic, and 
without achieving any benefit. And more over the original problem of -o 
compress being easily giving-up forever and -o force-compress being 
never gives up is still not addressed. Which heuristic could have.

Thanks, Anand

> That's are system + home.
> Home have different type of trash in it: videos, photos, source repos,
> steam games, docker images.
> DE Apps DB and other random things. Some data have NOCOW because i
> just lack of "mental strength"
> to finish fix of bad behaviour autodefrag with compressed data.
> As you can see most volume of data are not compressed.
> 
>> IMO heuristic are good only for a set of types of workload. Giving
>> an option to move away from it for the manual tuning is desired.
>>
>> Thanks, Anand
> 
> Any way, may be you right about demand in adding some control about
> internal behaviour.
> And we can combine our work to properly support that.
> (I don't like over engineering, and just try avoid way where users will start to
> switch random flags to make things better.)
> But before that we need some feedback from upstream. Bad or good.
> 
> Because currently core btrfs devs works on companies, which internal
> use btrfs and/or
> sell that to customers (suse?). I'm afraid what devs afraid to change internal
> behaviour without 100% confident that it will be better.
> 
> Thanks!
> 
>> On 11/12/2018 07:58 PM, Timofey Titovets wrote:
>>> From: Timofey Titovets <nefelim4ag@gmail.com>
>>>
>>> Currently btrfs raid1/10 balancer bаlance requests to mirrors,
>>> based on pid % num of mirrors.
>>>
>>> Make logic understood:
>>>    - if one of underline devices are non rotational
>>>    - Queue length to underline devices
>>>
>>> By default try use pid % num_mirrors guessing, but:
>>>    - If one of mirrors are non rotational, repick optimal to it
>>>    - If underline mirror have less queue length then optimal,
>>>      repick to that mirror
>>>
>>> For avoid round-robin request balancing,
>>> lets round down queue length:
>>>    - By 8 for rotational devs
>>>    - By 2 for all non rotational devs
>>>
>>> Some bench results from mail list
>>> (Dmitrii Tcvetkov <demfloro@demfloro.ru>):
>>> Benchmark summary (arithmetic mean of 3 runs):
>>>            Mainline     Patch
>>> ------------------------------------
>>> RAID1  | 18.9 MiB/s | 26.5 MiB/s
>>> RAID10 | 30.7 MiB/s | 30.7 MiB/s
>>> ------------------------------------------------------------------------
>>> mainline, fio got lucky to read from first HDD (quite slow HDD):
>>> Jobs: 1 (f=1): [r(1)][100.0%][r=8456KiB/s,w=0KiB/s][r=264,w=0 IOPS]
>>>     read: IOPS=265, BW=8508KiB/s (8712kB/s)(499MiB/60070msec)
>>>     lat (msec): min=2, max=825, avg=60.17, stdev=65.06
>>> ------------------------------------------------------------------------
>>> mainline, fio got lucky to read from second HDD (much more modern):
>>> Jobs: 1 (f=1): [r(1)][8.7%][r=11.9MiB/s,w=0KiB/s][r=380,w=0 IOPS]
>>>     read: IOPS=378, BW=11.8MiB/s (12.4MB/s)(710MiB/60051msec)
>>>     lat (usec): min=416, max=644286, avg=42312.74, stdev=48518.56
>>> ------------------------------------------------------------------------
>>> mainline, fio got lucky to read from an SSD:
>>> Jobs: 1 (f=1): [r(1)][100.0%][r=436MiB/s,w=0KiB/s][r=13.9k,w=0 IOPS]
>>>     read: IOPS=13.9k, BW=433MiB/s (454MB/s)(25.4GiB/60002msec)
>>>     lat (usec): min=343, max=16319, avg=1152.52, stdev=245.36
>>> ------------------------------------------------------------------------
>>> With the patch, 2 HDDs:
>>> Jobs: 1 (f=1): [r(1)][100.0%][r=17.5MiB/s,w=0KiB/s][r=560,w=0 IOPS]
>>>     read: IOPS=560, BW=17.5MiB/s (18.4MB/s)(1053MiB/60052msec)
>>>     lat (usec): min=435, max=341037, avg=28511.64, stdev=30000.14
>>> ------------------------------------------------------------------------
>>> With the patch, HDD(old one)+SSD:
>>> Jobs: 1 (f=1): [r(1)][100.0%][r=371MiB/s,w=0KiB/s][r=11.9k,w=0 IOPS]
>>>     read: IOPS=11.6k, BW=361MiB/s (379MB/s)(21.2GiB/60084msec)
>>>     lat  (usec): min=363, max=346752, avg=1381.73, stdev=6948.32
>>>
>>> Changes:
>>>     v1 -> v2:
>>>       - Use helper part_in_flight() from genhd.c
>>>         to get queue length
>>>       - Move guess code to guess_optimal()
>>>       - Change balancer logic, try use pid % mirror by default
>>>         Make balancing on spinning rust if one of underline devices
>>>         are overloaded
>>>     v2 -> v3:
>>>       - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
>>>     v3 -> v4:
>>>       - Rebased on latest misc-next
>>>     v4 -> v5:
>>>       - Rebased on latest misc-next
>>>     v5 -> v6:
>>>       - Fix spelling
>>>       - Include bench results
>>>     v6 -> v7:
>>>       - Fixes based on Nikolay Borisov review:
>>>         * Assume num == 2
>>>         * Remove "for" loop based on that assumption, where possible
>>>         * No functional changes
>>>
>>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>>> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
>>> Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
>>> ---
>>>    block/genhd.c      |   1 +
>>>    fs/btrfs/volumes.c | 100 ++++++++++++++++++++++++++++++++++++++++++++-
>>>    2 files changed, 100 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/block/genhd.c b/block/genhd.c
>>> index be5bab20b2ab..939f0c6a2d79 100644
>>> --- a/block/genhd.c
>>> +++ b/block/genhd.c
>>> @@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct hd_struct *part,
>>>                                atomic_read(&part->in_flight[1]);
>>>        }
>>>    }
>>> +EXPORT_SYMBOL_GPL(part_in_flight);
>>>
>>>    void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
>>>                       unsigned int inflight[2])
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index f4405e430da6..a6632cc2bfab 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -13,6 +13,7 @@
>>>    #include <linux/raid/pq.h>
>>>    #include <linux/semaphore.h>
>>>    #include <linux/uuid.h>
>>> +#include <linux/genhd.h>
>>>    #include <linux/list_sort.h>
>>>    #include "ctree.h"
>>>    #include "extent_map.h"
>>> @@ -5159,6 +5160,102 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>>>        return ret;
>>>    }
>>>
>>> +/**
>>> + * bdev_get_queue_len - return rounded down in flight queue length of bdev
>>> + *
>>> + * @bdev: target bdev
>>> + * @round_down: round factor big for hdd and small for ssd, like 8 and 2
>>> + */
>>> +static int bdev_get_queue_len(struct block_device *bdev, int round_down)
>>> +{
>>> +     int sum;
>>> +     struct hd_struct *bd_part = bdev->bd_part;
>>> +     struct request_queue *rq = bdev_get_queue(bdev);
>>> +     uint32_t inflight[2] = {0, 0};
>>> +
>>> +     part_in_flight(rq, bd_part, inflight);
>>> +
>>> +     sum = max_t(uint32_t, inflight[0], inflight[1]);
>>> +
>>> +     /*
>>> +      * Try prevent switch for every sneeze
>>> +      * By roundup output num by some value
>>> +      */
>>> +     return ALIGN_DOWN(sum, round_down);
>>> +}
>>> +
>>> +/**
>>> + * guess_optimal - return guessed optimal mirror
>>> + *
>>> + * Optimal expected to be pid % num_stripes
>>> + *
>>> + * That's generaly ok for spread load
>>> + * Add some balancer based on queue length to device
>>> + *
>>> + * Basic ideas:
>>> + *  - Sequential read generate low amount of request
>>> + *    so if load of drives are equal, use pid % num_stripes balancing
>>> + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
>>> + *    and repick if other dev have "significant" less queue length
>>> + *  - Repick optimal if queue length of other mirror are less
>>> + */
>>> +static int guess_optimal(struct map_lookup *map, int num, int optimal)
>>> +{
>>> +     int i;
>>> +     int round_down = 8;
>>> +     /* Init for missing bdevs */
>>> +     int qlen[2] = { INT_MAX, INT_MAX };
>>> +     bool is_nonrot[2] = { false, false };
>>> +     bool all_bdev_nonrot = true;
>>> +     bool all_bdev_rotate = true;
>>> +     struct block_device *bdev;
>>> +
>>> +     ASSERT(num == 2);
>>> +
>>> +     /* Check accessible bdevs */
>>> +     for (i = 0; i < 2; i++) {
>>> +             bdev = map->stripes[i].dev->bdev;
>>> +             if (bdev) {
>>> +                     qlen[i] = 0;
>>> +                     is_nonrot[i] = blk_queue_nonrot(bdev_get_queue(bdev));
>>> +                     if (is_nonrot[i])
>>> +                             all_bdev_rotate = false;
>>> +                     else
>>> +                             all_bdev_nonrot = false;
>>> +             }
>>> +     }
>>> +
>>> +     /*
>>> +      * Don't bother with computation
>>> +      * if only one of two bdevs are accessible
>>> +      */
>>> +     if (qlen[0] == INT_MAX)
>>> +             return 1;
>>> +     if (qlen[1] == INT_MAX)
>>> +             return 0;
>>> +
>>> +     if (all_bdev_nonrot)
>>> +             round_down = 2;
>>> +
>>> +     for (i = 0; i < 2; i++) {
>>> +             bdev = map->stripes[i].dev->bdev;
>>> +             qlen[i] = bdev_get_queue_len(bdev, round_down);
>>> +     }
>>> +
>>> +     /* For mixed case, pick non rotational dev as optimal */
>>> +     if (all_bdev_rotate == all_bdev_nonrot) {
>>> +             if (is_nonrot[0])
>>> +                     optimal = 0;
>>> +             else
>>> +                     optimal = 1;
>>> +     }
>>> +
>>> +     if (qlen[optimal] > qlen[(optimal + 1) % 2])
>>> +             optimal = i;
>>> +
>>> +     return optimal;
>>> +}
>>> +
>>>    static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>>                            struct map_lookup *map, int first,
>>>                            int dev_replace_is_ongoing)
>>> @@ -5177,7 +5274,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>>        else
>>>                num_stripes = map->num_stripes;
>>>
>>> -     preferred_mirror = first + current->pid % num_stripes;
>>> +     preferred_mirror = first + guess_optimal(map, num_stripes,
>>> +                                              current->pid % num_stripes);
>>>
>>>        if (dev_replace_is_ongoing &&
>>>            fs_info->dev_replace.cont_reading_from_srcdev_mode ==
>>>
