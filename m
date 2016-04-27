Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40591 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbcD0VJ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 17:09:57 -0400
Date: Wed, 27 Apr 2016 14:10:29 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/8] btrfs: uapi/linux/btrfs.h migration, move struct
 btrfs_ioctl_defrag_range_args
Message-ID: <20160427211029.GI15822@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
 <1459541670-4097-7-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459541670-4097-7-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:14:28PM -0400, Jeff Mahoney wrote:
> struct btrfs_ioctl_defrag_range_args is used by the BTRFS_IOC_DEFRAG_RANGE
> ioctl.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h           | 31 -------------------------------
>  include/uapi/linux/btrfs.h | 38 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 37 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 378482c..89f36b6 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1992,37 +1992,6 @@ struct btrfs_root {
>  	atomic_t qgroup_meta_rsv;
>  };
>  
> -struct btrfs_ioctl_defrag_range_args {
> -	/* start of the defrag operation */
> -	__u64 start;
> -
> -	/* number of bytes to defrag, use (u64)-1 to say all */
> -	__u64 len;
> -
> -	/*
> -	 * flags for the operation, which can include turning
> -	 * on compression for this one defrag
> -	 */
> -	__u64 flags;
> -
> -	/*
> -	 * any extent bigger than this will be considered
> -	 * already defragged.  Use 0 to take the kernel default
> -	 * Use 1 to say every single extent must be rewritten
> -	 */
> -	__u32 extent_thresh;
> -
> -	/*
> -	 * which compression method to use if turning on compression
> -	 * for this defrag operation.  If unspecified, zlib will
> -	 * be used
> -	 */
> -	__u32 compress_type;
> -
> -	/* spare for later */
> -	__u32 unused[4];
> -};
> -
>  
>  /*
>   * inode items have the data typically returned from stat and store other
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index abae362..98aff38 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -474,9 +474,45 @@ struct btrfs_ioctl_clone_range_args {
>    __u64 dest_offset;
>  };
>  
> -/* flags for the defrag range ioctl */
> +/*
> + * flags definition for the defrag range ioctl
> + *
> + * Used by:
> + * struct btrfs_ioctl_defrag_range_args.flags
> + */
>  #define BTRFS_DEFRAG_RANGE_COMPRESS 1
>  #define BTRFS_DEFRAG_RANGE_START_IO 2
> +struct btrfs_ioctl_defrag_range_args {
> +	/* start of the defrag operation */
> +	__u64 start;
> +
> +	/* number of bytes to defrag, use (u64)-1 to say all */
> +	__u64 len;
> +
> +	/*
> +	 * flags for the operation, which can include turning
> +	 * on compression for this one defrag
> +	 */
> +	__u64 flags;
> +
> +	/*
> +	 * any extent bigger than this will be considered
> +	 * already defragged.  Use 0 to take the kernel default
> +	 * Use 1 to say every single extent must be rewritten
> +	 */
> +	__u32 extent_thresh;
> +
> +	/*
> +	 * which compression method to use if turning on compression
> +	 * for this defrag operation.  If unspecified, zlib will
> +	 * be used
> +	 */
> +	__u32 compress_type;
> +
> +	/* spare for later */
> +	__u32 unused[4];
> +};
> +
>  
>  #define BTRFS_SAME_DATA_DIFFERS	1
>  /* For extent-same ioctl */
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
