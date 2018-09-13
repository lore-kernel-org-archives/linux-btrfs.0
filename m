Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41611 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbeIMS56 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 14:57:58 -0400
Received: by mail-ot1-f65.google.com with SMTP id e18-v6so1266633oti.8
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 06:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <20180707152408.31485-1-timofey.titovets@synesis.ru>
In-Reply-To: <20180707152408.31485-1-timofey.titovets@synesis.ru>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 13 Sep 2018 16:47:48 +0300
Message-ID: <CAGqmi76tstwnTsZDadXdqdtiTMbL7=rqaTKpyfpQy_O-VEe3oA@mail.gmail.com>
Subject: Re: [PATCH V5] Btrfs: enchanse raid1/10 balance heuristic
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

сб, 7 июл. 2018 г. в 18:24, Timofey Titovets <nefelim4ag@gmail.com>:
>
> From: Timofey Titovets <nefelim4ag@gmail.com>
>
> Currently btrfs raid1/10 balancer bаlance requests to mirrors,
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
>   v2 -> v3:
>     - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
>   v3 -> v4:
>     - Rebased on latest misc-next
>   v4 -> v5:
>     - Rebased on latest misc-next
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  block/genhd.c      |   1 +
>  fs/btrfs/volumes.c | 111 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 110 insertions(+), 2 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 9656f9e9f99e..5ea5acc88d3c 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct hd_struct *part,
>                                 atomic_read(&part->in_flight[1]);
>         }
>  }
> +EXPORT_SYMBOL_GPL(part_in_flight);
>
>  void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
>                        unsigned int inflight[2])
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c95af358b71f..fa7dd6ac087f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -16,6 +16,7 @@
>  #include <linux/raid/pq.h>
>  #include <linux/semaphore.h>
>  #include <linux/uuid.h>
> +#include <linux/genhd.h>
>  #include <linux/list_sort.h>
>  #include "ctree.h"
>  #include "extent_map.h"
> @@ -5201,6 +5202,111 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>         return ret;
>  }
>
> +/**
> + * bdev_get_queue_len - return rounded down in flight queue lenght of bdev
> + *
> + * @bdev: target bdev
> + * @round_down: round factor big for hdd and small for ssd, like 8 and 2
> + */
> +static int bdev_get_queue_len(struct block_device *bdev, int round_down)
> +{
> +       int sum;
> +       struct hd_struct *bd_part = bdev->bd_part;
> +       struct request_queue *rq = bdev_get_queue(bdev);
> +       uint32_t inflight[2] = {0, 0};
> +
> +       part_in_flight(rq, bd_part, inflight);
> +
> +       sum = max_t(uint32_t, inflight[0], inflight[1]);
> +
> +       /*
> +        * Try prevent switch for every sneeze
> +        * By roundup output num by some value
> +        */
> +       return ALIGN_DOWN(sum, round_down);
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
> +static int guess_optimal(struct map_lookup *map, int num, int optimal)
> +{
> +       int i;
> +       int round_down = 8;
> +       int qlen[num];
> +       bool is_nonrot[num];
> +       bool all_bdev_nonrot = true;
> +       bool all_bdev_rotate = true;
> +       struct block_device *bdev;
> +
> +       if (num == 1)
> +               return optimal;
> +
> +       /* Check accessible bdevs */
> +       for (i = 0; i < num; i++) {
> +               /* Init for missing bdevs */
> +               is_nonrot[i] = false;
> +               qlen[i] = INT_MAX;
> +               bdev = map->stripes[i].dev->bdev;
> +               if (bdev) {
> +                       qlen[i] = 0;
> +                       is_nonrot[i] = blk_queue_nonrot(bdev_get_queue(bdev));
> +                       if (is_nonrot[i])
> +                               all_bdev_rotate = false;
> +                       else
> +                               all_bdev_nonrot = false;
> +               }
> +       }
> +
> +       /*
> +        * Don't bother with computation
> +        * if only one of two bdevs are accessible
> +        */
> +       if (num == 2 && qlen[0] != qlen[1]) {
> +               if (qlen[0] < qlen[1])
> +                       return 0;
> +               else
> +                       return 1;
> +       }
> +
> +       if (all_bdev_nonrot)
> +               round_down = 2;
> +
> +       for (i = 0; i < num; i++) {
> +               if (qlen[i])
> +                       continue;
> +               bdev = map->stripes[i].dev->bdev;
> +               qlen[i] = bdev_get_queue_len(bdev, round_down);
> +       }
> +
> +       /* For mixed case, pick non rotational dev as optimal */
> +       if (all_bdev_rotate == all_bdev_nonrot) {
> +               for (i = 0; i < num; i++) {
> +                       if (is_nonrot[i])
> +                               optimal = i;
> +               }
> +       }
> +
> +       for (i = 0; i < num; i++) {
> +               if (qlen[optimal] > qlen[i])
> +                       optimal = i;
> +       }
> +
> +       return optimal;
> +}
> +
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>                             struct map_lookup *map, int first,
>                             int dev_replace_is_ongoing)
> @@ -5219,7 +5325,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>         else
>                 num_stripes = map->num_stripes;
>
> -       preferred_mirror = first + current->pid % num_stripes;
> +       preferred_mirror = first + guess_optimal(map, num_stripes,
> +                                                current->pid % num_stripes);
>
>         if (dev_replace_is_ongoing &&
>             fs_info->dev_replace.cont_reading_from_srcdev_mode ==
> --
> 2.17.0

Gentle ping?

-- 
Have a nice day,
Timofey.
