Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727178AbeHaLiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:38:46 -0400
Subject: Re: [PATCH 24/35] btrfs: pass delayed_refs_root to
 btrfs_delayed_ref_lock
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-25-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6c3906ef-8c74-1b40-5f78-9b4c0d2b00da@suse.com>
Date: Fri, 31 Aug 2018 10:32:37 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-25-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We don't need the trans except to get the delayed_refs_root, so just
> pass the delayed_refs_root into btrfs_delayed_ref_lock and call it a
> day.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/delayed-ref.c | 5 +----
>  fs/btrfs/delayed-ref.h | 2 +-
>  fs/btrfs/extent-tree.c | 2 +-
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 96ce087747b2..87778645bf4a 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -197,12 +197,9 @@ find_ref_head(struct rb_root *root, u64 bytenr,
>  	return NULL;
>  }
>  
> -int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
> +int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
>  			   struct btrfs_delayed_ref_head *head)
>  {
> -	struct btrfs_delayed_ref_root *delayed_refs;
> -
> -	delayed_refs = &trans->transaction->delayed_refs;
>  	lockdep_assert_held(&delayed_refs->lock);
>  	if (mutex_trylock(&head->mutex))
>  		return 0;
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 7769177b489e..ee636d7a710a 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -255,7 +255,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
>  struct btrfs_delayed_ref_head *
>  btrfs_find_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
>  			    u64 bytenr);
> -int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
> +int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
>  			   struct btrfs_delayed_ref_head *head);
>  static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
>  {
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index fc30ff96f0d6..32579221d900 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2591,7 +2591,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  
>  			/* grab the lock that says we are going to process
>  			 * all the refs for this head */
> -			ret = btrfs_delayed_ref_lock(trans, locked_ref);
> +			ret = btrfs_delayed_ref_lock(delayed_refs, locked_ref);
>  			spin_unlock(&delayed_refs->lock);
>  			/*
>  			 * we may have dropped the spin lock to get the head
> 
