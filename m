Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbeICNcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 09:32:50 -0400
Subject: Re: [PATCH 08/35] btrfs: release metadata before running delayed refs
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-9-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fc8cf3f9-dada-0168-e53b-e9bb85c3970d@suse.com>
Date: Mon, 3 Sep 2018 12:13:32 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-9-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:41, Josef Bacik wrote:
> We want to release the unused reservation we have since it refills the
> delayed refs reserve, which will make everything go smoother when
> running the delayed refs if we're short on our reservation.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

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
> 
