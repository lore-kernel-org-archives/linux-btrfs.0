Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:57044 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3G2IXf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 04:23:35 -0400
Message-ID: <51F62686.7090800@jan-o-sch.net>
Date: Mon, 29 Jul 2013 10:23:34 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: fix crash regarding to ulist_add_merge
References: <1372394265-1959-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1372394265-1959-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, June 28, 2013 at 06:37 (+0200), Liu Bo wrote:
> Several users reported this crash of NULL pointer or general protection,
> the story is that we add a rbtree for speedup ulist iteration, and we
> use krealloc() to address ulist growth, and krealloc() use memcpy to copy
> old data to new memory area, so it's OK for an array as it doesn't use
> pointers while it's not OK for a rbtree as it uses pointers.
> 
> So krealloc() will mess up our rbtree and it ends up with crash.
> 
> Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v3: fix a return value problem(Thanks Wang Shilong).
> v2: fix an use-after-free bug and a finger error(Thanks Zach and Josef).
> 
>  fs/btrfs/ulist.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index 7b417e2..b0a523b2 100644
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
> @@ -224,6 +228,17 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
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
> +			if (ret < 0)
> +				return ret;
> +		}
>  	}
>  	ulist->nodes[ulist->nnodes].val = val;
>  	ulist->nodes[ulist->nnodes].aux = aux;
> 

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

Josef, how about sending this one for the next 3.11 rc and to 3.10 stable? Any
objections?

-Jan
