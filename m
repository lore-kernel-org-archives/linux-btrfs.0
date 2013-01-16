Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50873 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3APMFy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 07:05:54 -0500
Date: Wed, 16 Jan 2013 20:03:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, Liu Bo <liub.liubo@gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix wrong max device number for single profile
Message-ID: <20130116120322.GA1989@liubo>
Reply-To: bo.li.liu@oracle.com
References: <50F68E95.6070901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F68E95.6070901@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 16, 2013 at 07:27:17PM +0800, Miao Xie wrote:
> The max device number of single profile is 1, not 0 (0 means 'as many as
> possible'). Fix it.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Cc: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 86279c3..7fa9773 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3496,7 +3496,7 @@ struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  	{ 1, 1, 2, 2, 2, 2 /* raid1 */ },
>  	{ 1, 2, 1, 1, 1, 2 /* dup */ },
>  	{ 1, 1, 0, 2, 1, 1 /* raid0 */ },
> -	{ 1, 1, 0, 1, 1, 1 /* single */ },
> +	{ 1, 1, 1, 1, 1, 1 /* single */ },
>  };
>  
>  static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
> -- 
> 1.7.11.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
