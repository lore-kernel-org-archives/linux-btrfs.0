Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48026 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbcD0U1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 16:27:03 -0400
Date: Wed, 27 Apr 2016 13:27:37 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/8] btrfs: uapi/linux/btrfs.h migration, document subvol
 flags
Message-ID: <20160427202737.GF15822@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
 <1459541670-4097-4-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459541670-4097-4-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:14:25PM -0400, Jeff Mahoney wrote:
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> ---
>  include/uapi/linux/btrfs.h | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9651af3..0316e23 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -34,9 +34,6 @@ struct btrfs_ioctl_vol_args {
>  
>  #define BTRFS_DEVICE_PATH_NAME_MAX 1024
>  
> -#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
> -#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
> -#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
>  #define BTRFS_FSID_SIZE 16
>  #define BTRFS_UUID_SIZE 16
>  #define BTRFS_UUID_UNPARSED_SIZE	37
> @@ -85,6 +82,20 @@ struct btrfs_ioctl_qgroup_limit_args {
>  	struct btrfs_qgroup_limit lim;
>  };
>  
> +/*
> + * flags for subvolumes
> + *
> + * Used by:
> + * struct btrfs_ioctl_vol_args_v2.flags
> + *
> + * BTRFS_SUBVOL_RDONLY is also provided/consumed by the following ioctls:
> + * - BTRFS_IOC_SUBVOL_GETFLAGS
> + * - BTRFS_IOC_SUBVOL_SETFLAGS
> + */
> +#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
> +#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
> +#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
> +
>  #define BTRFS_SUBVOL_NAME_MAX 4039
>  struct btrfs_ioctl_vol_args_v2 {
>  	__s64 fd;
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
