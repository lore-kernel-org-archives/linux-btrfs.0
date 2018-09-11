Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42497 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725738AbeILE0S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 00:26:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id l9-v6so10876pff.9
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 16:24:45 -0700 (PDT)
Date: Tue, 11 Sep 2018 16:24:43 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 03/36] btrfs: cleanup extent_op handling
Message-ID: <20180911232443.GF26631@vader>
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-4-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911175807.26181-4-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 01:57:34PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> The cleanup_extent_op function actually would run the extent_op if it
> needed running, which made the name sort of a misnomer.  Change it to
> run_and_cleanup_extent_op, and move the actual cleanup work to
> cleanup_extent_op so it can be used by check_ref_cleanup() in order to
> unify the extent op handling.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a44d55e36e11..98f36dfeccb0 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2442,19 +2442,33 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
>  	btrfs_delayed_ref_unlock(head);
>  }
>  
> -static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> -			     struct btrfs_delayed_ref_head *head)
> +static struct btrfs_delayed_extent_op *
> +cleanup_extent_op(struct btrfs_trans_handle *trans,
> +		  struct btrfs_delayed_ref_head *head)
>  {
>  	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
> -	int ret;
>  
>  	if (!extent_op)
> -		return 0;
> -	head->extent_op = NULL;
> +		return NULL;
> +
>  	if (head->must_insert_reserved) {
> +		head->extent_op = NULL;
>  		btrfs_free_delayed_extent_op(extent_op);
> -		return 0;
> +		return NULL;
>  	}

Now we don't set head->extent_op = NULL in this case when we call it
from check_ref_cleanup(), is that a problem?

> +	return extent_op;
> +}
> +
> +static int run_and_cleanup_extent_op(struct btrfs_trans_handle *trans,
> +				     struct btrfs_delayed_ref_head *head)
> +{
> +	struct btrfs_delayed_extent_op *extent_op =
> +		cleanup_extent_op(trans, head);
> +	int ret;
> +
> +	if (!extent_op)
> +		return 0;
> +	head->extent_op = NULL;
>  	spin_unlock(&head->lock);
>  	ret = run_delayed_extent_op(trans, head, extent_op);
>  	btrfs_free_delayed_extent_op(extent_op);
> @@ -2506,7 +2520,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  
>  	delayed_refs = &trans->transaction->delayed_refs;
>  
> -	ret = cleanup_extent_op(trans, head);
> +	ret = run_and_cleanup_extent_op(trans, head);
>  	if (ret < 0) {
>  		unselect_delayed_ref_head(delayed_refs, head);
>  		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
> @@ -6977,12 +6991,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>  	if (!RB_EMPTY_ROOT(&head->ref_tree))
>  		goto out;
>  
> -	if (head->extent_op) {
> -		if (!head->must_insert_reserved)
> -			goto out;
> -		btrfs_free_delayed_extent_op(head->extent_op);
> -		head->extent_op = NULL;
> -	}
> +	if (cleanup_extent_op(trans, head) != NULL)
> +		goto out;
>  
>  	/*
>  	 * waiting for the lock here would deadlock.  If someone else has it
> -- 
> 2.14.3
> 
