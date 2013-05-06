Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3EFMge (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 08:36:34 -0400
Date: Mon, 6 May 2013 14:36:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        chris.mason@fusionio.com
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Message-ID: <20130506123631.GB16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
 <1366150535-18750-5-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366150535-18750-5-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 03:15:35PM -0700, Mark Fasheh wrote:
> +static void btrfs_double_lock(struct inode *inode1, u64 loff1,
> +			      struct inode *inode2, u64 loff2, u64 len)
> +{
> +	if (inode1 < inode2) {
> +		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
> +		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
> +		lock_extent_range(inode1, loff1, len);
> +		lock_extent_range(inode2, loff2, len);
> +	} else {
> +		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
> +		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
> +		lock_extent_range(inode2, loff2, len);
> +		lock_extent_range(inode1, loff1, len);
> +	}

You can decrease the code size by swapping just the pointers.

> +}
> +
> +static long btrfs_ioctl_file_extent_same(struct file *file,
> +					 void __user *argp)
> +{
> +	struct btrfs_ioctl_same_args *args;
> +	struct btrfs_ioctl_same_args tmp;
> +	struct btrfs_ioctl_same_extent_info *info;
> +	struct inode *src = file->f_dentry->d_inode;
> +	struct file *dst_file = NULL;
> +	struct inode *dst;
> +	u64 off;
> +	u64 len;
> +	int args_size;
> +	int i;
> +	int ret;
> +	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> +
> +	if (copy_from_user(&tmp,
> +			   (struct btrfs_ioctl_same_args __user *)argp,
> +			   sizeof(tmp)))
> +		return -EFAULT;
> +
> +	args_size = sizeof(tmp) + (tmp.total_files *
> +			sizeof(struct btrfs_ioctl_same_extent_info));
> +
> +	/* Keep size of ioctl argument sane */
> +	if (args_size > PAGE_CACHE_SIZE)
> +		return -ENOMEM;

Using E2BIG            7      /* Argument list too long */
makes more sense to me, it's not really an ENOMEM condition.

> +
> +	args = kmalloc(args_size, GFP_NOFS);
> +	if (!args)
> +		return -ENOMEM;

(like here)

> +
> +	ret = -EFAULT;
> +		if (BTRFS_I(dst)->root != BTRFS_I(src)->root) {
> +			printk(KERN_ERR "btrfs: cannot dedup across subvolumes"
> +			       " %lld\n", info->fd);
> +			goto next;
> +		}
...
> +		info->status = btrfs_extent_same(src, off, len, dst,
> +						 info->logical_offset);
> +		if (info->status == 0) {
> +			info->bytes_deduped = len;
> +			args->files_deduped++;
> +		} else {
> +			printk(KERN_ERR "error %d from btrfs_extent_same\n",

missing "btrfs:" prefix

> +				info->status);
> +		}
> +next:

> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> +/* For extent-same ioctl */
> +struct btrfs_ioctl_same_extent_info {
> +	__s64 fd;		/* in - destination file */
> +	__u64 logical_offset;	/* in - start of extent in destination */
> +	__u64 bytes_deduped;	/* out - total # of bytes we were able
> +				 * to dedupe from this file */
> +	/* status of this dedupe operation:
> +	 * 0 if dedup succeeds
> +	 * < 0 for error
> +	 * == BTRFS_SAME_DATA_DIFFERS if data differs
> +	 */
> +	__s32 status;		/* out - see above description */
> +	__u32 reserved;
> +};
> +
> +struct btrfs_ioctl_same_args {
> +	__u64 logical_offset;	/* in - start of extent in source */
> +	__u64 length;		/* in - length of extent */
> +	__u16 total_files;	/* in - total elements in info array */
> +	__u16 files_deduped;	/* out - number of files that got deduped */
> +	__u32 reserved;

Please add a few more reserved bytes here, we may want to enhance the
call with some fine tunables or extended status. This is an external
interface, we don't need to count every byte here and makes minor future
enhancements easier.

> +	struct btrfs_ioctl_same_extent_info info[0];
> +};
> +
>  struct btrfs_ioctl_space_info {
>  	__u64 flags;
>  	__u64 total_bytes;
> @@ -498,5 +523,6 @@ struct btrfs_ioctl_send_args {
>  				      struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>  				    struct btrfs_ioctl_dev_replace_args)
> -
> +#define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
> +					 struct btrfs_ioctl_same_args)

Feel free to claim the ioctl number at

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Development_notes.2C_please_read
