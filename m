Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:41413 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753293AbdL1NqZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 08:46:25 -0500
Reply-To: waxhead@dirtcellar.net
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <7bce5b3a-893b-363d-91d9-7e4fafc0bf83@dirtcellar.net>
Date: Thu, 28 Dec 2017 14:46:22 +0100
MIME-Version: 1.0
In-Reply-To: <20171227223931.7878-1-nefelim4ag@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Timofey Titovets wrote:
> Currently btrfs raid1/10 balancer blance requests to mirrors,
> based on pid % num of mirrors.
>
> Update logic and make it understood if underline device are non rotational.
>
> If one of mirrors are non rotational, then all read requests will be moved to
> non rotational device.
>
And this would make reads regardless of the PID always end up on the 
fastest device which sounds sane enough , but scubbing will be even more 
important since there is a less chance that a "random PID" will check 
the other copy every now and then.

> If both of mirrors are non rotational, calculate sum of
> pending and in flight request for queue on that bdev and use
> device with least queue leght.
>
I think this would be tried out on rotational disk as well. I am happy 
to test this out for you on a 7x disk server if you want.
Note: I have no experience with compiling kernels and applying patches 
(but I do code a bit in C every now and then) so a pre-compiled kernel 
would be required (I believe you are on Debain as well)
For rotational then perhaps it would not be wise to use another mirror 
unless the queue length is significantly higher than the other. Again I 
am happy to test if tunables are provided.

> P.S.
> Inspired by md-raid1 read balancing
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/volumes.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9a04245003ab..98bc2433a920 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5216,13 +5216,30 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  	return ret;
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
> @@ -5231,6 +5248,48 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	else
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
> +		/* Forse following logic choise by init with some big number */
> +		int optimal_dev_rq_count = 1 << 24;
> +
> +		for (i = 0; i < num; i++) {
> +			bdev = map->stripes[i].dev->bdev;
> +			if (!bdev)
> +				continue;
> +
> +			qlen = bdev_get_queue_len(bdev);
> +
> +			if (qlen < optimal_dev_rq_count) {
> +				optimal = i;
> +				optimal_dev_rq_count = qlen;
> +			}
> +		}
> +	}
> +
>  	/*
>  	 * try to avoid the drive that is the source drive for a
>  	 * dev-replace procedure, only choose it if no other non-missing
>
