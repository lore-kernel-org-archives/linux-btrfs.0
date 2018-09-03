Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726212AbeICNZp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 09:25:45 -0400
Subject: Re: [PATCH 06/35] btrfs: check if free bgs for commit
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-7-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bc0590cb-cd89-d31d-b666-5e18094368ad@suse.com>
Date: Mon, 3 Sep 2018 12:06:29 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-7-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:41, Josef Bacik wrote:
> may_commit_transaction will skip committing the transaction if we don't
> have enough pinned space or if we're trying to find space for a SYSTEM
> chunk.  However if we have pending free block groups in this transaction
> we still want to commit as we may be able to allocate a chunk to make
> our reservation.  So instead of just returning ENOSPC, check if we have
> free block groups pending, and if so commit the transaction to allow us
> to use that free space.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6e7f350754d2..80615a579b18 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4804,6 +4804,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  	struct btrfs_trans_handle *trans;
>  	u64 bytes;
>  	u64 reclaim_bytes = 0;
> +	bool do_commit = true;
>  
>  	trans = (struct btrfs_trans_handle *)current->journal_info;
>  	if (trans)

While you are at it, does this check even make sense, since the
transaction handle is  acquired proper later I think this can be removed?

> @@ -4832,8 +4833,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  	 * See if there is some space in the delayed insertion reservation for
>  	 * this reservation.
>  	 */
> -	if (space_info != delayed_rsv->space_info)
> -		return -ENOSPC;
> +	if (space_info != delayed_rsv->space_info) {
> +		do_commit = false;
> +		goto commit;
> +	}
>  
>  	spin_lock(&delayed_rsv->lock);
>  	reclaim_bytes += delayed_rsv->reserved;
> @@ -4848,15 +4851,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  
>  	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
>  				   bytes,
> -				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
> -		return -ENOSPC;
> -	}
> -
> +				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0)
> +		do_commit = false;
>  commit:
>  	trans = btrfs_join_transaction(fs_info->extent_root);
>  	if (IS_ERR(trans))
>  		return -ENOSPC;
>  
> +	if (!do_commit &&> +	    !test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags)) {
> +		btrfs_end_transaction(trans);
> +		return -ENOSPC;
> +	}
>  	return btrfs_commit_transaction(trans);
>  }
>  
> 
