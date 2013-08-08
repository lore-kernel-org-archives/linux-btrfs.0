Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:37657 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965178Ab3HHLCc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 07:02:32 -0400
Message-ID: <52037AC6.70508@jan-o-sch.net>
Date: Thu, 08 Aug 2013 13:02:30 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: fix possible memory leak in find_parent_nodes()
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
On Thu, August 08, 2013 at 07:04 (+0200), Wang Shilong wrote:
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
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
> 

I'm not convinced, you're not calling kfree() more often. Can you please add
some patch description?

-Jan
