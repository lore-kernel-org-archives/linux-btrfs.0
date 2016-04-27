Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46100 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbcD0TWs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 15:22:48 -0400
Date: Wed, 27 Apr 2016 12:23:22 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/8] btrfs: uapi/linux/btrfs.h migration, move
 BTRFS_LABEL_SIZE
Message-ID: <20160427192322.GD15822@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
 <1459541670-4097-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459541670-4097-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:14:23PM -0400, Jeff Mahoney wrote:
> BTRFS_LABEL_SIZE is required to define the BTRFS_IOC_GET_FSLABEL and
> BTRFS_IOC_SET_FSLABEL ioctls.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h           | 1 -
>  include/uapi/linux/btrfs.h | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 84a6a5b..3beaa24 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -410,7 +410,6 @@ struct btrfs_header {
>   * room to translate 14 chunks with 3 stripes each.
>   */
>  #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
> -#define BTRFS_LABEL_SIZE 256
>  
>  /*
>   * just in case we somehow lose the roots and are not able to mount,
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index dea8931..11eee34 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -23,6 +23,7 @@
>  
>  #define BTRFS_IOCTL_MAGIC 0x94
>  #define BTRFS_VOL_NAME_MAX 255
> +#define BTRFS_LABEL_SIZE 256
>  
>  /* this should be 4k */
>  #define BTRFS_PATH_NAME_MAX 4087
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
