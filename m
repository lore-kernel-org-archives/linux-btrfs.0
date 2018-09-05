Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbeIEK1S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 06:27:18 -0400
Subject: Re: [PATCH] Btrfs: remove redundant btrfs_trans_release_metadata"
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536110090-100798-1-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8b39ad2c-36e2-9d68-608d-565b4b6c8a0a@suse.com>
Date: Wed, 5 Sep 2018 08:58:44 +0300
MIME-Version: 1.0
In-Reply-To: <1536110090-100798-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.09.2018 04:14, Liu Bo wrote:
> __btrfs_end_transaction() has done the metadata release twice,
> probably because it used to process delayed refs in between, but now
> that we don't process delayed refs any more, the 2nd release is always
> a noop.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/transaction.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index bb1b9f526e98..94b036a74d11 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -826,12 +826,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  		return 0;
>  	}
>  
> -	btrfs_trans_release_metadata(trans);
> -	trans->block_rsv = NULL;
> -
> -	if (!list_empty(&trans->new_bgs))
> -		btrfs_create_pending_block_groups(trans);
> -

The only code which can have any implications to the transaction reserve
is the btrfs_Create_pending_block_groups since it does insert items. But
at this point trans->block_rsv is already null and additionally even if
more reservations are made for this transaction further down either
btrfs_commit_transaction is called or the transaction kthread is called
which is going to commit it. So this change really seems inconsequential.

>  	trans->delayed_ref_updates = 0;
>  	if (!trans->sync) {
>  		must_run_delayed_refs =
> 
