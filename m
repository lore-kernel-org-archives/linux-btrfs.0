Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb1-f182.google.com ([209.85.219.182]:46770 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbeIAEWN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 00:22:13 -0400
Received: by mail-yb1-f182.google.com with SMTP id y20-v6so1483491ybi.13
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:12:19 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:12:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/35] btrfs: release metadata before running delayed refs
Message-ID: <20180901001214.GB29370@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-9-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-9-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:41:58PM -0400, Josef Bacik wrote:
> We want to release the unused reservation we have since it refills the
> delayed refs reserve, which will make everything go smoother when
> running the delayed refs if we're short on our reservation.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/transaction.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 99741254e27e..ebb0c0405598 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1915,6 +1915,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  		return ret;
>  	}
>  
> +	btrfs_trans_release_metadata(trans);
> +	trans->block_rsv = NULL;
> +
>  	/* make a pass through all the delayed refs we have so far
>  	 * any runnings procs may add more while we are here
>  	 */
> @@ -1924,9 +1927,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  		return ret;
>  	}
>  
> -	btrfs_trans_release_metadata(trans);
> -	trans->block_rsv = NULL;
> -
>  	cur_trans = trans->transaction;
>  
>  	/*
> -- 
> 2.14.3
> 
