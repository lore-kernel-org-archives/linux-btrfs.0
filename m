Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727268AbeHaLzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:55:10 -0400
Subject: Re: [PATCH 30/35] btrfs: cleanup pending bgs on transaction abort
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-31-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <265df94d-e5e9-5476-1e7b-f4058b6180e6@suse.com>
Date: Fri, 31 Aug 2018 10:48:58 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-31-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We may abort the transaction during a commit and not have a chance to
> run the pending bgs stuff, which will leave block groups on our list and
> cause us accounting issues and leaked memory.  Fix this by running the
> pending bgs when we cleanup a transaction.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/transaction.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 89d14f135837..0f39a0d302d3 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2273,6 +2273,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	btrfs_scrub_continue(fs_info);
>  cleanup_transaction:
>  	btrfs_trans_release_metadata(trans);
> +	btrfs_create_pending_block_groups(trans);

And now you've basically hi-jacked btrfs_create_pending_block_groups to
just act as "delete all bg" in case transaction is aborted. Considering
this and the previous patch I'd rather you replace them with a single
one which introduces a new function delete_pending_bgs or whatever and
use that. This will be more explicit and self-documenting.

>  	btrfs_trans_release_chunk_metadata(trans);
>  	trans->block_rsv = NULL;
>  	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
> 
