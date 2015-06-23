Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbbFWPL6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 11:11:58 -0400
Date: Tue, 23 Jun 2015 17:11:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add no_mtime flag to btrfs-extent-same
Message-ID: <20150623151156.GI6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
 <1435013262-23252-6-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435013262-23252-6-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 03:47:42PM -0700, Mark Fasheh wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -87,7 +87,8 @@ struct btrfs_ioctl_received_subvol_args_32 {
>  
>  
>  static int btrfs_clone(struct inode *src, struct inode *inode,
> -		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
> +		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
> +		       int no_mtime);

Please make it 'flags' and pass the verified flags directly.

>  /* Mask out flags that are inappropriate for the given type of inode. */
>  static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
> @@ -2974,7 +2975,7 @@ static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
>  }
>  
>  static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> -			     struct inode *dst, u64 dst_loff)
> +			     struct inode *dst, u64 dst_loff, int no_mtime)
>  {
>  	int ret;
>  	u64 len = olen;
> @@ -3054,7 +3055,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	/* pass original length for comparison so we stay within i_size */
>  	ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
>  	if (ret == 0)
> -		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff);
> +		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff,
> +				  no_mtime);
>  
>  	if (same_inode)
>  		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> @@ -3088,6 +3090,7 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
>  	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
>  	bool is_admin = capable(CAP_SYS_ADMIN);
>  	u16 count;
> +	int no_mtime = 0;
>  
>  	if (!(file->f_mode & FMODE_READ))
>  		return -EINVAL;
> @@ -3139,6 +3142,12 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
>  	if (!S_ISREG(src->i_mode))
>  		goto out;
>  
> +	ret = -EINVAL;
> +	if (same->flags & ~BTRFS_SAME_FLAGS)
> +		goto out;
> +	if (same->flags & BTRFS_SAME_NO_MTIME)
> +		no_mtime = 1;
> +
>  	/* pre-format output fields to sane values */
>  	for (i = 0; i < count; i++) {
>  		same->info[i].bytes_deduped = 0ULL;
> @@ -3164,7 +3173,8 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
>  			info->status = -EACCES;
>  		} else {
>  			info->status = btrfs_extent_same(src, off, len, dst,
> -							info->logical_offset);
> +							 info->logical_offset,
> +							 no_mtime);
>  			if (info->status == 0)
>  				info->bytes_deduped += len;
>  		}
> @@ -3219,13 +3229,17 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
>  				     struct inode *inode,
>  				     u64 endoff,
>  				     const u64 destoff,
> -				     const u64 olen)
> +				     const u64 olen,
> +				     int no_mtime)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	int ret;
>  
>  	inode_inc_iversion(inode);
> -	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	if (no_mtime)
> +		inode->i_ctime = CURRENT_TIME;
> +	else
> +		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  	/*
>  	 * We round up to the block size at eof when determining which
>  	 * extents to clone above, but shouldn't round up the file size.
> @@ -3316,7 +3330,7 @@ static void clone_update_extent_map(struct inode *inode,
>   */
>  static int btrfs_clone(struct inode *src, struct inode *inode,
>  		       const u64 off, const u64 olen, const u64 olen_aligned,
> -		       const u64 destoff)
> +		       const u64 destoff, int no_mtime)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_path *path = NULL;
> @@ -3640,7 +3654,7 @@ process_slot:
>  					      root->sectorsize);
>  			ret = clone_finish_inode_update(trans, inode,
>  							last_dest_end,
> -							destoff, olen);
> +							destoff, olen, no_mtime);
>  			if (ret)
>  				goto out;
>  			if (new_key.offset + datal >= destoff + len)
> @@ -3678,7 +3692,7 @@ process_slot:
>  		clone_update_extent_map(inode, trans, NULL, last_dest_end,
>  					destoff + len - last_dest_end);
>  		ret = clone_finish_inode_update(trans, inode, destoff + len,
> -						destoff, olen);
> +						destoff, olen, no_mtime);
>  	}
>  
>  out:
> @@ -3808,7 +3822,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  		btrfs_double_extent_lock(src, off, inode, destoff, len);
>  	}
>  
> -	ret = btrfs_clone(src, inode, off, olen, len, destoff);
> +	ret = btrfs_clone(src, inode, off, olen, len, destoff, 0);
>  
>  	if (same_inode) {
>  		u64 lock_start = min_t(u64, off, destoff);
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index b6dec05..beeb51c 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h

> +#define	BTRFS_SAME_NO_MTIME	0x1
> +#define	BTRFS_SAME_FLAGS	(BTRFS_SAME_NO_MTIME)

The naming scheme used eg. for the send flags:

BTRFS_SEND_FLAG_MASK
BTRFS_SEND_FLAG_NO_FILE_DATA

So I suggest to follow it:

BTRFS_SAME_FLAG_MASK
BTRFS_SAME_FLAG_NO_MTIME

Though I'd rather see it named it with BTRFS_EXTENT_SAME_ prefix so it
(almost ...) matches the ioctl name (and is greppable).

This is going to be in a public interface so the naming is important.
