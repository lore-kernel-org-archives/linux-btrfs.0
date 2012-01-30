From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs: allow cloning ranges within the same file
Date: Mon, 30 Jan 2012 10:56:15 +0100
Message-ID: <4F26693F.2010705@jan-o-sch.net>
References: <4F265F78.1010806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F265F78.1010806@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

I like allowing those clones. However ...

On 30.01.2012 10:14, Li Zefan wrote:
> It's safe and easy to do so, provided the ranges don't overlap.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0b06a5c..8fcd671 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2223,8 +2223,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	 *   decompress into destination's address_space (the file offset
>  	 *   may change, so source mapping won't do), then recompress (or
>  	 *   otherwise reinsert) a subrange.
> -	 * - allow ranges within the same file to be cloned (provided
> -	 *   they don't overlap)?
>  	 */
>  
>  	/* the destination must be opened for writing */
> @@ -2247,8 +2245,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	src = src_file->f_dentry->d_inode;
>  
>  	ret = -EINVAL;
> -	if (src == inode)
> -		goto out_fput;
>  
>  	/* the src must be open for reading */
>  	if (!(src_file->f_mode & FMODE_READ))
> @@ -2282,9 +2278,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	if (inode < src) {
>  		mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
>  		mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
> -	} else {
> +	} else if (inode > src) {
>  		mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
>  		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
> +	} else {
> +		mutex_lock(&inode->i_mutex);
>  	}
>  
>  	/* determine range to clone */
> @@ -2302,6 +2300,13 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	    !IS_ALIGNED(destoff, bs))
>  		goto out_unlock;
>  
> +	/*
> +	 * allow ranges within the same file to be cloned only if
> +	 * they don't overlap
> +	 */
> +	if (src == inode && !(off + len <= destoff || destoff + len <= off))
            ^^^^^^^^^^^^
... this check isn't sufficient. Two different inodes can reference the
same data extent and we must prevent overlap cloning there as well.

-Jan

> +		goto out_unlock;
> +
>  	if (destoff > inode->i_size) {
>  		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
>  		if (ret)
> @@ -2543,8 +2548,12 @@ out:
>  	btrfs_release_path(path);
>  	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
>  out_unlock:
> -	mutex_unlock(&src->i_mutex);
> -	mutex_unlock(&inode->i_mutex);
> +	if (src != inode) {
> +		mutex_unlock(&src->i_mutex);
> +		mutex_unlock(&inode->i_mutex);
> +	} else {
> +		mutex_unlock(&inode->i_mutex);
> +	}
>  	vfree(buf);
>  	btrfs_free_path(path);
>  out_fput:
