Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46705 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbeIADKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 23:10:10 -0400
Received: by mail-pl1-f196.google.com with SMTP id a4-v6so6063765plm.13
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 16:00:30 -0700 (PDT)
Date: Fri, 31 Aug 2018 16:00:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 03/35] btrfs: use cleanup_extent_op in check_ref_cleanup
Message-ID: <20180831230029.GB17237@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-4-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-4-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:41:53PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Unify the extent_op handling as well, just add a flag so we don't
> actually run the extent op from check_ref_cleanup and instead return a
> value so that we can skip cleaning up the ref head.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4c9fd35bca07..87c42a2c45b1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2443,18 +2443,23 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
>  }
>  
>  static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> -			     struct btrfs_delayed_ref_head *head)
> +			     struct btrfs_delayed_ref_head *head,
> +			     bool run_extent_op)
>  {
>  	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
>  	int ret;
>  
>  	if (!extent_op)
>  		return 0;
> +
>  	head->extent_op = NULL;
>  	if (head->must_insert_reserved) {
>  		btrfs_free_delayed_extent_op(extent_op);
>  		return 0;
> +	} else if (!run_extent_op) {
> +		return 1;
>  	}
> +
>  	spin_unlock(&head->lock);
>  	ret = run_delayed_extent_op(trans, head, extent_op);
>  	btrfs_free_delayed_extent_op(extent_op);

So if cleanup_extent_op() returns 1, then the head was unlocked, unless
run_extent_op was true. That's pretty confusing. Can we make it always
unlock in the !must_insert_reserved case?

> @@ -2506,7 +2511,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  
>  	delayed_refs = &trans->transaction->delayed_refs;
>  
> -	ret = cleanup_extent_op(trans, head);
> +	ret = cleanup_extent_op(trans, head, true);
>  	if (ret < 0) {
>  		unselect_delayed_ref_head(delayed_refs, head);
>  		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
> @@ -6977,12 +6982,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>  	if (!RB_EMPTY_ROOT(&head->ref_tree))
>  		goto out;
>  
> -	if (head->extent_op) {
> -		if (!head->must_insert_reserved)
> -			goto out;
> -		btrfs_free_delayed_extent_op(head->extent_op);
> -		head->extent_op = NULL;
> -	}
> +	if (cleanup_extent_op(trans, head, false))
> +		goto out;
>  
>  	/*
>  	 * waiting for the lock here would deadlock.  If someone else has it
> -- 
> 2.14.3
> 
