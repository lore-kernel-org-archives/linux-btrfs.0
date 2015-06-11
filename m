Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23360 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbbFKI4a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 04:56:30 -0400
Date: Thu, 11 Jun 2015 16:56:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>, Matt Robinson <git@nerdoftheherd.com>
Subject: Re: [RESEND][PATCH] btrfs: Align EOF length to block in extent_same
Message-ID: <20150611085613.GE9634@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20150610221355.GN18148@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150610221355.GN18148@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10, 2015 at 03:13:55PM -0700, Mark Fasheh wrote:
> Hi,
> 
> Can this patch please be considered for upstream inclusion? I reviewed
> it myself and have tested it on a few files with an updated duperemove
> branch:
> 
> https://github.com/markfasheh/duperemove/tree/alignment_fix
> 
> as described below, this allows us to dedupe the tail extents of files
> whose size is not block aligned. I have reports from users who hit
> this bug and as a result don't get any space savings and I believe this
> should help them out quite a bit.
> 
> Thanks,
> 	--Mark
> 
> From: Matt Robinson <git@nerdoftheherd.com>
> 
> It is not currently possible to deduplicate the last block of files
> whose size is not a multiple of the block size, as the btrfs_extent_same
> ioctl returns -EINVAL if offset + size is greater than the file size or
> is not aligned to the fs block size.
> 
> For example, with the default block size of 16K and two identical
> 1,000,000 byte files, calling the extent_same ioctl with offset 0 and
> length set to 1,000,000 the call fails with -EINVAL.  The same call
> with a length of 999,424 will succeed, but the final 576 bytes can then
> not be shared.  This seems to have a larger impact on the amount of
> space actually freed by the ioctl than would be expected - in my
> testing the amount of space freed was generally reduced by 50-100% for
> files sized from a few megabytes downwards which has a significant
> negative impact on the usefulness of the extent_same ioctl in some
> circumstances.
> 
> To resolve this, this patch allows unaligned offset + length values to
> be passed to btrfs_ioctl_file_extent_same if offset + length is equal
> to the file size of both src and dest.  This is implemented in the same
> way as in btrfs_ioctl_clone.
> 
> To return to the earlier example 1,000,000 byte file - this patch would
> allow a length of 1,000,000 bytes to be passed as it is equal to the
> file lengths and would be internally extended to the end of the block
> (1,015,808), allowing one set of extents to be shared completely between
> the full length of both files.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Matt Robinson <git@nerdoftheherd.com>
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/ioctl.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1c22c65..b2cdda6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2879,14 +2879,16 @@ static int btrfs_cmp_data(struct inode *src, u64 loff, struct inode *dst,
>  	return ret;
>  }
>  
> -static int extent_same_check_offsets(struct inode *inode, u64 off, u64 len)
> +static int extent_same_check_offsets(struct inode *inode, u64 off, u64 len,
> +				     u64 len_aligned)
>  {
>  	u64 bs = BTRFS_I(inode)->root->fs_info->sb->s_blocksize;
>  
>  	if (off + len > inode->i_size || off + len < off)
>  		return -EINVAL;
> +
>  	/* Check that we are block aligned - btrfs_clone() requires this */
> -	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs))
> +	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len_aligned, bs))
>  		return -EINVAL;
>  
>  	return 0;
> @@ -2896,6 +2898,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
>  			     struct inode *dst, u64 dst_loff)
>  {
>  	int ret;
> +	u64 len_aligned = len;
> +	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
>  
>  	/*
>  	 * btrfs_clone() can't handle extents in the same file
> @@ -2910,11 +2914,15 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
>  
>  	btrfs_double_lock(src, loff, dst, dst_loff, len);
>  
> -	ret = extent_same_check_offsets(src, loff, len);
> +	/* if we extend to both eofs, continue to block boundaries */
> +	if (loff + len == src->i_size && dst_loff + len == dst->i_size)
> +		len_aligned = ALIGN(src->i_size, bs) - loff;
> +
> +	ret = extent_same_check_offsets(src, loff, len, len_aligned);
>  	if (ret)
>  		goto out_unlock;
>  
> -	ret = extent_same_check_offsets(dst, dst_loff, len);
> +	ret = extent_same_check_offsets(dst, dst_loff, len, len_aligned);
>  	if (ret)
>  		goto out_unlock;
>  
> @@ -2927,7 +2935,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
>  
>  	ret = btrfs_cmp_data(src, loff, dst, dst_loff, len);
>  	if (ret == 0)
> -		ret = btrfs_clone(src, dst, loff, len, len, dst_loff);
> +		ret = btrfs_clone(src, dst, loff, len, len_aligned, dst_loff);
>  
>  out_unlock:
>  	btrfs_double_unlock(src, loff, dst, dst_loff, len);
> @@ -3173,8 +3181,7 @@ static void clone_update_extent_map(struct inode *inode,
>   * @inode: Inode to clone to
>   * @off: Offset within source to start clone from
>   * @olen: Original length, passed by user, of range to clone
> - * @olen_aligned: Block-aligned value of olen, extent_same uses
> - *               identical values here
> + * @olen_aligned: Block-aligned value of olen
>   * @destoff: Offset within @inode to start clone
>   */
>  static int btrfs_clone(struct inode *src, struct inode *inode,
> -- 
> 2.1.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
