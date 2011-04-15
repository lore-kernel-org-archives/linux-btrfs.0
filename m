From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: if we've already started a trans handle, use that one
Date: Fri, 15 Apr 2011 13:36:30 -0400
Message-ID: <1302888971-sup-9684@think>
References: <1302886575-2025-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1302886575-2025-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-04-15 12:56:15 -0400:
> We currently track trans handles in current->journal_info, but we don't actually
> use it.  This patch fixes it.  This will cover the case where we have multiple
> people starting transactions down the call chain.  This keeps us from having to
> allocate a new handle and all of that, we just increase the use count of the
> current handle, save the old block_rsv, and return.  I tested this with xfstests
> and it worked out fine.  Thanks,

Just curious, which call stacks are currently nesting transactions?

-chris

> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/transaction.c |   17 +++++++++++++++++
>  fs/btrfs/transaction.h |    2 ++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 70bfb26..46f4056 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -184,6 +184,15 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>  
>      if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
>          return ERR_PTR(-EROFS);
> +
> +    if (current->journal_info) {
> +        WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK);
> +        h = current->journal_info;
> +        h->use_count++;
> +        h->orig_rsv = h->block_rsv;
> +        h->block_rsv = NULL;
> +        goto got_it;
> +    }
>  again:
>      h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
>      if (!h)
> @@ -213,7 +222,9 @@ again:
>      h->block_group = 0;
>      h->bytes_reserved = 0;
>      h->delayed_ref_updates = 0;
> +    h->use_count = 1;
>      h->block_rsv = NULL;
> +    h->orig_rsv = NULL;
>  
>      smp_mb();
>      if (cur_trans->blocked && may_wait_transaction(root, type)) {
> @@ -241,6 +252,7 @@ again:
>          }
>      }
>  
> +got_it:
>      if (type != TRANS_JOIN_NOLOCK)
>          mutex_lock(&root->fs_info->trans_mutex);
>      record_root_in_trans(h, root);
> @@ -428,6 +440,11 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>      struct btrfs_fs_info *info = root->fs_info;
>      int count = 0;
>  
> +    if (--trans->use_count) {
> +        trans->block_rsv = trans->orig_rsv;
> +        return 0;
> +    }
> +
>      while (count < 4) {
>          unsigned long cur = trans->delayed_ref_updates;
>          trans->delayed_ref_updates = 0;
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 1f573f0..154314f 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -47,11 +47,13 @@ struct btrfs_trans_handle {
>      u64 transid;
>      u64 block_group;
>      u64 bytes_reserved;
> +    unsigned long use_count;
>      unsigned long blocks_reserved;
>      unsigned long blocks_used;
>      unsigned long delayed_ref_updates;
>      struct btrfs_transaction *transaction;
>      struct btrfs_block_rsv *block_rsv;
> +    struct btrfs_block_rsv *orig_rsv;
>  };
>  
>  struct btrfs_pending_snapshot {
