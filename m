Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28286 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750872AbdBTGoY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 01:44:24 -0500
Subject: Re: [PATCH 6/7] Btrfs: helper for ops that requires full stripe
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
 <1487381301-865-7-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2d03ebed-42d4-0fb3-e23b-3f3809e9753d@cn.fujitsu.com>
Date: Mon, 20 Feb 2017 14:40:58 +0800
MIME-Version: 1.0
In-Reply-To: <1487381301-865-7-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/18/2017 09:28 AM, Liu Bo wrote:
> This adds a helper to show directly whether ops require full stripe.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Looks good to me.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
>  fs/btrfs/volumes.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bcd44eb..4a334a9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5640,6 +5640,11 @@ static void handle_ops_on_dev_replace(enum btrfs_map_op op,
>  	*bbio_ret = bbio;
>  }
>
> +static bool need_full_stripe(enum btrfs_map_op op)
> +{
> +	return (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS);
> +}
> +
>  static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  			     enum btrfs_map_op op,
>  			     u64 logical, u64 *length,
> @@ -5742,8 +5747,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		btrfs_dev_replace_set_lock_blocking(dev_replace);
>
>  	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
> -	    op != BTRFS_MAP_WRITE && op != BTRFS_MAP_GET_READ_MIRRORS &&
> -	    dev_replace->tgtdev != NULL) {
> +	    !need_full_stripe(op) && dev_replace->tgtdev != NULL) {
>  		ret = get_extra_mirror_from_replace(fs_info, logical, *length,
>  						    dev_replace->srcdev->devid,
>  						    &mirror_num,
> @@ -5876,10 +5880,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		bbio->tgtdev_map = (int *)(bbio->stripes + num_alloc_stripes);
>
>  	/* build raid_map */
> -	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK &&
> -	    need_raid_map &&
> -	    ((op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS) ||
> -	    mirror_num > 1)) {
> +	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK && need_raid_map &&
> +	    (need_full_stripe(op) || mirror_num > 1)) {
>  		u64 tmp;
>  		unsigned rot;
>
> @@ -5914,14 +5916,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		stripe_index++;
>  	}
>
> -	if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
> +	if (need_full_stripe(op))
>  		max_errors = btrfs_chunk_max_errors(map);
>
>  	if (bbio->raid_map)
>  		sort_parity_stripes(bbio, num_stripes);
>
>  	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL &&
> -	    (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)) {
> +	    need_full_stripe(op)) {
>  		handle_ops_on_dev_replace(op, &bbio, dev_replace, &num_stripes,
>  					  &max_errors);
>  	}
>


