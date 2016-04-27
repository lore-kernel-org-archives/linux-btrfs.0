Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18242 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039AbcD0B3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 21:29:38 -0400
Subject: Re: [PATCH v10 11/21] btrfs: dedupe: Add ioctl for inband
 dedupelication
To: <linux-btrfs@vger.kernel.org>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-12-git-send-email-quwenruo@cn.fujitsu.com>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8321f238-764e-d833-969f-e3d09723371a@cn.fujitsu.com>
Date: Wed, 27 Apr 2016 09:29:29 +0800
MIME-Version: 1.0
In-Reply-To: <1459492512-31435-12-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David

Qu Wenruo wrote on 2016/04/01 14:35 +0800:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>
> Add ioctl interface for inband dedupelication, which includes:
> 1) enable
> 2) disable
> 3) status
>
> And a pseudo RO compat flag, to imply that btrfs now supports inband
> dedup.
> However we don't add any ondisk format change, it's just a pseudo RO
> compat flag.
>
> All these ioctl interface are state-less, which means caller don't need
> to bother previous dedupe state before calling them, and only need to
> care the final desired state.
>
> For example, if user want to enable dedupe with specified block size and
> limit, just fill the ioctl structure and call enable ioctl.
> No need to check if dedupe is already running.
>
> These ioctls will handle things like re-configure or disable quite well.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>  static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
>  				     struct inode *inode,
>  				     u64 endoff,
> @@ -5542,6 +5606,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_fslabel(file, argp);
>  	case BTRFS_IOC_SET_FSLABEL:
>  		return btrfs_ioctl_set_fslabel(file, argp);

Would you mind me to add a new kernel config "Btrfs experimental 
features-> dedupe ioctl" for case like dedupe and further experimental 
btrfs features?

The BTRFS_DEBUG seems quite odd for me.
Although in-band dedupe is quite good at exposing bugs of 
backref/qgroup/delayed_refs, but I still think it's not a debug tool.

So I hope to use "BTRFS_EXPERIMENTAL_DEDUPE_IOCTL" and add corresponding 
Kconfig interfaces.

Thanks,
Qu

> +#ifdef CONFIG_BTRFS_DEBUG
> +	case BTRFS_IOC_DEDUPE_CTL:
> +		return btrfs_ioctl_dedupe_ctl(root, argp);
> +#endif
>  	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>  		return btrfs_ioctl_get_supported_features(argp);
>  	case BTRFS_IOC_GET_FEATURES:
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 539e7b5..18686d1 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -203,6 +203,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
>  BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
>  BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
>  BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
> +BTRFS_FEAT_ATTR_COMPAT_RO(dedupe, DEDUPE);
>
>  static struct attribute *btrfs_supported_feature_attrs[] = {
>  	BTRFS_FEAT_ATTR_PTR(mixed_backref),
> @@ -215,6 +216,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
>  	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
>  	BTRFS_FEAT_ATTR_PTR(no_holes),
>  	BTRFS_FEAT_ATTR_PTR(free_space_tree),
> +	BTRFS_FEAT_ATTR_PTR(dedupe),
>  	NULL
>  };
>
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index dea8931..de48414 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -445,6 +445,27 @@ struct btrfs_ioctl_get_dev_stats {
>  	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
>  };
>
> +/*
> + * de-duplication control modes
> + * For re-config, re-enable will handle it
> + */
> +#define BTRFS_DEDUPE_CTL_ENABLE	1
> +#define BTRFS_DEDUPE_CTL_DISABLE 2
> +#define BTRFS_DEDUPE_CTL_STATUS	3
> +#define BTRFS_DEDUPE_CTL_LAST	4
> +struct btrfs_ioctl_dedupe_args {
> +	__u16 cmd;		/* In: command(see above macro) */
> +	__u64 blocksize;	/* In/Out: For enable/status */
> +	__u64 limit_nr;		/* In/Out: For enable/status */
> +	__u64 limit_mem;	/* In/Out: For enable/status */
> +	__u64 current_nr;	/* Out: For status output */
> +	__u16 backend;		/* In/Out: For enable/status */
> +	__u16 hash_type;	/* In/Out: For enable/status */
> +	u8 status;		/* Out: For status output */
> +	/* pad to 512 bytes */
> +	u8 __unused[473];
> +};
> +
>  #define BTRFS_QUOTA_CTL_ENABLE	1
>  #define BTRFS_QUOTA_CTL_DISABLE	2
>  #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
> @@ -653,6 +674,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>  				    struct btrfs_ioctl_dev_replace_args)
>  #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
>  					 struct btrfs_ioctl_same_args)
> +#define BTRFS_IOC_DEDUPE_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
> +				      struct btrfs_ioctl_dedupe_args)
>  #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
>  				   struct btrfs_ioctl_feature_flags)
>  #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
>


