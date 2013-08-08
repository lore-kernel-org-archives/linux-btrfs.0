Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46219 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3HHFWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 01:22:20 -0400
Date: Thu, 8 Aug 2013 13:22:12 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: fix possible memory leak in
 find_parent_nodes()
Message-ID: <20130808052211.GB644@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 01:04:17PM +0800, Wang Shilong wrote:
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

I think I know the whys :p, but still a log is preferred.

-liubo

> ---
>  fs/btrfs/backref.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index cb73a12..54e7610 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -911,7 +911,6 @@ again:
>  
>  	while (!list_empty(&prefs)) {
>  		ref = list_first_entry(&prefs, struct __prelim_ref, list);
> -		list_del(&ref->list);
>  		WARN_ON(ref->count < 0);
>  		if (ref->count && ref->root_id && ref->parent == 0) {
>  			/* no parent == root of tree */
> @@ -954,6 +953,7 @@ again:
>  				eie->next = ref->inode_list;
>  			}
>  		}
> +		list_del(&ref->list);
>  		kfree(ref);
>  	}
>  
> -- 
> 1.8.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
