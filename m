Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65135 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab3CGBtk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Mar 2013 20:49:40 -0500
Message-ID: <5137EFD2.5060704@cn.fujitsu.com>
Date: Thu, 07 Mar 2013 09:39:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: improve the delayed inode throttling
References: <20130305154017.GF30680@shiny.masoncoding.com> <5136ADCE.9090405@cn.fujitsu.com> <20130306145328.GE6904@shiny.masoncoding.com>
In-Reply-To: <20130306145328.GE6904@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 6 Mar 2013 09:53:28 -0500, Chris Mason wrote:
[SNIP]
>  static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
> -				     struct btrfs_root *root, int all)
> +				     struct btrfs_root *root, int nr)
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
> +	if (nr)
> +		async_work->nr = 0;
> +	else
> +		async_work->nr = nr;

the code here is wrong.
the argument nr is the number we want to deal with, if it is 0, we will deal with all.
so
-	if (nr)
-		async_work->nr = 0;
-	else
-		async_work->nr = nr;
+	async_work->nr = nr;

>  
> +	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_work->work);
>  	return 0;
>  }
>  
> @@ -1424,30 +1431,55 @@ void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
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

here
-		ret = btrfs_wq_run_delayed_node(delayed_root, root, 1);
+		ret = btrfs_wq_run_delayed_node(delayed_root, root, 0);

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
> +			if (refs_newer(delayed_root, seq,
> +				       BTRFS_DELAYED_BATCH) ||
> +			    atomic_read(&delayed_root->items) <
> +			    BTRFS_DELAYED_BACKGROUND) {
> +				break;
> +			}
> +			if (!signal_pending(current))
> +				schedule();
> +			else
> +				break;
> +		}
> +		finish_wait(&delayed_root->wait, &__wait);
>  	}
>  
> -	btrfs_wq_run_delayed_node(delayed_root, root, 0);
> +	btrfs_wq_run_delayed_node(delayed_root, root, BTRFS_DELAYED_BATCH);
>  }

There is a problem that we may introduce lots of btrfs_works, we need avoid
it.

Thanks
Miao
