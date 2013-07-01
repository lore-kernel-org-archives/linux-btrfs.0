Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40208 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3GAP0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 11:26:14 -0400
Received: by mail-pd0-f179.google.com with SMTP id q10so2713247pdj.24
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 08:26:13 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC PATCH] Btrfs: rework ulist with list operation
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1372688084-18255-1-git-send-email-bo.li.liu@oracle.com>
Date: Mon, 1 Jul 2013 23:26:08 +0800
Cc: linux-btrfs@vger.kernel.org, Zach Brown <zab@redhat.com>
Message-Id: <91C10D64-F29F-43E5-AC00-E5335248D3F0@gmail.com>
References: <1372688084-18255-1-git-send-email-bo.li.liu@oracle.com>
To: Liu Bo <bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Liu,

> This is actually from Zach Brown's idea.
> 
> Instead of ulist of array+rbtree, here we introduce ulist of list+rbtree,
> memory is dynamic allocation and we can get rid of memory re-allocation dance
> and special care for rbtree node's insert/delete for inline array, so it's
> straightforward and simple.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> fs/btrfs/ctree.h |    1 +
> fs/btrfs/super.c |    9 +++++-
> fs/btrfs/ulist.c |   85 ++++++++++++++++++++++++++++++-----------------------
> fs/btrfs/ulist.h |   21 +++----------
> 4 files changed, 62 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index d6dd49b..2fa73fc 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -35,6 +35,7 @@
> #include "extent_io.h"
> #include "extent_map.h"
> #include "async-thread.h"
> +#include "ulist.h"
> 
> struct btrfs_trans_handle;
> struct btrfs_transaction;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f0857e0..04ffee5 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1723,10 +1723,14 @@ static int __init init_btrfs_fs(void)
> 	if (err)
> 		goto free_auto_defrag;
> 
> -	err = btrfs_interface_init();
> +	err = ulist_node_slab_init();
> 	if (err)
> 		goto free_delayed_ref;
> 
> +	err = btrfs_interface_init();
> +	if (err)
> +		goto free_ulist_node_slab;
> +
> 	err = register_filesystem(&btrfs_fs_type);
> 	if (err)
> 		goto unregister_ioctl;
> @@ -1742,6 +1746,8 @@ static int __init init_btrfs_fs(void)
> 
> unregister_ioctl:
> 	btrfs_interface_exit();
> +free_ulist_node_slab:
> +	ulist_node_slab_exit();
> free_delayed_ref:
> 	btrfs_delayed_ref_exit();
> free_auto_defrag:
> @@ -1764,6 +1770,7 @@ free_compress:
> 
> static void __exit exit_btrfs_fs(void)
> {
> +	ulist_node_slab_exit();
> 	btrfs_destroy_cachep();
> 	btrfs_delayed_ref_exit();
> 	btrfs_auto_defrag_exit();
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index 7b417e2..d1698b2 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -41,6 +41,24 @@
>  * loop would be similar to the above.
>  */
> 
> +static struct kmem_cache *ulist_node_cache;
> +
> +int __init ulist_node_slab_init(void)
> +{
> +	ulist_node_cache = kmem_cache_create("btrfs_ulist_cache",
> +				sizeof(struct ulist_node), 0,
> +				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
> +	if (!ulist_node_cache)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +void ulist_node_slab_exit(void)
> +{
> +	if (ulist_node_cache)
> +		kmem_cache_destroy(ulist_node_cache);
> +}
> +
> /**
>  * ulist_init - freshly initialize a ulist
>  * @ulist:	the ulist to initialize
> @@ -51,8 +69,8 @@
> void ulist_init(struct ulist *ulist)
> {
> 	ulist->nnodes = 0;
> -	ulist->nodes = ulist->int_nodes;
> -	ulist->nodes_alloced = ULIST_SIZE;
> +	INIT_LIST_HEAD(&ulist->nodes);
> +	ulist->cur_node = NULL;
> 	ulist->root = RB_ROOT;
> }
> EXPORT_SYMBOL(ulist_init);
> @@ -66,14 +84,13 @@ EXPORT_SYMBOL(ulist_init);
>  */
> void ulist_fini(struct ulist *ulist)
> {
> -	/*
> -	 * The first ULIST_SIZE elements are stored inline in struct ulist.
> -	 * Only if more elements are alocated they need to be freed.
> -	 */
> -	if (ulist->nodes_alloced > ULIST_SIZE)
> -		kfree(ulist->nodes);
> -	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
> -	ulist->root = RB_ROOT;
> +	struct ulist_node *node;
> +
> +	while (!list_empty(&ulist->nodes)) {
> +		node = list_entry(ulist->nodes.next, struct ulist_node, list);
> +		list_del_init(&node->list);
> +		kmem_cache_free(ulist_node_cache, node);
> +	}
> }

I think we don't need to free all the memory in ulist_fini(), we can keep those memory allocated
by introducing a var nodes_allocated(like before). So in ulit_fini(), we reset cur_list and nnodes(list is keeped)

In  ulist_add_merge(), we compare nnodes  with nodes_allocated. and only allocate memory if needed.

In fact, this gives some benefit especially in qgroup accounting's reworking qgroup tree where we can totally
reuse memory allocated before!

What do you think of this? Am i missing something ^_^.

Thanks,
Wang

> EXPORT_SYMBOL(ulist_fini);
> 
> @@ -201,34 +218,17 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
> 		return 0;
> 	}
> 
> -	if (ulist->nnodes >= ulist->nodes_alloced) {
> -		u64 new_alloced = ulist->nodes_alloced + 128;
> -		struct ulist_node *new_nodes;
> -		void *old = NULL;
> -
> -		/*
> -		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
> -		 * yet, so pass NULL to krealloc
> -		 */
> -		if (ulist->nodes_alloced > ULIST_SIZE)
> -			old = ulist->nodes;
> +	/* we need to make a new one */
> +	node = kmem_cache_alloc(ulist_node_cache, gfp_mask);
> +	if (!node)
> +		return -ENOMEM;
> 
> -		new_nodes = krealloc(old, sizeof(*new_nodes) * new_alloced,
> -				     gfp_mask);
> -		if (!new_nodes)
> -			return -ENOMEM;
> +	node->val = val;
> +	node->aux = aux;
> +	ret = ulist_rbtree_insert(ulist, node);
> +	BUG_ON(ret); /* just checked EEXIST above */
> 
> -		if (!old)
> -			memcpy(new_nodes, ulist->int_nodes,
> -			       sizeof(ulist->int_nodes));
> -
> -		ulist->nodes = new_nodes;
> -		ulist->nodes_alloced = new_alloced;
> -	}
> -	ulist->nodes[ulist->nnodes].val = val;
> -	ulist->nodes[ulist->nnodes].aux = aux;
> -	ret = ulist_rbtree_insert(ulist, &ulist->nodes[ulist->nnodes]);
> -	BUG_ON(ret);
> +	list_add_tail(&node->list, &ulist->nodes);
> 	++ulist->nnodes;
> 
> 	return 1;
> @@ -253,11 +253,22 @@ EXPORT_SYMBOL(ulist_add);
>  */
> struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
> {
> +	struct list_head *next;
> +	struct ulist_node *node;
> +
> 	if (ulist->nnodes == 0)
> 		return NULL;
> 	if (uiter->i < 0 || uiter->i >= ulist->nnodes)
> 		return NULL;
> 
> -	return &ulist->nodes[uiter->i++];
> +	if (uiter->i == 0)
> +		next = ulist->nodes.next;
> +	else
> +		next = ulist->cur_node->next;
> +
> +	node = list_entry(next, struct ulist_node, list);
> +	ulist->cur_node = next;
> +	uiter->i++;
> +	return node;
> }
> EXPORT_SYMBOL(ulist_next);
> diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
> index fb36731..619490d 100644
> --- a/fs/btrfs/ulist.h
> +++ b/fs/btrfs/ulist.h
> @@ -37,6 +37,7 @@ struct ulist_iterator {
> struct ulist_node {
> 	u64 val;		/* value to store */
> 	u64 aux;		/* auxiliary value saved along with the val */
> +	struct list_head list; /* linked in ulist->nodes */
> 	struct rb_node rb_node;	/* used to speed up search */
> };
> 
> @@ -46,24 +47,10 @@ struct ulist {
> 	 */
> 	unsigned long nnodes;
> 
> -	/*
> -	 * number of nodes we already have room for
> -	 */
> -	unsigned long nodes_alloced;
> -
> -	/*
> -	 * pointer to the array storing the elements. The first ULIST_SIZE
> -	 * elements are stored inline. In this case the it points to int_nodes.
> -	 * After exceeding ULIST_SIZE, dynamic memory is allocated.
> -	 */
> -	struct ulist_node *nodes;
> +	struct list_head nodes;
> +	struct list_head *cur_node;
> 
> 	struct rb_root root;
> -
> -	/*
> -	 * inline storage space for the first ULIST_SIZE entries
> -	 */
> -	struct ulist_node int_nodes[ULIST_SIZE];
> };
> 
> void ulist_init(struct ulist *ulist);
> @@ -76,6 +63,8 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
> 		    u64 *old_aux, gfp_t gfp_mask);
> struct ulist_node *ulist_next(struct ulist *ulist,
> 			      struct ulist_iterator *uiter);
> +int __init ulist_node_slab_init(void);
> +void ulist_node_slab_exit(void);
> 
> #define ULIST_ITER_INIT(uiter) ((uiter)->i = 0)
> 
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

