From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: add new ioctl to determine size of compressed
 file
Date: Tue, 20 Dec 2011 09:33:06 +0800
Message-ID: <4EEFE5D2.6020401@cn.fujitsu.com>
References: <1324304223-19079-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1324304223-19079-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2011 10:17 PM, David Sterba wrote:
> Go through all extents of a file in a given [start,end) range and sum
> for:
> * regular extent: ->block_len, size is already rounded up to blocks
> * inline extents: length rounded up to 512
> 
> The range is start inclusive / end exclusive. For the whole file pass
> 0 and (u64)-1.
> 
> The resulting value is number of occupied 512B sectors so this can
> be easily compared to stat.st_blocks to determine rough compression
> ratio of a file.
> 
> Based on implementation from Ulrich Hecht,
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/6253
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/ioctl.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |   11 +++++++
>  2 files changed, 88 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c04f02c..82c3810 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2972,6 +2972,81 @@ static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
>  	return 0;
>  }
>  
> +/*
> + * Returns the compressed size of an inode in 512 byte blocks.
> + * Count the on-disk space used by extents starting in range [start, end),
> + * inline data are rounded up to sector, ie. 512.
> + *
> + * The range is start inclusive and end exclusive so it can be used to
> + * determine compressed size of a given extent by its start and start of the
> + * next extent easily, without counting length.
> + * Whole file is specified as start = 0, end = (u64)-1
> + */
> +static long btrfs_ioctl_compr_size(struct file *file, void __user *argp)
> +{
> +	struct inode *inode = fdentry(file)->d_inode;
> +	struct btrfs_ioctl_compr_size_args compr_args;
> +	u64 len;
> +	u64 compressed_size = 0;
> +	u64 offset = 0;
> +
> +	if (S_ISDIR(inode->i_mode))
> +		return -EISDIR;
> +
> +	if (copy_from_user(&compr_args, argp,
> +				sizeof(struct btrfs_ioctl_compr_size_args)))
> +		return -EFAULT;
> +
> +	if (compr_args.start > compr_args.end)
> +		return -EINVAL;
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	offset = compr_args.start;
> +	if (inode->i_size > compr_args.end)
> +		len = compr_args.end;
> +	else
> +		len = inode->i_size;
> +
> +	/*
> +	 * do any pending delalloc/csum calc on inode, one way or
> +	 * another, and lock file content
> +	 */
> +	btrfs_wait_ordered_range(inode, compr_args.start, len);
> +


missing a lock_extent() ?
and we may adjust i_mutex and [un]lock_extent.

thanks,
liubo

> +	while (offset < len) {
> +		struct extent_map *em;
> +
> +		em = btrfs_get_extent(inode, NULL, 0, offset, 1, 0);
> +		if (IS_ERR_OR_NULL(em))
> +			goto error;
> +		if (em->block_len != (u64)-1)
> +			compressed_size += em->block_len;
> +		else if (em->block_start == EXTENT_MAP_INLINE) {
> +			compressed_size += ALIGN(em->len, 512);
> +		}
> +		offset += em->len;
> +		free_extent_map(em);
> +	}
> +	mutex_unlock(&inode->i_mutex);
> +
> +	unlock_extent(&BTRFS_I(inode)->io_tree, compr_args.start, len, GFP_NOFS);
> +
> +	compr_args.size = compressed_size >> 9;
> +
> +	if (copy_to_user(argp, &compr_args, sizeof(struct
> +					btrfs_ioctl_compr_size_args)))
> +		return -EFAULT;
> +
> +	return 0;
> +
> +error:
> +	mutex_unlock(&inode->i_mutex);
> +	unlock_extent(&BTRFS_I(inode)->io_tree, compr_args.start, len, GFP_NOFS);
> +
> +	return -EIO;
> +}
> +
>  static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
>  					void __user *arg)
>  {
> @@ -3110,6 +3185,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_scrub_cancel(root, argp);
>  	case BTRFS_IOC_SCRUB_PROGRESS:
>  		return btrfs_ioctl_scrub_progress(root, argp);
> +	case BTRFS_IOC_COMPR_SIZE:
> +		return btrfs_ioctl_compr_size(file, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 252ae99..bce761c 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -217,6 +217,15 @@ struct btrfs_ioctl_logical_ino_args {
>  	__u64				inodes;
>  };
>  
> +struct btrfs_ioctl_compr_size_args {
> +	/* Range start, inclusive */
> +	__u64				start;		/* in */
> +	/* Range end, exclusive */
> +	__u64				end;		/* in */
> +	__u64				size;		/* out */
> +	__u64				reserved[2];
> +};
> +
>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
> @@ -276,5 +285,7 @@ struct btrfs_ioctl_logical_ino_args {
>  					struct btrfs_ioctl_ino_path_args)
>  #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
>  					struct btrfs_ioctl_ino_path_args)
> +#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 51, \
> +				struct btrfs_ioctl_compr_size_args)
>  
>  #endif

