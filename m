Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18633 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3F1D11 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 23:27:27 -0400
Message-ID: <51CD02E7.8070608@cn.fujitsu.com>
Date: Fri, 28 Jun 2013 11:28:39 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix crash regarding to ulist_add_merge
References: <1372386339-32599-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1372386339-32599-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

> Several users reported this crash of NULL pointer or general protection,
> the story is that we add a rbtree for speedup ulist iteration, and we
> use krealloc() to address ulist growth, and krealloc() use memcpy to copy
> old data to new memory area, so it's OK for an array as it doesn't use
> pointers while it's not OK for a rbtree as it uses pointers.
> 
> So krealloc() will mess up our rbtree and it ends up with crash.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: fix an use-after-free bug and a finger error(Thanks Zach and Josef).
> 
>  fs/btrfs/ulist.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index 7b417e2..adc9aac 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -205,6 +205,10 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
>  		u64 new_alloced = ulist->nodes_alloced + 128;
>  		struct ulist_node *new_nodes;
>  		void *old = NULL;
> +		int i;
> +
> +		for (i = 0; i < ulist->nnodes; i++)
> +			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
>  
>  		/*
>  		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
> @@ -224,6 +228,19 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
>  
>  		ulist->nodes = new_nodes;
>  		ulist->nodes_alloced = new_alloced;
> +
> +		/*
> +		 * krealloc actually uses memcpy, which does not copy rb_node
> +		 * pointers, so we have to do it ourselves.  Otherwise we may
> +		 * be bitten by crashes.
> +		 */
> +		for (i = 0; i < ulist->nnodes; i++) {
> +			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);


ulist_rbtree_insert() don't allocate memory. if ret!=0 here means a logic error happens.
In this case, BUG_ON() should be triggered.

> +			if (ret) {



Another thing is if you want to free ulist memory, you can call ulist_free(). Calling kfree()
directly here is wrong.

By the way, i notice in ulist_add_merge() we have a possible memory leak:
if krealloc() fails, we return -ENOMEM directly, this is wrong. ulist_free(ulist) should be called.
You can fold this into your this patch.

Otherwise, thanks very much for fixing this issue!

Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Thanks,
Wang

> +				kfree(new_nodes);
> +				return -ENOMEM;
> +			}
> +		}
>  	}
>  	ulist->nodes[ulist->nnodes].val = val;
>  	ulist->nodes[ulist->nnodes].aux = aux;






