Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3IPR06 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 13:26:58 -0400
Date: Mon, 16 Sep 2013 19:26:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, clmason@fusionio.com, dsterba@suse.cz
Subject: Re: [patch 1/7] [PATCH] btrfs: add ability to query/change feature
 bits online
Message-ID: <20130916172651.GV6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130910042408.335071038@suse.com>
 <20130910043007.438505775@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130910043007.438505775@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 10, 2013 at 12:24:09AM -0400, Jeff Mahoney wrote:
> +static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
> +	struct btrfs_super_block *super_block = root->fs_info->super_copy;
> +	struct btrfs_ioctl_feature_flags flags[2];
> +	struct btrfs_trans_handle *trans;
> +	u64 newflags;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (copy_from_user(flags, arg, sizeof(flags)))
> +		return -EFAULT;
> +
> +	/* Nothing to do */
> +	if (!flags[0].compat_flags && !flags[0].compat_ro_flags &&
> +	    !flags[0].incompat_flags)
> +		return 0;
> +
> +	ret = check_feature(root, flags[0].compat_flags,
> +			    flags[1].compat_flags, COMPAT);
> +	if (ret)
> +		return ret;
> +
> +	ret = check_feature(root, flags[0].compat_ro_flags,
> +			    flags[1].compat_ro_flags, COMPAT_RO);
> +	if (ret)
> +		return ret;
> +
> +	ret = check_feature(root, flags[0].incompat_flags,
> +			    flags[1].incompat_flags, INCOMPAT);
> +	if (ret)
> +		return ret;
> +
> +	trans = btrfs_start_transaction(root, 1);

It's ok to use 0 here, it's a superblock change and not related the the
metadata (similar to changing the label).

> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	spin_lock(&root->fs_info->super_lock);
> +	newflags = btrfs_super_compat_flags(super_block);
> +	newflags |= flags[0].compat_flags & flags[1].compat_flags;
> +	newflags &= ~(flags[0].compat_flags & ~flags[1].compat_flags);
> +	btrfs_set_super_compat_flags(super_block, newflags);
> +
> +	newflags = btrfs_super_compat_ro_flags(super_block);
> +	newflags |= flags[0].compat_ro_flags & flags[1].compat_ro_flags;
> +	newflags &= ~(flags[0].compat_ro_flags & ~flags[1].compat_ro_flags);
> +	btrfs_set_super_compat_ro_flags(super_block, newflags);
> +
> +	newflags = btrfs_super_incompat_flags(super_block);
> +	newflags |= flags[0].incompat_flags & flags[1].incompat_flags;
> +	newflags &= ~(flags[0].incompat_flags & ~flags[1].incompat_flags);
> +	btrfs_set_super_incompat_flags(super_block, newflags);
> +	spin_unlock(&root->fs_info->super_lock);
> +
> +	return btrfs_end_transaction(trans, root);

I think it's better to use btrfs_commit_transaction. The ioctl is about
to do a permanent change, any crash between ioctl and full commit will
revert to previous state of the features. This is not IMO desirable from
administrators POV.

(Sidenote, IOC_SET_FSLABEL needs the same update.)

> +}
> +
> --- a/include/uapi/linux/btrfs.h	2013-09-09 17:49:10.808003254 -0400
> +++ b/include/uapi/linux/btrfs.h	2013-09-09 17:49:12.483979430 -0400
> @@ -184,6 +184,12 @@ struct btrfs_ioctl_fs_info_args {
>  	__u64 reserved[124];			/* pad to 1k */
>  };
>  
> +struct btrfs_ioctl_feature_flags {
> +	__u64 compat_flags;
> +	__u64 compat_ro_flags;
> +	__u64 incompat_flags;

I wonder if it makes sense to add spare bytes here, but does not seem
necessary.

> +};
> @@ -579,4 +585,10 @@ static inline char *btrfs_err_str(enum b
> +#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, \
> +				   struct btrfs_ioctl_feature_flags)
> +#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 54, \
> +				   struct btrfs_ioctl_feature_flags[2])
> +#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, \
> +				   struct btrfs_ioctl_feature_flags[3])

The ioctl number 54 clashes with the OOB dedup merged into 3.12, 55 is
for the in-bound dedup and Anand has claimed 56. I've allocated 57 for
you and updated th wiki page:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Development_notes.2C_please_read

Stefan's trick to reuse the same number is really neat.
