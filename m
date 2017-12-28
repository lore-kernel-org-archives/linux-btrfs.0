Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:39504 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbdL1WmW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 17:42:22 -0500
Received: by mail-it0-f66.google.com with SMTP id 68so30044759ite.4
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Dec 2017 14:42:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171228110514.702aaaef@job>
References: <20171227223931.7878-1-nefelim4ag@gmail.com> <20171228110514.702aaaef@job>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 29 Dec 2017 01:41:40 +0300
Message-ID: <CAGqmi74L=tWdqy7kW+hyTUPRiiB_MJXyzS2HeRYt-8VprokXWg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-12-28 11:06 GMT+03:00 Dmitrii Tcvetkov <demfloro@demfloro.ru>:
> On Thu, 28 Dec 2017 01:39:31 +0300
> Timofey Titovets <nefelim4ag@gmail.com> wrote:
>
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
>>  fs/btrfs/volumes.c | 59
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++ 1 file changed, 59
>> insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 9a04245003ab..98bc2433a920 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5216,13 +5216,30 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info
>> *fs_info, u64 logical, u64 len) return ret;
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
>
> This won't work as expected if bdev is controlled by blk-mq, these
> counters will be zero. AFAIK to get this info in block layer agnostic way
> part_in_flight[1] has to be used. It extracts these counters approriately.
>
> But it needs to be EXPORT_SYMBOL()'ed in block/genhd.c so we can continue
> to build btrfs as module.
>
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
>> @@ -5231,6 +5248,48 @@ static int find_live_mirror(struct btrfs_fs_info
>> *fs_info, else
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
>> +      */
>> +     for (i = 0; i < num; i++) {
>> +             bdev = map->stripes[i].dev->bdev;
>> +             if (!bdev)
>> +                     continue;
>> +             if (blk_queue_nonrot(bdev_get_queue(bdev)))
>> +                     optimal = i;
>> +             else
>> +                     all_bdev_nonrot = false;
>> +     }
>> +
>> +     if (all_bdev_nonrot) {
>> +             int qlen;
>> +             /* Forse following logic choise by init with some big number
>> */
>> +             int optimal_dev_rq_count = 1 << 24;
>
> Probably better to use INT_MAX macro instead.
>
> [1] https://elixir.free-electrons.com/linux/v4.15-rc5/source/block/genhd.c#L68
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank you very much!

-- 
Have a nice day,
Timofey.
