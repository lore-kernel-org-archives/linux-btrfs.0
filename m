Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39886 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3CFCoj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Mar 2013 21:44:39 -0500
Message-ID: <5136ADCE.9090405@cn.fujitsu.com>
Date: Wed, 06 Mar 2013 10:45:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: improve the delayed inode throttling
References: <20130305154017.GF30680@shiny.masoncoding.com>
In-Reply-To: <20130305154017.GF30680@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 5 Mar 2013 10:40:17 -0500, Chris Mason wrote:
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 0b278b1..460d1a8 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -22,8 +22,8 @@
>  #include "disk-io.h"
>  #include "transaction.h"
>  
> -#define BTRFS_DELAYED_WRITEBACK		400
> -#define BTRFS_DELAYED_BACKGROUND	100
> +#define BTRFS_DELAYED_WRITEBACK		512
> +#define BTRFS_DELAYED_BACKGROUND	128
>  
>  static struct kmem_cache *delayed_node_cache;
>  
> @@ -494,6 +494,15 @@ static int __btrfs_add_delayed_deletion_item(struct btrfs_delayed_node *node,
>  					BTRFS_DELAYED_DELETION_ITEM);
>  }
>  
> +static void finish_one_item(struct btrfs_delayed_root *delayed_root)
> +{
> +	int seq = atomic_inc_return(&delayed_root->items_seq);
> +	if ((atomic_dec_return(&delayed_root->items) <
> +	    BTRFS_DELAYED_BACKGROUND || seq % 16 == 0) &&
> +	    waitqueue_active(&delayed_root->wait))
> +		wake_up(&delayed_root->wait);
> +}
> +
>  static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
>  {
>  	struct rb_root *root;
> @@ -512,10 +521,8 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
>  
>  	rb_erase(&delayed_item->rb_node, root);
>  	delayed_item->delayed_node->count--;
> -	if (atomic_dec_return(&delayed_root->items) <
> -	    BTRFS_DELAYED_BACKGROUND &&
> -	    waitqueue_active(&delayed_root->wait))
> -		wake_up(&delayed_root->wait);
> +
> +	finish_one_item(delayed_root);
>  }
>  
>  static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
> @@ -1056,10 +1063,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
>  		delayed_node->count--;
>  
>  		delayed_root = delayed_node->root->fs_info->delayed_root;
> -		if (atomic_dec_return(&delayed_root->items) <
> -		    BTRFS_DELAYED_BACKGROUND &&
> -		    waitqueue_active(&delayed_root->wait))
> -			wake_up(&delayed_root->wait);
> +		finish_one_item(delayed_root);
>  	}
>  }
>  
> @@ -1304,35 +1308,55 @@ void btrfs_remove_delayed_node(struct inode *inode)
>  	btrfs_release_delayed_node(delayed_node);
>  }
>  
> +#if 0
>  struct btrfs_async_delayed_node {
>  	struct btrfs_root *root;
>  	struct btrfs_delayed_node *delayed_node;
>  	struct btrfs_work work;
>  };
> +#endif
> +
> +struct btrfs_async_delayed_work {
> +	struct btrfs_delayed_root *delayed_root;
> +	int nr;
> +	struct btrfs_work work;
> +};
>  
> -static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
> +static void btrfs_async_run_delayed_root(struct btrfs_work *work)
>  {
> -	struct btrfs_async_delayed_node *async_node;
> +	struct btrfs_async_delayed_work *async_work;
> +	struct btrfs_delayed_root *delayed_root;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_path *path;
>  	struct btrfs_delayed_node *delayed_node = NULL;
>  	struct btrfs_root *root;
>  	struct btrfs_block_rsv *block_rsv;
>  	int need_requeue = 0;
> +	int total_done = 0;
>  
> -	async_node = container_of(work, struct btrfs_async_delayed_node, work);
> +	async_work = container_of(work, struct btrfs_async_delayed_work, work);
> +	delayed_root = async_work->delayed_root;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		goto out;
> -	path->leave_spinning = 1;
>  
> -	delayed_node = async_node->delayed_node;
> +again:
> +	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND / 2)
> +		goto free_path;
> +
> +	delayed_node = btrfs_first_prepared_delayed_node(delayed_root);
> +	if (!delayed_node)
> +		goto free_path;
> +
> +requeue:
> +	path->leave_spinning = 1;
> +	need_requeue = 0;
>  	root = delayed_node->root;
>  
>  	trans = btrfs_join_transaction(root);
>  	if (IS_ERR(trans))
> -		goto free_path;
> +		goto release_path;
>  
>  	block_rsv = trans->block_rsv;
>  	trans->block_rsv = &root->fs_info->delayed_block_rsv;
> @@ -1373,47 +1397,48 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
>  	trans->block_rsv = block_rsv;
>  	btrfs_end_transaction_dmeta(trans, root);
>  	btrfs_btree_balance_dirty_nodelay(root);
> +
> +release_path:
> +	btrfs_release_path(path);
> +	total_done++;
> +
> +	if (need_requeue) {
> +		goto requeue;

We re-queue the node just when there are some delayed items in the current node.
But if the node still has delayed items after we deal with it, that is to say
someone is accessing the node. So it is better to release it and deal with it
later. In this way, we can amass more items and deal with them in batches.

> +	} else {
> +		btrfs_release_prepared_delayed_node(delayed_node);
> +		if (async_work->nr == 0 || total_done < async_work->nr)
> +			goto again;

If joining transaction fails, we should end the async handle. And for case
->nr == 0 (it means there are too many items, we need flush all), we can
set ->blocked of the current transaction, in this way, the users can not
insert any delayed item for a while, and will wait until the current
transation is committed 

> +	}
> +
>  free_path:
>  	btrfs_free_path(path);
>  out:
> -	if (need_requeue)
> -		btrfs_requeue_work(&async_node->work);
> -	else {
> -		btrfs_release_prepared_delayed_node(delayed_node);
> -		kfree(async_node);
> -	}
> +	wake_up(&delayed_root->wait);
> +	kfree(async_work);
>  }
>  
> +
>  static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
>  				     struct btrfs_root *root, int all)
>  {
> -	struct btrfs_async_delayed_node *async_node;
> -	struct btrfs_delayed_node *curr;
> -	int count = 0;
> +	struct btrfs_async_delayed_work *async_work;
>  
> -again:
> -	curr = btrfs_first_prepared_delayed_node(delayed_root);
> -	if (!curr)
> +	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
>  		return 0;
>  
> -	async_node = kmalloc(sizeof(*async_node), GFP_NOFS);
> -	if (!async_node) {
> -		btrfs_release_prepared_delayed_node(curr);
> +	async_work = kmalloc(sizeof(*async_work), GFP_NOFS);
> +	if (!async_work)
>  		return -ENOMEM;
> -	}
> -
> -	async_node->root = root;
> -	async_node->delayed_node = curr;
> -
> -	async_node->work.func = btrfs_async_run_delayed_node_done;
> -	async_node->work.flags = 0;
> -
> -	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_node->work);
> -	count++;
>  
> -	if (all || count < 4)
> -		goto again;
> +	async_work->delayed_root = delayed_root;
> +	async_work->work.func = btrfs_async_run_delayed_root;
> +	async_work->work.flags = 0;
> +	if (all)
> +		async_work->nr = 0;
> +	else
> +		async_work->nr = 16;
>  
> +	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_work->work);
>  	return 0;
>  }
>  
> @@ -1424,30 +1449,52 @@ void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
>  	WARN_ON(btrfs_first_delayed_node(delayed_root));
>  }
>  
> +static int refs_newer(struct btrfs_delayed_root *delayed_root,
> +		      int seq, int count)
> +{
> +	int val = atomic_read(&delayed_root->items_seq);
> +
> +	if (val < seq || val >= seq + count)
> +		return 1;
> +	return 0;
> +}
> +
>  void btrfs_balance_delayed_items(struct btrfs_root *root)
>  {
>  	struct btrfs_delayed_root *delayed_root;
> +	int seq;
>  
>  	delayed_root = btrfs_get_delayed_root(root);
>  
>  	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
>  		return;
>  
> +	seq = atomic_read(&delayed_root->items_seq);
> +
>  	if (atomic_read(&delayed_root->items) >= BTRFS_DELAYED_WRITEBACK) {
>  		int ret;
> +		DEFINE_WAIT(__wait);
> +
>  		ret = btrfs_wq_run_delayed_node(delayed_root, root, 1);
>  		if (ret)
>  			return;
>  
> -		wait_event_interruptible_timeout(
> -				delayed_root->wait,
> -				(atomic_read(&delayed_root->items) <
> -				 BTRFS_DELAYED_BACKGROUND),
> -				HZ);
> -		return;
> +		while (1) {
> +			prepare_to_wait(&delayed_root->wait, &__wait,
> +					TASK_INTERRUPTIBLE);
> +
> +			if (refs_newer(delayed_root, seq, 16) ||
> +			    atomic_read(&delayed_root->items) <
> +			    BTRFS_DELAYED_BACKGROUND) {
> +				break;
> +			}
> +			if (!signal_pending(current))
> +				schedule();
> +		}
> +		finish_wait(&delayed_root->wait, &__wait);
>  	}
>  
> -	btrfs_wq_run_delayed_node(delayed_root, root, 0);
> +	btrfs_wq_run_delayed_node(delayed_root, root, 16);

The last argument is a bool variant, it shoud be 0 here.

Thanks
Miao

>  }
>  
>  /* Will return 0 or -ENOMEM */
> diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> index 78b6ad0..1d5c5f7 100644
> --- a/fs/btrfs/delayed-inode.h
> +++ b/fs/btrfs/delayed-inode.h
> @@ -43,6 +43,7 @@ struct btrfs_delayed_root {
>  	 */
>  	struct list_head prepare_list;
>  	atomic_t items;		/* for delayed items */
> +	atomic_t items_seq;	/* for delayed items */
>  	int nodes;		/* for delayed nodes */
>  	wait_queue_head_t wait;
>  };
> @@ -86,6 +87,7 @@ static inline void btrfs_init_delayed_root(
>  				struct btrfs_delayed_root *delayed_root)
>  {
>  	atomic_set(&delayed_root->items, 0);
> +	atomic_set(&delayed_root->items_seq, 0);
>  	delayed_root->nodes = 0;
>  	spin_lock_init(&delayed_root->lock);
>  	init_waitqueue_head(&delayed_root->wait);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

