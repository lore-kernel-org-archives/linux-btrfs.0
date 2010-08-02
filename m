From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: compressed file size ioctl
Date: Mon, 02 Aug 2010 09:15:42 +0800
Message-ID: <4C561C3E.8030609@cn.fujitsu.com>
References: <1280402829-28109-1-git-send-email-uli@suse.de>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: linux-btrfs@vger.kernel.org
To: Ulrich Hecht <uli@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1280402829-28109-1-git-send-email-uli@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 29 Jul 2010 13:27:09 +0200, Ulrich Hecht wrote:
> +static long btrfs_ioctl_compsize(struct file *file, void __user *argp)
> +{
> +	/* This ioctl returns the compressed size of an inode on disk
> +	 * by counting the on-disk space used by all of its extents.
> +	 */
> +	struct inode *inode = fdentry(file)->d_inode;
> +	struct extent_map *em;
> +	u64 len = inode->i_size;
> +	u64 compressed_size = 0;
> +	u64 offset = 0;
> +
> +	if (S_ISDIR(inode->i_mode))
> +		return -EISDIR;
> +	
> +	mutex_lock(&inode->i_mutex);
> +
> +	/* do any pending delalloc/csum calc on inode, one way or
> +	   another, and lock file content */
> +	btrfs_wait_ordered_range(inode, 0, (u64)-1);
> +
> +	while (offset<  len) {
> +		em = btrfs_get_extent(inode, NULL, 0, offset, 1, 0);

I think you need use lock_extent()/unlock_extent() to enclose
btrfs_get_extent(), but I didn't find lock_extent().

Thanks
Miao

> +		BUG_ON(IS_ERR(em) || !em);
> +		if (em->block_len != (u64)-1)
> +			compressed_size += em->block_len;
> +		offset += em->len;
> +		free_extent_map(em);
> +	}
> +	mutex_unlock(&inode->i_mutex);
> +
> +	unlock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
> +
> +	/* We've succeeded in going through all extents; set the final size. */
> +	if (copy_to_user(argp,&compressed_size, sizeof(compressed_size)))
> +		return -EFAULT;
> +	else
> +		return 0;
> +}
> +
>   static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
>   {
>   	struct btrfs_ioctl_clone_range_args args;
> @@ -2034,6 +2073,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>   	case BTRFS_IOC_SYNC:
>   		btrfs_sync_fs(file->f_dentry->d_sb, 1);
>   		return 0;
> +	case BTRFS_IOC_COMPR_SIZE:
> +		return btrfs_ioctl_compsize(file, argp);
>   	}
> 
>   	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 424694a..a01ef1e 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -178,4 +178,5 @@ struct btrfs_ioctl_space_args {
>   #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
>   #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
>   				    struct btrfs_ioctl_space_args)
> +#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 21, u64)
>   #endif

