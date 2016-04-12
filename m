Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35396 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbcDLRmd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 13:42:33 -0400
Date: Tue, 12 Apr 2016 10:43:13 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: track transid for delayed ref flushing
Message-ID: <20160412174312.GB3524@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1460410660-17430-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460410660-17430-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 11, 2016 at 05:37:40PM -0400, Josef Bacik wrote:
> Using the offwakecputime bpf script I noticed most of our time was spent waiting
> on the delayed ref throttling.  This is what is supposed to happen, but
> sometimes the transaction can commit and then we're waiting for throttling that
> doesn't matter anymore.  So change this stuff to be a little smarter by tracking
> the transid we were in when we initiated the throttling.  If the transaction we
> get is different then we can just bail out.  This resulted in a 50% speedup in
> my fs_mark test, and reduced the amount of time spent throttling by 60 seconds
> over the entire run (which is about 30 minutes).  Thanks,

Does the bpf script show where it's waiting on?  delayed_refs spinlock?

Maybe we can make it even smarter.

In __btrfs_end_transaction(), the only case it won't wait for running delayed refs
is when trans is JOIN_NOLOCK or ATTACH and "must_run_delayed_refs = 2".

In other cases, even we queue a work into helper worker to do async
delayed refs processing, __btrfs_end_transaction() still waits there.

Since it's a 50% speedup, it looks like at least 50% of __btrfs_end_transaction()
are waiting for other trans's queued delayed refs, can we do the check
a little bit earlier, in btrfs_async_run_delayed_refs()?

> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/extent-tree.c | 15 ++++++++++++---
>  fs/btrfs/inode.c       |  1 +
>  fs/btrfs/transaction.c |  3 ++-
>  4 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 55a24c5..4222936 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3505,7 +3505,7 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
>  int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root, unsigned long count);
>  int btrfs_async_run_delayed_refs(struct btrfs_root *root,
> -				 unsigned long count, int wait);
> +				 unsigned long count, u64 transid, int wait);
>  int btrfs_lookup_data_extent(struct btrfs_root *root, u64 start, u64 len);
>  int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root, u64 bytenr,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4b5a517..f23f426 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2839,6 +2839,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
>  
>  struct async_delayed_refs {
>  	struct btrfs_root *root;
> +	u64 transid;
>  	int count;
>  	int error;
>  	int sync;
> @@ -2854,9 +2855,16 @@ static void delayed_ref_async_start(struct btrfs_work *work)
>  
>  	async = container_of(work, struct async_delayed_refs, work);
>  
> -	trans = btrfs_join_transaction(async->root);
> +	trans = btrfs_attach_transaction(async->root);
>  	if (IS_ERR(trans)) {
> -		async->error = PTR_ERR(trans);
> +		if (PTR_ERR(trans) != -ENOENT)
> +			async->error = PTR_ERR(trans);
> +		goto done;
> +	}
> +
> +	/* Don't bother flushing if we got into a different transaction */
> +	if (trans->transid != async->transid) {
> +		btrfs_end_transaction(trans, async->root);

Interesting, btrfs_end_transaction will also issue a work to do 
delayed_ref_async_start, and it doesn't wait.

Thanks,

-liubo

>  		goto done;
>  	}
>  
> @@ -2880,7 +2888,7 @@ done:
>  }
>  
>  int btrfs_async_run_delayed_refs(struct btrfs_root *root,
> -				 unsigned long count, int wait)
> +				 unsigned long count, u64 transid, int wait)
>  {
>  	struct async_delayed_refs *async;
>  	int ret;
> @@ -2892,6 +2900,7 @@ int btrfs_async_run_delayed_refs(struct btrfs_root *root,
>  	async->root = root->fs_info->tree_root;
>  	async->count = count;
>  	async->error = 0;
> +	async->transid = transid;
>  	if (wait)
>  		async->sync = 1;
>  	else
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 723e4bb..e6dd4cc 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4534,6 +4534,7 @@ delete:
>  			BUG_ON(ret);
>  			if (btrfs_should_throttle_delayed_refs(trans, root))
>  				btrfs_async_run_delayed_refs(root,
> +							     trans->transid,
>  					trans->delayed_ref_updates * 2, 0);
>  			if (be_nice) {
>  				if (truncate_space_check(trans, root,
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 43885e5..7c7671d 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -817,6 +817,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  {
>  	struct btrfs_transaction *cur_trans = trans->transaction;
>  	struct btrfs_fs_info *info = root->fs_info;
> +	u64 transid = trans->transid;
>  	unsigned long cur = trans->delayed_ref_updates;
>  	int lock = (trans->type != TRANS_JOIN_NOLOCK);
>  	int err = 0;
> @@ -904,7 +905,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  
>  	kmem_cache_free(btrfs_trans_handle_cachep, trans);
>  	if (must_run_delayed_refs) {
> -		btrfs_async_run_delayed_refs(root, cur,
> +		btrfs_async_run_delayed_refs(root, cur, transid,
>  					     must_run_delayed_refs == 1);
>  	}
>  	return err;
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
