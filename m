Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52442 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2HBKqt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 06:46:49 -0400
Received: by obbuo13 with SMTP id uo13so13660487obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 03:46:49 -0700 (PDT)
Message-ID: <501A5A94.7070307@gmail.com>
Date: Thu, 02 Aug 2012 18:46:44 +0800
From: Liu Bo <liub.liubo@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: barrier before waitqueue_active
References: <1343852708-24009-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1343852708-24009-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2012 04:25 AM, Josef Bacik wrote:
> We need an smb_mb() before waitqueue_active to avoid missing wakeups.
> Before Mitch was hitting a deadlock between the ordered flushers and the
> transaction commit because the ordered flushers were waiting for more refs
> and were never woken up, so those smp_mb()'s are the most important.
> Everything else I added for correctness sake and to avoid getting bitten by
> this again somewhere else.  Thanks,
> 

Hi Josef,

I'll appreciate a lot if you can add some comments for each memory
barrier, because not everyone knows why it is used here and there. :)

thanks,
liubo

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/compression.c   |    1 +
>  fs/btrfs/delayed-inode.c |   16 ++++++++++------
>  fs/btrfs/delayed-ref.c   |   18 ++++++++++++------
>  fs/btrfs/disk-io.c       |   11 ++++++++---
>  fs/btrfs/inode.c         |    8 +++++---
>  fs/btrfs/volumes.c       |    8 +++++---
>  6 files changed, 41 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 86eff48..43d1c5a 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -818,6 +818,7 @@ static void free_workspace(int type, struct list_head *workspace)
>  	btrfs_compress_op[idx]->free_workspace(workspace);
>  	atomic_dec(alloc_workspace);
>  wake:
> +	smp_mb();
>  	if (waitqueue_active(workspace_wait))
>  		wake_up(workspace_wait);
>  }
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 335605c..8cc9b19 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -513,9 +513,11 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
>  	rb_erase(&delayed_item->rb_node, root);
>  	delayed_item->delayed_node->count--;
>  	atomic_dec(&delayed_root->items);
> -	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND &&
> -	    waitqueue_active(&delayed_root->wait))
> -		wake_up(&delayed_root->wait);
> +	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND) {
> +		smp_mb();
> +		if (waitqueue_active(&delayed_root->wait))
> +			wake_up(&delayed_root->wait);
> +	}
>  }
>  
>  static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
> @@ -1057,9 +1059,11 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
>  		delayed_root = delayed_node->root->fs_info->delayed_root;
>  		atomic_dec(&delayed_root->items);
>  		if (atomic_read(&delayed_root->items) <
> -		    BTRFS_DELAYED_BACKGROUND &&
> -		    waitqueue_active(&delayed_root->wait))
> -			wake_up(&delayed_root->wait);
> +		    BTRFS_DELAYED_BACKGROUND) {
> +			smp_mb();
> +			if (waitqueue_active(&delayed_root->wait))
> +				wake_up(&delayed_root->wait);
> +		}
>  	}
>  }
>  
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index da7419e..858ef02 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -662,9 +662,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>  	add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
>  				   num_bytes, parent, ref_root, level, action,
>  				   for_cow);
> -	if (!need_ref_seq(for_cow, ref_root) &&
> -	    waitqueue_active(&fs_info->tree_mod_seq_wait))
> -		wake_up(&fs_info->tree_mod_seq_wait);
> +	if (!need_ref_seq(for_cow, ref_root)) {
> +		smp_mb();
> +		if (waitqueue_active(&fs_info->tree_mod_seq_wait))
> +			wake_up(&fs_info->tree_mod_seq_wait);
> +	}
> +
>  	spin_unlock(&delayed_refs->lock);
>  	if (need_ref_seq(for_cow, ref_root))
>  		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
> @@ -713,9 +716,11 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  	add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
>  				   num_bytes, parent, ref_root, owner, offset,
>  				   action, for_cow);
> -	if (!need_ref_seq(for_cow, ref_root) &&
> -	    waitqueue_active(&fs_info->tree_mod_seq_wait))
> -		wake_up(&fs_info->tree_mod_seq_wait);
> +	if (!need_ref_seq(for_cow, ref_root)) {
> +		smp_mb();
> +		if (waitqueue_active(&fs_info->tree_mod_seq_wait))
> +			wake_up(&fs_info->tree_mod_seq_wait);
> +	}
>  	spin_unlock(&delayed_refs->lock);
>  	if (need_ref_seq(for_cow, ref_root))
>  		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
> @@ -744,6 +749,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>  				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
>  				   extent_op->is_data);
>  
> +	smp_mb();
>  	if (waitqueue_active(&fs_info->tree_mod_seq_wait))
>  		wake_up(&fs_info->tree_mod_seq_wait);
>  	spin_unlock(&delayed_refs->lock);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 502b20c..a355c89 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -756,9 +756,11 @@ static void run_one_async_done(struct btrfs_work *work)
>  
>  	atomic_dec(&fs_info->nr_async_submits);
>  
> -	if (atomic_read(&fs_info->nr_async_submits) < limit &&
> -	    waitqueue_active(&fs_info->async_submit_wait))
> -		wake_up(&fs_info->async_submit_wait);
> +	if (atomic_read(&fs_info->nr_async_submits) < limit) {
> +		smp_mb();
> +		if (waitqueue_active(&fs_info->async_submit_wait))
> +			wake_up(&fs_info->async_submit_wait);
> +	}
>  
>  	/* If an error occured we just want to clean up the bio and move on */
>  	if (async->error) {
> @@ -3785,14 +3787,17 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
>  		/* FIXME: cleanup wait for commit */
>  		t->in_commit = 1;
>  		t->blocked = 1;
> +		smp_mb();
>  		if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
>  			wake_up(&root->fs_info->transaction_blocked_wait);
>  
>  		t->blocked = 0;
> +		smp_mb();
>  		if (waitqueue_active(&root->fs_info->transaction_wait))
>  			wake_up(&root->fs_info->transaction_wait);
>  
>  		t->commit_done = 1;
> +		smp_mb();
>  		if (waitqueue_active(&t->commit_wait))
>  			wake_up(&t->commit_wait);
>  
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4b82ae2..acea7d9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1010,9 +1010,11 @@ static noinline void async_cow_submit(struct btrfs_work *work)
>  	atomic_sub(nr_pages, &root->fs_info->async_delalloc_pages);
>  
>  	if (atomic_read(&root->fs_info->async_delalloc_pages) <
> -	    5 * 1024 * 1024 &&
> -	    waitqueue_active(&root->fs_info->async_submit_wait))
> -		wake_up(&root->fs_info->async_submit_wait);
> +	    5 * 1024 * 1024) {
> +		smp_mb();
> +		if (waitqueue_active(&root->fs_info->async_submit_wait))
> +			wake_up(&root->fs_info->async_submit_wait);
> +	}
>  
>  	if (async_cow->inode)
>  		submit_compressed_extents(async_cow->inode, async_cow);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b8708f9..871f43f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -229,9 +229,11 @@ loop_lock:
>  		cur->bi_next = NULL;
>  		atomic_dec(&fs_info->nr_async_bios);
>  
> -		if (atomic_read(&fs_info->nr_async_bios) < limit &&
> -		    waitqueue_active(&fs_info->async_submit_wait))
> -			wake_up(&fs_info->async_submit_wait);
> +		if (atomic_read(&fs_info->nr_async_bios) < limit) {
> +			smp_mb();
> +			if (waitqueue_active(&fs_info->async_submit_wait))
> +				wake_up(&fs_info->async_submit_wait);
> +		}
>  
>  		BUG_ON(atomic_read(&cur->bi_cnt) == 0);
>  
> 

