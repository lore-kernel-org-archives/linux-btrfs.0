Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32177 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752593AbdGMQkq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 12:40:46 -0400
Date: Thu, 13 Jul 2017 09:38:07 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: btrfs_create_repair_bio never fails, skip error
 handling
Message-ID: <20170713163807.GD12913@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170713154215.20191-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170713154215.20191-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 05:42:15PM +0200, David Sterba wrote:
> As it uses the non-failinig bio allocation, we can remove error handling
> from the callers as well.
>

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 4 ----
>  fs/btrfs/inode.c     | 4 ----
>  2 files changed, 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 2e6f69908303..7010b7764e23 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2394,10 +2394,6 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
>  				      start - page_offset(page),
>  				      (int)phy_offset, failed_bio->bi_end_io,
>  				      NULL);
> -	if (!bio) {
> -		free_io_failure(failure_tree, tree, failrec);
> -		return -EIO;
> -	}
>  	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
>  
>  	btrfs_debug(btrfs_sb(inode->i_sb),
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5d3c6ac960fd..97460e492d91 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8017,10 +8017,6 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
>  	isector >>= inode->i_sb->s_blocksize_bits;
>  	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
>  				pgoff, isector, repair_endio, repair_arg);
> -	if (!bio) {
> -		free_io_failure(failure_tree, io_tree, failrec);
> -		return -EIO;
> -	}
>  	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
>  
>  	btrfs_debug(BTRFS_I(inode)->root->fs_info,
> -- 
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
