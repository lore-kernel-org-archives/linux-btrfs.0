Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33086 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbeILDxx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:53:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id s7-v6so12992994pgc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 15:52:24 -0700 (PDT)
Date: Tue, 11 Sep 2018 15:52:22 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 01/36] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20180911225222.GB26631@vader>
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-2-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911175807.26181-2-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 01:57:32PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We do this dance in cleanup_ref_head and check_ref_cleanup, unify it
> into a helper and cleanup the calling functions.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/delayed-ref.c | 14 ++++++++++++++
>  fs/btrfs/delayed-ref.h |  3 ++-
>  fs/btrfs/extent-tree.c | 22 +++-------------------
>  3 files changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 62ff545ba1f7..3a9e4ac21794 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -393,6 +393,20 @@ btrfs_select_ref_head(struct btrfs_trans_handle *trans)
>  	return head;
>  }
>  
> +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> +			   struct btrfs_delayed_ref_head *head)
> +{
> +	lockdep_assert_held(&delayed_refs->lock);
> +	lockdep_assert_held(&head->lock);
> +
> +	rb_erase(&head->href_node, &delayed_refs->href_root);
> +	RB_CLEAR_NODE(&head->href_node);
> +	atomic_dec(&delayed_refs->num_entries);
> +	delayed_refs->num_heads--;
> +	if (head->processing == 0)
> +		delayed_refs->num_heads_ready--;
> +}
> +
>  /*
>   * Helper to insert the ref_node to the tail or merge with tail.
>   *
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index d9f2a4ebd5db..7769177b489e 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -261,7 +261,8 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
>  {
>  	mutex_unlock(&head->mutex);
>  }
> -
> +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> +			   struct btrfs_delayed_ref_head *head);
>  
>  struct btrfs_delayed_ref_head *
>  btrfs_select_ref_head(struct btrfs_trans_handle *trans);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f77226d8020a..d24a0de4a2e7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2492,12 +2492,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  		spin_unlock(&delayed_refs->lock);
>  		return 1;
>  	}
> -	delayed_refs->num_heads--;
> -	rb_erase(&head->href_node, &delayed_refs->href_root);
> -	RB_CLEAR_NODE(&head->href_node);
> +	btrfs_delete_ref_head(delayed_refs, head);
>  	spin_unlock(&head->lock);
>  	spin_unlock(&delayed_refs->lock);
> -	atomic_dec(&delayed_refs->num_entries);
>  
>  	trace_run_delayed_ref_head(fs_info, head, 0);
>  
> @@ -6984,22 +6981,9 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>  	if (!mutex_trylock(&head->mutex))
>  		goto out;
>  
> -	/*
> -	 * at this point we have a head with no other entries.  Go
> -	 * ahead and process it.
> -	 */
> -	rb_erase(&head->href_node, &delayed_refs->href_root);
> -	RB_CLEAR_NODE(&head->href_node);
> -	atomic_dec(&delayed_refs->num_entries);
> -
> -	/*
> -	 * we don't take a ref on the node because we're removing it from the
> -	 * tree, so we just steal the ref the tree was holding.
> -	 */
> -	delayed_refs->num_heads--;
> -	if (head->processing == 0)
> -		delayed_refs->num_heads_ready--;
> +	btrfs_delete_ref_head(delayed_refs, head);
>  	head->processing = 0;
> +
>  	spin_unlock(&head->lock);
>  	spin_unlock(&delayed_refs->lock);
>  
> -- 
> 2.14.3
> 
