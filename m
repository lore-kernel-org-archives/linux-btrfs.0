Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43569 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbeISFwS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 01:52:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id j26-v6so1781780pfi.10
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 17:17:12 -0700 (PDT)
Date: Tue, 18 Sep 2018 17:17:10 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 17/36] btrfs: loop in inode_rsv_refill
Message-ID: <20180919001710.GE479@vader>
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-18-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911175807.26181-18-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 01:57:48PM -0400, Josef Bacik wrote:
> With severe fragmentation we can end up with our inode rsv size being
> huge during writeout, which would cause us to need to make very large
> metadata reservations.  However we may not actually need that much once
> writeout is complete.  So instead try to make our reservation, and if we
> couldn't make it re-calculate our new reservation size and try again.
> If our reservation size doesn't change between tries then we know we are
> actually out of space and can error out.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 57567d013447..e43834380ce6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5790,10 +5790,11 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
>  {
>  	struct btrfs_root *root = inode->root;
>  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> -	u64 num_bytes = 0;
> +	u64 num_bytes = 0, last = 0;
>  	u64 qgroup_num_bytes = 0;
>  	int ret = -ENOSPC;
>  
> +again:
>  	spin_lock(&block_rsv->lock);
>  	if (block_rsv->reserved < block_rsv->size)
>  		num_bytes = block_rsv->size - block_rsv->reserved;
> @@ -5818,8 +5819,22 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
>  		spin_lock(&block_rsv->lock);
>  		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
>  		spin_unlock(&block_rsv->lock);
> -	} else
> +	} else {
>  		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
> +
> +		/*
> +		 * If we are fragmented we can end up with a lot of outstanding
> +		 * extents which will make our size be much larger than our
> +		 * reserved amount.  If we happen to try to do a reservation
> +		 * here that may result in us trying to do a pretty hefty
> +		 * reservation, which we may not need once delalloc flushing
> +		 * happens.  If this is the case try and do the reserve again.
> +		 */
> +		if (flush == BTRFS_RESERVE_FLUSH_ALL && last != num_bytes) {

Is there any point in retrying the reservation if num_bytes didn't
change? As this is written, we will:

1. Calculate num_bytes
2. Try reservation, say it fails
3. Recalculate num_bytes, say it doesn't change
4. Retry the reservation anyways, and it fails again

Maybe we should check if it changed before we retry the reservation? So
then we'd have

1. Calculate num_bytes
2. Try reservation, fails
3. Recalculate num_bytes, it doesn't change, bail out

Also, is it possible that num_bytes > last because of other operations
happening at the same time, and should we still retry in that case?

> +			last = num_bytes;
> +			goto again;
> +		}
> +	}
>  	return ret;
>  }
>  
> -- 
> 2.14.3
> 
