Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31122 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaAMCb1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 21:31:27 -0500
Date: Mon, 13 Jan 2014 10:31:10 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: optimize to remove unnecessary removal with ulist
 reallocation
Message-ID: <20140113023109.GA26294@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1389360346-23842-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389360346-23842-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 10, 2014 at 09:25:46PM +0800, Wang Shilong wrote:
> Here we are not going to free memory, no need to remove every node
> one by one, just init root node here is ok.

Looks fine, but we need to make sure that it passes the regression test since you're
working on an old bug.

-liubo

> 
> Cc:  Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ulist.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index b0a523b2..35f5de9 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -207,9 +207,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
>  		void *old = NULL;
>  		int i;
>  
> -		for (i = 0; i < ulist->nnodes; i++)
> -			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
> -
>  		/*
>  		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
>  		 * yet, so pass NULL to krealloc
> @@ -234,6 +231,7 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
>  		 * pointers, so we have to do it ourselves.  Otherwise we may
>  		 * be bitten by crashes.
>  		 */
> +		ulist->root = RB_ROOT;
>  		for (i = 0; i < ulist->nnodes; i++) {
>  			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);
>  			if (ret < 0)
> -- 
> 1.8.3.1
> 
