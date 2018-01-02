Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33349 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbeABQTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 11:19:25 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EDAC6ACBE
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Jan 2018 16:19:23 +0000 (UTC)
Date: Tue, 2 Jan 2018 17:17:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove unused btrfs_start_transaction_lflush
 function
Message-ID: <20180102161718.GU3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1513332378-7193-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513332378-7193-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 15, 2017 at 12:06:18PM +0200, Nikolay Borisov wrote:
> Commit 0e8c36a9fd81 ("Btrfs: fix lots of orphan inodes when the space
> is not enough") changed the way transaction reservation is made in
> btrfs_evict_node and as a result this function became unused. This has
> been the status quo for 5 years in which time no one noticed, so I'd
> say it's safe to assume it's unlikely it will ever be used again.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

https://marc.info/?l=linux-btrfs&m=142117508730660&w=2
https://marc.info/?l=linux-kernel&m=142119399504907&w=2

"Transcaction API, removing the func does not make sense without
removing BTRFS_RESERVE_FLUSH_LIMIT at the same time."

> ---
>  fs/btrfs/transaction.c | 10 +---------
>  fs/btrfs/transaction.h |  3 ---
>  2 files changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 5a8c2649af2f..b1793688c716 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -542,7 +542,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
>  	 * and then we deadlock with somebody doing a freeze.
>  	 *
>  	 * If we are ATTACH, it means we just want to catch the current
> -	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
> +	 * transaction and commit it, so we needn't do sb_start_intwrite().

Unrelated change.

>  	 */
>  	if (type & __TRANS_FREEZABLE)
>  		sb_start_intwrite(fs_info->sb);
> @@ -658,14 +658,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
>  	return trans;
>  }
>  
> -struct btrfs_trans_handle *btrfs_start_transaction_lflush(
> -					struct btrfs_root *root,
> -					unsigned int num_items)
> -{
> -	return start_transaction(root, num_items, TRANS_START,
> -				 BTRFS_RESERVE_FLUSH_LIMIT, true);
> -}
> -
>  struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
>  {
>  	return start_transaction(root, 0, TRANS_JOIN, BTRFS_RESERVE_NO_FLUSH,
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index c55e44560103..9b25b0ba92ee 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -187,9 +187,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
>  					struct btrfs_root *root,
>  					unsigned int num_items,
>  					int min_factor);
> -struct btrfs_trans_handle *btrfs_start_transaction_lflush(
> -					struct btrfs_root *root,
> -					unsigned int num_items);
>  struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
>  struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
>  struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
