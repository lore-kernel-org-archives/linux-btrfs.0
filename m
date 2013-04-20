Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3DTRnP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 13:43:15 -0400
Message-ID: <5172D3B7.6080806@redhat.com>
Date: Sat, 20 Apr 2013 10:43:19 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make ulist_{init,fin}() static and not exported
 as symbol
References: <1366469023-10449-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1366469023-10449-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/20/13 7:43 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> ulist is a generic structure to iterate tree. we export them
> just in the hope it may be used by other modules. However, until
> now, it is just used by btrfs. The main point is that ulist_{init,fin}()
> should be only called by ulist_{alloc,reinit,free}().So we don't need
> to export them and make them staic will be best choice.

It actually seems like all EXPORT_SYMBOLS should be removed, no?
I can't imagine that btrfs needs to be exporting any of these
functions to any other module...

Thanks,
-Eric

> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ulist.c | 6 ++----
>  fs/btrfs/ulist.h | 2 --
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index ddc61ca..50fc1c4 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -48,13 +48,12 @@
>   * Note: don't use this function to init an already used ulist, use
>   * ulist_reinit instead.
>   */
> -void ulist_init(struct ulist *ulist)
> +static void ulist_init(struct ulist *ulist)
>  {
>  	ulist->nnodes = 0;
>  	ulist->nodes = ulist->int_nodes;
>  	ulist->nodes_alloced = ULIST_SIZE;
>  }
> -EXPORT_SYMBOL(ulist_init);
>  
>  /**
>   * ulist_fini - free up additionally allocated memory for the ulist
> @@ -63,7 +62,7 @@ EXPORT_SYMBOL(ulist_init);
>   * This is useful in cases where the base 'struct ulist' has been statically
>   * allocated.
>   */
> -void ulist_fini(struct ulist *ulist)
> +static void ulist_fini(struct ulist *ulist)
>  {
>  	/*
>  	 * The first ULIST_SIZE elements are stored inline in struct ulist.
> @@ -73,7 +72,6 @@ void ulist_fini(struct ulist *ulist)
>  		kfree(ulist->nodes);
>  	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
>  }
> -EXPORT_SYMBOL(ulist_fini);
>  
>  /**
>   * ulist_reinit - prepare a ulist for reuse
> diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
> index 21a1963..e05db47 100644
> --- a/fs/btrfs/ulist.h
> +++ b/fs/btrfs/ulist.h
> @@ -60,8 +60,6 @@ struct ulist {
>  	struct ulist_node int_nodes[ULIST_SIZE];
>  };
>  
> -void ulist_init(struct ulist *ulist);
> -void ulist_fini(struct ulist *ulist);
>  void ulist_reinit(struct ulist *ulist);
>  struct ulist *ulist_alloc(gfp_t gfp_mask);
>  void ulist_free(struct ulist *ulist);
> 

