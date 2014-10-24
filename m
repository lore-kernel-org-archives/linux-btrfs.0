Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34628 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaJXLGf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 07:06:35 -0400
Date: Fri, 24 Oct 2014 19:06:25 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Enhance btrfs chunk allocation algorithm to
 reduce ENOSPC caused by unbalanced data/metadata allocation.
Message-ID: <20141024110624.GB32526@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1414031871-10859-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414031871-10859-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 23, 2014 at 10:37:51AM +0800, Qu Wenruo wrote:
> When btrfs allocate a chunk, it will try to alloc up to 1G for data and
> 256M for metadata, or 10% of all the writeable space if there is enough

10G for data,
        if (type & BTRFS_BLOCK_GROUP_DATA) {
                max_stripe_size = 1024 * 1024 * 1024;
                max_chunk_size = 10 * max_stripe_size;
		...

thanks,
-liubo

> space for the stripe on device.
> 
> However, when we run out of space, this allocation may cause unbalanced
> chunk allocation.
> For example, there are only 1G unallocated space, and request for
> allocate DATA chunk is sent, and all the space will be allocated as data
> chunk, making later metadata chunk alloc request unable to handle, which
> will cause ENOSPC.
> This is the one of the common complains from end users about why ENOSPC
> happens but there is still available space.
> 
> This patch will try not to alloc chunk which is more than half of the
> unallocated space, making the last space more balanced at a small cost
> of more fragmented chunk at the last 1G.
> 
> Some easy example:
> Preallocate 17.5G on a 20G empty btrfs fs:
> [Before]
>  # btrfs fi show /mnt/test
> Label: none  uuid: da8741b1-5d47-4245-9e94-bfccea34e91e
> 	Total devices 1 FS bytes used 17.50GiB
> 	devid    1 size 20.00GiB used 20.00GiB path /dev/sdb
> All space is allocated. No space later metadata space.
> 
> [After]
>  # btrfs fi show /mnt/test
> Label: none  uuid: e6935aeb-a232-4140-84f9-80aab1f23d56
> 	Total devices 1 FS bytes used 17.50GiB
> 	devid    1 size 20.00GiB used 19.77GiB path /dev/sdb
> About 230M is still available for later metadata allocation.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d47289c..fa8de79 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4240,6 +4240,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	int ret;
>  	u64 max_stripe_size;
>  	u64 max_chunk_size;
> +	u64 total_avail_space = 0;
>  	u64 stripe_size;
>  	u64 num_bytes;
>  	u64 raid_stripe_len = BTRFS_STRIPE_LEN;
> @@ -4352,10 +4353,27 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  		devices_info[ndevs].max_avail = max_avail;
>  		devices_info[ndevs].total_avail = total_avail;
>  		devices_info[ndevs].dev = device;
> +		total_avail_space += total_avail;
>  		++ndevs;
>  	}
>  
>  	/*
> +	 * Try not to occupy more than half of the unallocated space.
> +	 * When run short of space and alloc all the space to
> +	 * data/metadata will cause ENOSPC to be triggered more easily.
> +	 *
> +	 * And since the minimum chunk size is 16M, the half-half will cause
> +	 * 16M allocated from 20M available space and reset 4M will not be
> +	 * used ever. In that case(16~32M), allocate all directly.
> +	 */
> +	if (total_avail_space < 32 * 1024 * 1024 &&
> +	    total_avail_space > 16 * 1024 * 1024)
> +		max_chunk_size = total_avail_space;
> +	else
> +		max_chunk_size = min(total_avail_space / 2, max_chunk_size);
> +	max_chunk_size = min(total_avail_space / 2, max_chunk_size);
> +
> +	/*
>  	 * now sort the devices by hole size / available space
>  	 */
>  	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
