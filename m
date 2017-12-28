Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:56284 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbdL1IGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 03:06:30 -0500
Date: Thu, 28 Dec 2017 11:06:06 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating  devices
Message-ID: <20171228110514.702aaaef@job>
In-Reply-To: <20171227223931.7878-1-nefelim4ag@gmail.com>
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 28 Dec 2017 01:39:31 +0300
Timofey Titovets <nefelim4ag@gmail.com> wrote:

> Currently btrfs raid1/10 balancer blance requests to mirrors,
> based on pid % num of mirrors.
> 
> Update logic and make it understood if underline device are non rotational.
> 
> If one of mirrors are non rotational, then all read requests will be moved to
> non rotational device.
> 
> If both of mirrors are non rotational, calculate sum of
> pending and in flight request for queue on that bdev and use
> device with least queue leght.
> 
> P.S.
> Inspired by md-raid1 read balancing
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/volumes.c | 59
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++ 1 file changed, 59
> insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9a04245003ab..98bc2433a920 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5216,13 +5216,30 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info
> *fs_info, u64 logical, u64 len) return ret;
>  }
>  
> +static inline int bdev_get_queue_len(struct block_device *bdev)
> +{
> +	int sum = 0;
> +	struct request_queue *rq = bdev_get_queue(bdev);
> +
> +	sum += rq->nr_rqs[BLK_RW_SYNC] + rq->nr_rqs[BLK_RW_ASYNC];
> +	sum += rq->in_flight[BLK_RW_SYNC] + rq->in_flight[BLK_RW_ASYNC];
> +

This won't work as expected if bdev is controlled by blk-mq, these
counters will be zero. AFAIK to get this info in block layer agnostic way
part_in_flight[1] has to be used. It extracts these counters approriately.

But it needs to be EXPORT_SYMBOL()'ed in block/genhd.c so we can continue
to build btrfs as module.

> +	/*
> +	 * Try prevent switch for every sneeze
> +	 * By roundup output num by 2
> +	 */
> +	return ALIGN(sum, 2);
> +}
> +
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  			    struct map_lookup *map, int first, int num,
>  			    int optimal, int dev_replace_is_ongoing)
>  {
>  	int i;
>  	int tolerance;
> +	struct block_device *bdev;
>  	struct btrfs_device *srcdev;
> +	bool all_bdev_nonrot = true;
>  
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
> @@ -5231,6 +5248,48 @@ static int find_live_mirror(struct btrfs_fs_info
> *fs_info, else
>  		srcdev = NULL;
>  
> +	/*
> +	 * Optimal expected to be pid % num
> +	 * That's generaly ok for spinning rust drives
> +	 * But if one of mirror are non rotating,
> +	 * that bdev can show better performance
> +	 *
> +	 * if one of disks are non rotating:
> +	 *  - set optimal to non rotating device
> +	 * if both disk are non rotating
> +	 *  - set optimal to bdev with least queue
> +	 * If both disks are spinning rust:
> +	 *  - leave old pid % nu,
> +	 */
> +	for (i = 0; i < num; i++) {
> +		bdev = map->stripes[i].dev->bdev;
> +		if (!bdev)
> +			continue;
> +		if (blk_queue_nonrot(bdev_get_queue(bdev)))
> +			optimal = i;
> +		else
> +			all_bdev_nonrot = false;
> +	}
> +
> +	if (all_bdev_nonrot) {
> +		int qlen;
> +		/* Forse following logic choise by init with some big number
> */
> +		int optimal_dev_rq_count = 1 << 24;

Probably better to use INT_MAX macro instead.

[1] https://elixir.free-electrons.com/linux/v4.15-rc5/source/block/genhd.c#L68

