Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:31314 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754160AbcHXSZv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 14:25:51 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u7OIPQY7010383
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 18:25:27 GMT
Date: Wed, 24 Aug 2016 11:24:22 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix em leak in find_first_block_group
Message-ID: <20160824182421.GC1361@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1471548606-1433-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471548606-1433-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 18, 2016 at 03:30:06PM -0400, Josef Bacik wrote:
> We need to call free_extent_map() on the em we look up.Btrfs: fix em leak in
> find_first_block_group
> 
> We need to call free_extent_map() on the em we look up.

Thanks for fixing it.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 61b494e..20f9fa6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9906,6 +9906,7 @@ static int find_first_block_group(struct btrfs_root *root,
>  			} else {
>  				ret = 0;
>  			}
> +			free_extent_map(em);
>  			goto out;
>  		}
>  		path->slots[0]++;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
