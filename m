Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727160AbeGTIYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 04:24:36 -0400
Subject: Re: [PATCH 22/22] btrfs: only run delayed refs if we're committing
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-22-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <863783da-0f1c-b1c6-5c26-f379769f76d6@suse.com>
Date: Fri, 20 Jul 2018 10:37:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180719145006.17532-22-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.07.2018 17:50, Josef Bacik wrote:
> I noticed in a giant dbench run that we spent a lot of time on lock
> contention while running transaction commit.  This is because dbench
> results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
> they all run the delayed refs first thing, so they all contend with
> each other.  This leads to seconds of 0 throughput.  Change this to only
> run the delayed refs if we're the ones committing the transaction.  This
> makes the latency go away and we get no more lock contention.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/transaction.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4b171d8a7554..39ff9378b3db 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1919,15 +1919,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
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
> @@ -1940,12 +1931,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
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
> @@ -2016,6 +2001,17 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  		spin_unlock(&fs_info->trans_lock);
>  	}
>  
> +	/*
> +	 * We are now the only one in the commit area, we can run delayed refs
> +	 * without hitting a bunch of lock contention from a lot of people
> +	 * trying to commit the transaction at once.
> +	 */
> +	ret = btrfs_run_delayed_refs(trans, 0);
> +	if (ret) {
> +		btrfs_end_transaction(trans);
> +		return ret;
> +	}
> +

Is this really needed since we already have code which runs delayed refs
in the transaction critical section right after btrfs_run_delayed_items.
I'd rather have a single place in commit_transaction where delayed_refs
are run. If this is needed for correctness reasons then document what
this reason is for otherwise let's just remove it.

>  	extwriter_counter_dec(cur_trans, trans->type);
>  
>  	ret = btrfs_start_delalloc_flush(fs_info);
> 
