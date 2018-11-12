Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA66EC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 07:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97BC221722
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 07:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97BC221722
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbeKLRUL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:20:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:38456 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbeKLRUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 12:20:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C3103AFD0;
        Mon, 12 Nov 2018 07:28:09 +0000 (UTC)
Subject: Re: [PATCH V6] Btrfs: enhance raid1/10 balance heuristic
To:     Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20180925183841.26936-1-nefelim4ag@gmail.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e88813e9-55a5-09ab-d148-8235c33ee993@suse.com>
Date:   Mon, 12 Nov 2018 09:28:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20180925183841.26936-1-nefelim4ag@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 25.09.18 г. 21:38 ч., Timofey Titovets wrote:
> Currently btrfs raid1/10 balancer bаlance requests to mirrors,
> based on pid % num of mirrors.
> 
> Make logic understood:
>  - if one of underline devices are non rotational
>  - Queue length to underline devices
> 
> By default try use pid % num_mirrors guessing, but:
>  - If one of mirrors are non rotational, repick optimal to it
>  - If underline mirror have less queue length then optimal,
>    repick to that mirror
> 
> For avoid round-robin request balancing,
> lets round down queue length:
>  - By 8 for rotational devs
>  - By 2 for all non rotational devs
> 
> Some bench results from mail list
> (Dmitrii Tcvetkov <demfloro@demfloro.ru>):
> Benchmark summary (arithmetic mean of 3 runs):
>          Mainline     Patch
> ------------------------------------
> RAID1  | 18.9 MiB/s | 26.5 MiB/s
> RAID10 | 30.7 MiB/s | 30.7 MiB/s
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from first HDD (quite slow HDD):
> Jobs: 1 (f=1): [r(1)][100.0%][r=8456KiB/s,w=0KiB/s][r=264,w=0 IOPS]
>   read: IOPS=265, BW=8508KiB/s (8712kB/s)(499MiB/60070msec)
>   lat (msec): min=2, max=825, avg=60.17, stdev=65.06
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from second HDD (much more modern):
> Jobs: 1 (f=1): [r(1)][8.7%][r=11.9MiB/s,w=0KiB/s][r=380,w=0 IOPS]
>   read: IOPS=378, BW=11.8MiB/s (12.4MB/s)(710MiB/60051msec)
>   lat (usec): min=416, max=644286, avg=42312.74, stdev=48518.56
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from an SSD:
> Jobs: 1 (f=1): [r(1)][100.0%][r=436MiB/s,w=0KiB/s][r=13.9k,w=0 IOPS]
>   read: IOPS=13.9k, BW=433MiB/s (454MB/s)(25.4GiB/60002msec) 
>   lat (usec): min=343, max=16319, avg=1152.52, stdev=245.36
> ------------------------------------------------------------------------
> With the patch, 2 HDDs:
> Jobs: 1 (f=1): [r(1)][100.0%][r=17.5MiB/s,w=0KiB/s][r=560,w=0 IOPS]
>   read: IOPS=560, BW=17.5MiB/s (18.4MB/s)(1053MiB/60052msec)
>   lat (usec): min=435, max=341037, avg=28511.64, stdev=30000.14
> ------------------------------------------------------------------------
> With the patch, HDD(old one)+SSD:
> Jobs: 1 (f=1): [r(1)][100.0%][r=371MiB/s,w=0KiB/s][r=11.9k,w=0 IOPS]
>   read: IOPS=11.6k, BW=361MiB/s (379MB/s)(21.2GiB/60084msec)
>   lat  (usec): min=363, max=346752, avg=1381.73, stdev=6948.32
> 
> Changes:
>   v1 -> v2:
>     - Use helper part_in_flight() from genhd.c
>       to get queue length
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
>   v5 -> v6:
>     - Fix spelling
>     - Include bench results
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
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
>  				atomic_read(&part->in_flight[1]);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(part_in_flight);
>  
>  void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
>  		       unsigned int inflight[2])
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
>  	return ret;
>  }
>  
> +/**
> + * bdev_get_queue_len - return rounded down in flight queue length of bdev
> + *
> + * @bdev: target bdev
> + * @round_down: round factor big for hdd and small for ssd, like 8 and 2
> + */
> +static int bdev_get_queue_len(struct block_device *bdev, int round_down)
> +{
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
> + * Add some balancer based on queue length to device
> + *
> + * Basic ideas:
> + *  - Sequential read generate low amount of request
> + *    so if load of drives are equal, use pid % num_stripes balancing
> + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
> + *    and repick if other dev have "significant" less queue length
> + *  - Repick optimal if queue length of other mirror are less
> + */
> +static int guess_optimal(struct map_lookup *map, int num, int optimal)
> +{
> +	int i;
> +	int round_down = 8;
> +	int qlen[num];
> +	bool is_nonrot[num];
> +	bool all_bdev_nonrot = true;
> +	bool all_bdev_rotate = true;
> +	struct block_device *bdev;
> +
> +	if (num == 1)
> +		return optimal;

Can this check ever trigger, given that find_live_mirror is called only
from raid1/raid10 code paths in __btrfs_map_block. Even if one of the
devices is missing (which for raid10 should be catastrophic) there is a
check whether the devices are missing and so nothing is submitted.

> +
> +	/* Check accessible bdevs */
> +	for (i = 0; i < num; i++) {
> +		/* Init for missing bdevs */
> +		is_nonrot[i] = false;
> +		qlen[i] = INT_MAX;
> +		bdev = map->stripes[i].dev->bdev;
> +		if (bdev) {
> +			qlen[i] = 0;
> +			is_nonrot[i] = blk_queue_nonrot(bdev_get_queue(bdev));
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

Based on my assumptions on the previous usage of num I don't think num
can be different than 2 (even with missing devices). So I believe this
check is redundant.  I'd rather put an ASSERT(num == 2) at the top of
this function.

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
> +		}
> +	}
> +
> +	for (i = 0; i < num; i++) {
> +		if (qlen[optimal] > qlen[i])
> +			optimal = i;
> +	}


If my assumption that num is always 2 then all of these 'for' loops can
be replaced with simple 'if (qlen[0] > qlen[1]) foo'

> +
> +	return optimal;
> +}
> +
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  			    struct map_lookup *map, int first,
>  			    int dev_replace_is_ongoing)
> @@ -5219,7 +5325,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	else
>  		num_stripes = map->num_stripes;
>  
> -	preferred_mirror = first + current->pid % num_stripes;
> +	preferred_mirror = first + guess_optimal(map, num_stripes,
> +						 current->pid % num_stripes);
>  
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
> 
