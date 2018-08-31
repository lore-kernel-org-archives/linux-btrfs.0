Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727282AbeHaLt7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:49:59 -0400
Subject: Re: [PATCH 28/35] btrfs: call btrfs_create_pending_block_groups
 unconditionally
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-29-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0b84e5ba-5096-068e-e36a-c036a637d943@suse.com>
Date: Fri, 31 Aug 2018 10:43:48 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-29-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> The first thing we do is loop through the list, this
> 
> if (!list_empty())
> 	btrfs_create_pending_block_groups();
> 
> thing is just wasted space.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Makes sense, although it would have been ideal if this patch followed
directly your " btrfs: make sure we create all new bgs" one.

Anyway:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 3 +--
>  fs/btrfs/transaction.c | 6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 031d2b11ddee..90f267f4dd0f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2970,8 +2970,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  	}
>  
>  	if (run_all) {
> -		if (!list_empty(&trans->new_bgs))
> -			btrfs_create_pending_block_groups(trans);
> +		btrfs_create_pending_block_groups(trans);
>  
>  		spin_lock(&delayed_refs->lock);
>  		node = rb_first(&delayed_refs->href_root);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 2bb19e2ded5e..89d14f135837 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -839,8 +839,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  	btrfs_trans_release_metadata(trans);
>  	trans->block_rsv = NULL;
>  
> -	if (!list_empty(&trans->new_bgs))
> -		btrfs_create_pending_block_groups(trans);
> +	btrfs_create_pending_block_groups(trans);
>  
>  	btrfs_trans_release_chunk_metadata(trans);
>  
> @@ -1927,8 +1926,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	cur_trans->delayed_refs.flushing = 1;
>  	smp_wmb();
>  
> -	if (!list_empty(&trans->new_bgs))
> -		btrfs_create_pending_block_groups(trans);
> +	btrfs_create_pending_block_groups(trans);
>  
>  	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
>  		int run_it = 0;
> 
