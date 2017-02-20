Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16063 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751068AbdBTGj3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 01:39:29 -0500
Subject: Re: [PATCH 5/7] Btrfs: do not add extra mirror when dev_replace
 target dev is not available
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
 <1487381301-865-6-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ac5b7f12-c0e8-e02f-5382-d71835a5d304@cn.fujitsu.com>
Date: Mon, 20 Feb 2017 14:39:15 +0800
MIME-Version: 1.0
In-Reply-To: <1487381301-865-6-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/18/2017 09:28 AM, Liu Bo wrote:
> With this, we can avoid allocating memory for dev replace copies if the
> target dev is not available.

The patch itself looks good.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

However I'm just curious about in which case we can have 
btrfs_dev_replace_is_going() returning 1 while dev_replace.tgtdev is NULL.

Since we are under the protect of btrfs_dev_replace_lock(), I wonder if 
dev_replace->tgt/srcdev can be modified.

Thanks,
Qu

>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c434489..bcd44eb 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5153,7 +5153,8 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  	free_extent_map(em);
>
>  	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
> -	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))
> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace) &&
> +	    fs_info->dev_replace.tgtdev)
>  		ret++;
>  	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
>
> @@ -5858,7 +5859,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  	}
>
>  	num_alloc_stripes = num_stripes;
> -	if (dev_replace_is_ongoing) {
> +	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL) {
>  		if (op == BTRFS_MAP_WRITE)
>  			num_alloc_stripes <<= 1;
>  		if (op == BTRFS_MAP_GET_READ_MIRRORS)
> @@ -5871,7 +5872,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> -	if (dev_replace_is_ongoing)
> +	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
>  		bbio->tgtdev_map = (int *)(bbio->stripes + num_alloc_stripes);
>
>  	/* build raid_map */
>


