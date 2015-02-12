Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36378 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbbBLD4G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 22:56:06 -0500
Date: Thu, 12 Feb 2015 11:52:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: only adjust outstanding_extents when we do a
 short write
Message-ID: <20150212035234.GA2416@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1423685339-8278-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423685339-8278-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 03:08:57PM -0500, Josef Bacik wrote:
> We have this weird dance where we always inc outstanding_extents when we do a
> O_DIRECT write, even if we allocate the entire range.  To get around this we
> also drop the metadata space if we successfully write.  This is an unnecessary
> dance, we only need to jack up outstanding_extents if we don't satisfy the
> entire range request in get_blocks_direct, otherwise we are good using our
> original reservation.  So drop the unconditional inc and the drop of the
> metadata space that we have for the unconditional inc.  Thanks,

Looks good.
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/inode.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8a036ed..e78a2fd 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7137,6 +7137,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  	u64 start = iblock << inode->i_blkbits;
>  	u64 lockstart, lockend;
>  	u64 len = bh_result->b_size;
> +	u64 orig_len = len;
>  	int unlock_bits = EXTENT_LOCKED;
>  	int ret = 0;
>  
> @@ -7272,9 +7273,11 @@ unlock:
>  		if (start + len > i_size_read(inode))
>  			i_size_write(inode, start + len);
>  
> -		spin_lock(&BTRFS_I(inode)->lock);
> -		BTRFS_I(inode)->outstanding_extents++;
> -		spin_unlock(&BTRFS_I(inode)->lock);
> +		if (len < orig_len) {
> +			spin_lock(&BTRFS_I(inode)->lock);
> +			BTRFS_I(inode)->outstanding_extents++;
> +			spin_unlock(&BTRFS_I(inode)->lock);
> +		}
>  
>  		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
>  				     lockstart + len - 1, EXTENT_DELALLOC, NULL,
> @@ -8056,8 +8059,6 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>  		else if (ret >= 0 && (size_t)ret < count)
>  			btrfs_delalloc_release_space(inode,
>  						     count - (size_t)ret);
> -		else
> -			btrfs_delalloc_release_metadata(inode, 0);
>  	}
>  out:
>  	if (wakeup)
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
