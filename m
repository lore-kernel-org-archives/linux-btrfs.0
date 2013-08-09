Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:58905 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030587Ab3HII0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 04:26:01 -0400
Message-ID: <5204A798.7040909@jan-o-sch.net>
Date: Fri, 09 Aug 2013 10:26:00 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [patch v2 1/2] Btrfs: fix possible memory leak in find_parent_nodes()
References: <1376025936-21652-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1376025936-21652-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
On Fri, August 09, 2013 at 07:25 (+0200), Wang Shilong wrote:
> The origin code dealt with 'ref' as following steps:
> 	|->list_del(&ref-list)
> 		|->some operations
> 	|->kfree(ref)
> 
> If operations failed, it would goto label 'out' without freeing this 'ref'.
> and then memory leak would happen.Just move list_del() after kfree()
> will fix the problem.

Still not sufficient as an explanation. What is missing is the hint that in the
error handling code, we free everything that's left in the prefs list.

-Jan

> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> V1->V2: add explanations to changelog
> ---
>  fs/btrfs/backref.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 68048d6..7b55c95 100644
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
> @@ -956,6 +955,7 @@ again:
>  				eie->next = ref->inode_list;
>  			}
>  		}
> +		list_del(&ref->list);
>  		kfree(ref);
>  	}
>  
> 
