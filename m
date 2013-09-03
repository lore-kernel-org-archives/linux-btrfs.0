Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:9565 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3ICJZw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 05:25:52 -0400
Message-ID: <5225AB12.9050102@giantdisaster.de>
Date: Tue, 03 Sep 2013 11:25:38 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: add ability to query/change feature bits online
References: <521CFB62.7010600@suse.com>
In-Reply-To: <521CFB62.7010600@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 27 Aug 2013 15:17:54 -0400, Jeff Mahoney wrote:
> There are some feature bits that require no offline setup and can
> be enabled online. I've only reviewed extended irefs, but there will
> probably be more.
> 
> We introduce three new ioctls:
> - BTRFS_IOC_GET_SUPPORTED_FEATURES: query the kernel for supported features
> - BTRFS_IOC_GET_FEATURES: query the kernel for enabled features on a per-fs
>   basis.
> - BTRFS_IOC_ADD_FEATURES: enable new features on a per-fs basis.
> 
> We introduce a new mask _SAFE_ONLINE that allows us to define which
> features are safe to enable at runtime.
> 
> The failure modes for BTRFS_IOC_ADD_FEATURES are as follows:
> - Enabling a completely unsupported feature: warns and returns -ENOTSUPP
> - Enabling a feature that can only be done offline: warns and returns -EPERM
> 
> The structure passed in is not modified on return since it is possible
> to isolate which features would bounce a -EPERM by subtracting the features
> provided by a GET_SUPPORTED_FEATURES call.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
[...]
> --- a/include/uapi/linux/btrfs.h	2013-08-27 11:02:35.062626912 -0400
> +++ b/include/uapi/linux/btrfs.h	2013-08-27 11:03:32.006352802 -0400
> @@ -184,6 +184,12 @@ struct btrfs_ioctl_fs_info_args {
>  	__u64 reserved[124];			/* pad to 1k */
>  };
>  
> +struct btrfs_ioctl_feature_flags {
> +	__u64 compat_flags;
> +	__u64 compat_ro_flags;
> +	__u64 incompat_flags;
> +};
> +
>  /* balance control ioctl modes */
>  #define BTRFS_BALANCE_CTL_PAUSE		1
>  #define BTRFS_BALANCE_CTL_CANCEL	2
> @@ -579,4 +585,10 @@ static inline char *btrfs_err_str(enum b
>  				      struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>  				    struct btrfs_ioctl_dev_replace_args)
> +#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, \
> +				   struct btrfs_ioctl_feature_flags)
> +#define BTRFS_IOC_ADD_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 55, \
> +				   struct btrfs_ioctl_feature_flags)

#define BTRFS_IOC_ADD_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 54, \
				   struct btrfs_ioctl_feature_flags)

Using 54 for both would also be possible since the directions are
different. _IOR(54) for the get ioctl and _IOW(54) for the set/add ioctl.


> +#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 56, \
> +				   struct btrfs_ioctl_feature_flags[2])

This could share the type value 54 too, since the parameter size is
different. There are only 8 bits for the type field.

And in order to support clearing feature bits you could replace the add
ioctl with a set ioctl and use a mask + value scheme.
#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 54, \
				   struct btrfs_ioctl_feature_flags[2])
btrfs_ioctl_feature_flags[0] is the mask and
btrfs_ioctl_feature_flags[1] is the value. Only bits that are set to one
in the mask are taken from the value and modified in the filesystem flags.


