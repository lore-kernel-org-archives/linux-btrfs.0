Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34599 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbcD0VHi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 17:07:38 -0400
Date: Wed, 27 Apr 2016 14:08:09 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/8] btrfs: uapi/linux/btrfs.h migration, move feature
 flags
Message-ID: <20160427210809.GG15822@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
 <1459541670-4097-5-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459541670-4097-5-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:14:26PM -0400, Jeff Mahoney wrote:
> The compat/compat_ro/incompat feature flags are used by the feature set/get
> ioctls.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h           | 25 -------------------------
>  include/uapi/linux/btrfs.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index c228b39..378482c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -506,31 +506,6 @@ struct btrfs_super_block {
>   * Compat flags that we support.  If any incompat flags are set other than the
>   * ones specified below then we will fail to mount
>   */
> -#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
> -
> -#define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
> -#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
> -#define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
> -#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
> -/*
> - * some patches floated around with a second compression method
> - * lets save that incompat here for when they do get in
> - * Note we don't actually support it, we're just reserving the
> - * number
> - */
> -#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZOv2	(1ULL << 4)
> -
> -/*
> - * older kernels tried to do bigger metadata blocks, but the
> - * code was pretty buggy.  Lets not let them try anymore.
> - */
> -#define BTRFS_FEATURE_INCOMPAT_BIG_METADATA	(1ULL << 5)
> -
> -#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
> -#define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
> -#define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
> -#define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
> -
>  #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
>  #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
>  #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 0316e23..de98717 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -222,6 +222,37 @@ struct btrfs_ioctl_fs_info_args {
>  	__u64 reserved[122];			/* pad to 1k */
>  };
>  
> +/*
> + * feature flags
> + *
> + * Used by:
> + * struct btrfs_ioctl_feature_flags
> + */
> +#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
> +
> +#define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
> +#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
> +#define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
> +#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
> +/*
> + * some patches floated around with a second compression method
> + * lets save that incompat here for when they do get in
> + * Note we don't actually support it, we're just reserving the
> + * number
> + */
> +#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZOv2	(1ULL << 4)
> +
> +/*
> + * older kernels tried to do bigger metadata blocks, but the
> + * code was pretty buggy.  Lets not let them try anymore.
> + */
> +#define BTRFS_FEATURE_INCOMPAT_BIG_METADATA	(1ULL << 5)
> +
> +#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
> +#define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
> +#define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
> +#define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
> +
>  struct btrfs_ioctl_feature_flags {
>  	__u64 compat_flags;
>  	__u64 compat_ro_flags;
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
