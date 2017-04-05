Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33393 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933203AbdDENBz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 09:01:55 -0400
Date: Wed, 5 Apr 2017 15:01:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Jay Sharma <chandansbg@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl
 interface support
Message-ID: <20170405130110.GD4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170404160639.12155-1-chandansbg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170404160639.12155-1-chandansbg@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 04, 2017 at 09:36:39PM +0530, Chandan Jay Sharma wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface support
> for btrfs. Extended file attributes are 32 bit values (FS_XFLAGS_SYNC,
> FS_XFLAG_IMMUTABLE, etc) which have one-to-one mapping to the flag values
> that can be stored in inode->i_flags (i.e. S_SYNC, S_IMMUTABLE, etc).
> The flags can be set/unset to enable/disable file attributes.
> These attributes are listed/modified by lsattr/chattr.

Ok.

> Signed-off-by: Chandan Jay Sharma <chandansbg@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 148 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 148 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index dabfc7a..5d8486b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -132,6 +132,25 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
>  	return iflags;
>  }
>  
> +/* Transfer ioctl flags to btrfs internal flags */

Please mention which ioctl as we now have 2 that do a similar thing.

> +static unsigned int btrfs_ioctl_to_flags(unsigned int iflags)
> +{
> +	unsigned int flags = 0;
> +
> +	if (iflags & FS_SYNC_FL)
> +		flags |= BTRFS_INODE_SYNC;
> +	if (iflags & FS_IMMUTABLE_FL)
> +		flags |= BTRFS_INODE_IMMUTABLE;
> +	if (iflags & FS_APPEND_FL)
> +		flags |= BTRFS_INODE_APPEND;
> +	if (iflags & FS_NODUMP_FL)
> +		flags |= BTRFS_INODE_NODUMP;
> +	if (iflags & FS_NOATIME_FL)
> +		flags |= BTRFS_INODE_NOATIME;
> +
> +	return flags;
> +}
> +
>  /*
>   * Update inode->i_flags based on the btrfs internal flags.
>   */
> @@ -157,6 +176,75 @@ void btrfs_update_iflags(struct inode *inode)
>  }
>  
>  /*
> + * Propagate flags from i_flags to BTRFS_I(inode)->flags
> + */
> +void btrfs_get_inode_flags(struct btrfs_inode *ip)
> +{
> +	unsigned int vfs_fl;
> +	unsigned long old_fl, new_fl;
> +
> +	do {
> +		vfs_fl = ip->vfs_inode.i_flags;
> +		old_fl = ip->flags;
> +		new_fl = old_fl & ~(BTRFS_INODE_SYNC|BTRFS_INODE_APPEND|
> +				BTRFS_INODE_IMMUTABLE|BTRFS_INODE_NOATIME|
> +				BTRFS_INODE_DIRSYNC);

The list of supported flags should be declared in a header, something
like

#define BTRFS_INODE_FLAGS_MASK (BTRFS_INODE_SYNC |
				BTRFS_INODE_APPEND |
				BTRFS_INODE_IMMUTABLE |
				BTRFS_INODE_NOATIME |
				BTRFS_INODE_DIRSYNC)

> +		if (vfs_fl & S_SYNC)
> +			new_fl |= BTRFS_INODE_SYNC;
> +		if (vfs_fl & S_APPEND)
> +			new_fl |= BTRFS_INODE_APPEND;
> +		if (vfs_fl & S_IMMUTABLE)
> +			new_fl |= BTRFS_INODE_IMMUTABLE;
> +		if (vfs_fl & S_NOATIME)
> +			new_fl |= BTRFS_INODE_NOATIME;
> +		if (vfs_fl & S_DIRSYNC)
> +			new_fl |= BTRFS_INODE_DIRSYNC;
> +	} while (cmpxchg(&ip->flags, old_fl, new_fl) != old_fl);
> +}
> +
> +/*
> + * Translate btrfs internal flags BTRFS_I(inode)->flags to xflags.

Maybe also reference the related ioctl.

> + */
> +static inline unsigned int btrfs_flags_to_xflags(unsigned int flags)
> +{
> +	unsigned int xflags = 0;
> +
> +	if (flags & BTRFS_INODE_SYNC)
> +		xflags |= FS_XFLAG_SYNC;
> +	if (flags & BTRFS_INODE_IMMUTABLE)
> +		xflags |= FS_XFLAG_IMMUTABLE;
> +	if (flags & BTRFS_INODE_APPEND)
> +		xflags |= FS_XFLAG_APPEND;
> +	if (flags & BTRFS_INODE_NODUMP)
> +		xflags |= FS_XFLAG_NODUMP;
> +	if (flags & BTRFS_INODE_NOATIME)
> +		xflags |= FS_XFLAG_NOATIME;
> +
> +	return xflags;
> +}
> +
> +/*
> + * Transfer xflags flags to ioctl flags.
> + */
> +static inline unsigned int btrfs_xflags_to_ioctl(unsigned int xflags)
> +{
> +	unsigned int flags = 0;
> +
> +	if (xflags & FS_XFLAG_SYNC)
> +		flags |= FS_SYNC_FL;
> +	if (xflags & FS_XFLAG_IMMUTABLE)
> +		flags |= FS_IMMUTABLE_FL;
> +	if (xflags & FS_XFLAG_APPEND)
> +		flags |= FS_APPEND_FL;
> +	if (xflags & FS_XFLAG_NODUMP)
> +		flags |= FS_NODUMP_FL;
> +	if (xflags & FS_XFLAG_NOATIME)
> +		flags |= FS_NOATIME_FL;
> +
> +	return flags;
> +}
> +
> +/*
>   * Inherit flags from the parent inode.
>   *
>   * Currently only the compression flags and the cow flags are inherited.
> @@ -5504,6 +5592,62 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
>  	return ret;
>  }
>  
> +static int btrfs_ioctl_fsgetxattr(struct file *file, void __user *arg)
> +{
> +	struct fsxattr fa;
> +	struct btrfs_inode *ip = BTRFS_I(file_inode(file));
> +
> +	memset(&fa, 0, sizeof(struct fsxattr));
> +	btrfs_get_inode_flags(ip);
> +	fa.fsx_xflags = btrfs_flags_to_xflags(ip->flags);
> +
> +	if (copy_to_user((struct fsxattr __user *)arg,
> +			&fa, sizeof(fa)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct btrfs_inode *ip = BTRFS_I(inode);
> +	struct btrfs_root *root = ip->root;
> +	struct fsxattr fa;
> +	unsigned int flags;
> +	int err;
> +
> +	/* Make sure caller has proper permission */
> +	if (!inode_owner_or_capable(inode))
> +		return -EPERM;
> +
> +	if (btrfs_root_readonly(root))
> +		return -EROFS;
> +
> +	memset(&fa, 0, sizeof(struct fsxattr));
> +	if (copy_from_user(&fa, (struct fsxattr __user *)arg,
> +			sizeof(fa)))
> +		return -EFAULT;
> +
> +	flags = btrfs_xflags_to_ioctl(fa.fsx_xflags);
> +
> +	if (btrfs_mask_flags(inode->i_mode, flags) != flags)
> +		return -EOPNOTSUPP;

Please see btrfs_ioctl_setflags what's needs do be done here

- verify that the requested flags are supported
- start transaction
- update the flags
- inode_inc_iversion
- update ctime
- update the inode
- end transaction

> +	err = mnt_want_write_file(file);
> +	if (err)
> +		return err;
> +
> +	inode_lock(inode);
> +	ip->flags = (ip->flags | btrfs_ioctl_to_flags(flags));
> +	btrfs_update_iflags(inode);
> +	inode_unlock(inode);
> +
> +	mnt_drop_write_file(file);
> +
> +	return 0;
> +}
