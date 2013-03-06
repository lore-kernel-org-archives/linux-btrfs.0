Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48318 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3CFAjN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2013 19:39:13 -0500
Date: Wed, 6 Mar 2013 08:37:34 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: improve the delayed inode throttling
Message-ID: <20130306003733.GB3151@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20130305154017.GF30680@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130305154017.GF30680@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 05, 2013 at 10:40:17AM -0500, Chris Mason wrote:
> Hi everyone,
> 
> While running fs_mark against raid5/6 I noticed the delayed inode
> insertions were creating a lot of latencies.  Reading through things, I
> think we need to move to a model where we fire off fewer work items and
> have the ones we do fire last longer.
> 
> With this commit our average file creation rates goes from 130K
> files/sec up to 160K files/sec for my big fs_mark run.
> 
> But before I toss it into git, I wanted to run it by everyone and see if
> there are workloads this doesn't fit well.
> 
> --
> 
> The delayed inode code batches up changes to the btree in hopes of doing
> them in bulk.  As the changes build up, processes kick off worker
> threads and wait for them to make progress.
> 
> The current code kicks off an async work queue item for each delayed
> node, which creates a lot of churn.  It also uses a fixed 1 HZ waiting
> period for the throttle, which allows us to build a lot of pending
> work and can slow down the commit.
> 
> This changes us to watch a sequence counter as it is bumped during the
> operations.  We kick off fewer work items and have each work item do
> more work.
> 
> Signed-off-by: Chris Mason <chris.mason@fusionio.com>
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 0b278b1..460d1a8 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -22,8 +22,8 @@
[...]  
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

Do we need a 'break' here?

Like

if (!signal_pending(current))
	schedule();
else
	break;

thanks,
liubo

> +		}
> +		finish_wait(&delayed_root->wait, &__wait);
>  	}
>  
> -	btrfs_wq_run_delayed_node(delayed_root, root, 0);
> +	btrfs_wq_run_delayed_node(delayed_root, root, 16);
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
