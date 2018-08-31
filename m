Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34634 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727410AbeHaLsY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:48:24 -0400
Subject: Re: [PATCH 27/35] btrfs: handle delayed ref head accounting cleanup
 in abort
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-28-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0dda691d-96f1-3cd7-595e-e65075320360@suse.com>
Date: Fri, 31 Aug 2018 10:42:13 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-28-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We weren't doing any of the accounting cleanup when we aborted
> transactions.  Fix this by making cleanup_ref_head_accounting global and
> calling it from the abort code, this fixes the issue where our
> accounting was all wrong after the fs aborts.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.h       |  5 +++++
>  fs/btrfs/disk-io.c     |  1 +
>  fs/btrfs/extent-tree.c | 13 ++++++-------
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 791e287c2292..67923b2030b8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -35,6 +35,7 @@
>  struct btrfs_trans_handle;
>  struct btrfs_transaction;
>  struct btrfs_pending_snapshot;
> +struct btrfs_delayed_ref_root;
>  extern struct kmem_cache *btrfs_trans_handle_cachep;
>  extern struct kmem_cache *btrfs_bit_radix_cachep;
>  extern struct kmem_cache *btrfs_path_cachep;
> @@ -2624,6 +2625,10 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			   unsigned long count);
>  int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
>  				 unsigned long count, u64 transid, int wait);
> +void
> +btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
> +				  struct btrfs_delayed_ref_root *delayed_refs,
> +				  struct btrfs_delayed_ref_head *head);
>  int btrfs_lookup_data_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len);
>  int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
>  			     struct btrfs_fs_info *fs_info, u64 bytenr,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1d3f5731d616..caaca8154a1a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4240,6 +4240,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  		if (pin_bytes)
>  			btrfs_pin_extent(fs_info, head->bytenr,
>  					 head->num_bytes, 1);
> +		btrfs_cleanup_ref_head_accounting(fs_info, delayed_refs, head);
>  		btrfs_put_delayed_ref_head(head);
>  		cond_resched();
>  		spin_lock(&delayed_refs->lock);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 32579221d900..031d2b11ddee 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2466,12 +2466,11 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
>  	return ret ? ret : 1;
>  }
>  
> -static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> -					struct btrfs_delayed_ref_head *head)
> +void
> +btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
> +				  struct btrfs_delayed_ref_root *delayed_refs,
> +				  struct btrfs_delayed_ref_head *head)
>  {
I don't see any reason to change the signature of the function, the new
call sites have valid transaction handles where you can obtain
references to fs_info/delayed_refs. Just stick with adding btrfs_ prefix
and exporting it.

> -	struct btrfs_fs_info *fs_info = trans->fs_info;
> -	struct btrfs_delayed_ref_root *delayed_refs =
> -		&trans->transaction->delayed_refs;
>  	int nr_items = 1;
>  
>  	if (head->total_ref_mod < 0) {
> @@ -2549,7 +2548,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  		}
>  	}
>  
> -	cleanup_ref_head_accounting(trans, head);
> +	btrfs_cleanup_ref_head_accounting(fs_info, delayed_refs, head);
>  
>  	trace_run_delayed_ref_head(fs_info, head, 0);
>  	btrfs_delayed_ref_unlock(head);
> @@ -7191,7 +7190,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>  	if (head->must_insert_reserved)
>  		ret = 1;
>  
> -	cleanup_ref_head_accounting(trans, head);
> +	btrfs_cleanup_ref_head_accounting(trans->fs_info, delayed_refs, head);
>  	mutex_unlock(&head->mutex);
>  	btrfs_put_delayed_ref_head(head);
>  	return ret;
> 
