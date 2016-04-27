Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51390 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbcD0TXr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 15:23:47 -0400
Date: Wed, 27 Apr 2016 12:24:20 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/8] btrfs: uapi/linux/btrfs.h migration, qgroup limit
 flags
Message-ID: <20160427192420.GE15822@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
 <1459541670-4097-3-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459541670-4097-3-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:14:24PM -0400, Jeff Mahoney wrote:
> The BTRFS_QGROUP_LIMIT_* flags are required to tell the kernel which
> fields are valid when using the BTRFS_IOC_QGROUP_LIMIT ioctl.

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h           |  8 --------
>  include/uapi/linux/btrfs.h | 22 +++++++++++++++++++++-
>  2 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3beaa24..c228b39 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1154,14 +1154,6 @@ struct btrfs_qgroup_info_item {
>  	__le64 excl_cmpr;
>  } __attribute__ ((__packed__));
>  
> -/* flags definition for qgroup limits */
> -#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
> -#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
> -#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
> -#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
> -#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
> -#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
> -
>  struct btrfs_qgroup_limit_item {
>  	/*
>  	 * only updated when any of the other values change
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 11eee34..9651af3 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -41,7 +41,19 @@ struct btrfs_ioctl_vol_args {
>  #define BTRFS_UUID_SIZE 16
>  #define BTRFS_UUID_UNPARSED_SIZE	37
>  
> -#define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
> +/*
> + * flags definition for qgroup limits
> + *
> + * Used by:
> + * struct btrfs_qgroup_limit.flags
> + * struct btrfs_qgroup_limit_item.flags
> + */
> +#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
> +#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
> +#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
> +#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
> +#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
> +#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
>  
>  struct btrfs_qgroup_limit {
>  	__u64	flags;
> @@ -51,6 +63,14 @@ struct btrfs_qgroup_limit {
>  	__u64	rsv_excl;
>  };
>  
> +/*
> + * flags definition for qgroup inheritance
> + *
> + * Used by:
> + * struct btrfs_qgroup_inherit.flags
> + */
> +#define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
> +
>  struct btrfs_qgroup_inherit {
>  	__u64	flags;
>  	__u64	num_qgroups;
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
