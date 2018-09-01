Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43376 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbeIAEiM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 00:38:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id x6-v6so6138723plv.10
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:28:14 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:28:09 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 21/35] btrfs: only run delayed refs if we're committing
Message-ID: <20180901002809.GE29370@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-22-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-22-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:42:11PM -0400, Josef Bacik wrote:
> I noticed in a giant dbench run that we spent a lot of time on lock
> contention while running transaction commit.  This is because dbench
> results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
> they all run the delayed refs first thing, so they all contend with
> each other.  This leads to seconds of 0 throughput.  Change this to only
> run the delayed refs if we're the ones committing the transaction.  This
> makes the latency go away and we get no more lock contention.

This means that we're going to spend more time running delayed refs
while in TRANS_STATE_COMMIT_START, so couldn't we end up blocking new
transactions more than before?

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/transaction.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ebb0c0405598..2bb19e2ded5e 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1918,15 +1918,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	btrfs_trans_release_metadata(trans);
>  	trans->block_rsv = NULL;
>  
> -	/* make a pass through all the delayed refs we have so far
> -	 * any runnings procs may add more while we are here
> -	 */
> -	ret = btrfs_run_delayed_refs(trans, 0);
> -	if (ret) {
> -		btrfs_end_transaction(trans);
> -		return ret;
> -	}
> -
>  	cur_trans = trans->transaction;
>  
>  	/*
> @@ -1939,12 +1930,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	if (!list_empty(&trans->new_bgs))
>  		btrfs_create_pending_block_groups(trans);
>  
> -	ret = btrfs_run_delayed_refs(trans, 0);
> -	if (ret) {
> -		btrfs_end_transaction(trans);
> -		return ret;
> -	}
> -
>  	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
>  		int run_it = 0;
>  
> @@ -2015,6 +2000,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  		spin_unlock(&fs_info->trans_lock);
>  	}
>  
> +	/*
> +	 * We are now the only one in the commit area, we can run delayed refs
> +	 * without hitting a bunch of lock contention from a lot of people
> +	 * trying to commit the transaction at once.
> +	 */
> +	ret = btrfs_run_delayed_refs(trans, 0);
> +	if (ret)
> +		goto cleanup_transaction;
> +
>  	extwriter_counter_dec(cur_trans, trans->type);
>  
>  	ret = btrfs_start_delalloc_flush(fs_info);
> -- 
> 2.14.3
> 
