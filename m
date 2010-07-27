From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: compressed file size ioctl
Date: Tue, 27 Jul 2010 09:44:48 +0800
Message-ID: <4C4E3A10.8050204@cn.fujitsu.com>
References: <1280158253-10515-1-git-send-email-uli@suse.de>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: linux-btrfs@vger.kernel.org
To: Ulrich Hecht <uli@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1280158253-10515-1-git-send-email-uli@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 26 Jul 2010 17:30:53 +0200, Ulrich Hecht wrote:
[snip]
> +static long btrfs_ioctl_compsize(struct file *file, void __user *argp)
> +{
[snip]
> +
> +	/* search for the inode */
> +	key.objectid = inode->i_ino;
> +	key.type = BTRFS_EXTENT_DATA_KEY;
> +	key.offset = 0;
> +
> +	while (1) {
> +		/* note the key will change type as we walk through the tree */
> +		ret = btrfs_search_slot(NULL, root,&key, path, 0, 0);
> +		if (ret<  0)
> +			goto out;

Why don't you use btrfs_get_extent() to implement it?

Thanks
Miao

> +
> +		nritems = btrfs_header_nritems(path->nodes[0]);
> +		if (path->slots[0]>= nritems) {
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret<  0)
> +				goto out;
> +			if (ret>  0)
> +				break;
> +			nritems = btrfs_header_nritems(path->nodes[0]);
> +		}
> +		leaf = path->nodes[0];
> +		slot = path->slots[0];
> +
> +		btrfs_item_key_to_cpu(leaf,&key, slot);
> +		if (btrfs_key_type(&key)>  BTRFS_EXTENT_DATA_KEY ||
> +		    key.objectid != inode->i_ino)
> +			break;
> +
> +		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
> +			struct btrfs_file_extent_item *extent;
> +			int type;
> +			u64 datal = 0;
> +
> +			extent = btrfs_item_ptr(leaf, slot,
> +						struct btrfs_file_extent_item);
> +			type = btrfs_file_extent_type(leaf, extent);
> +			if (type == BTRFS_FILE_EXTENT_REG) {
> +				datal = btrfs_file_extent_num_bytes(leaf,
> +								    extent);
> +				compressed_size +=
> +				  btrfs_file_extent_disk_num_bytes(leaf,
> +								   extent);
> +			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
> +				datal = btrfs_file_extent_ram_bytes(leaf,
> +								    extent);
> +				compressed_size +=
> +				  btrfs_file_extent_inline_item_len(leaf,
> +					      btrfs_item_nr(leaf, slot));
> +			}
> +			btrfs_release_path(root, path);
> +		}
> +
> +		btrfs_release_path(root, path);
> +		key.offset++;
> +	}
> +
> +	/* We've succeeded in going through all extents; set the final size. */
> +	if (copy_to_user(argp,&compressed_size, sizeof(compressed_size)))
> +		ret = -EFAULT;
> +	else
> +		ret = 0;
> +
> +out:
> +	btrfs_release_path(root, path);
> +	unlock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
> +	mutex_unlock(&inode->i_mutex);
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>   static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
>   {
>   	struct btrfs_ioctl_clone_range_args args;
> @@ -2034,6 +2135,8 @@ long btrfs_ioctl(struct file *file, unsigned int
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

