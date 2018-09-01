Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44272 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeIAEpB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 00:45:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id ba4-v6so6140193plb.11
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:35:03 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:34:59 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 30/35] btrfs: cleanup pending bgs on transaction abort
Message-ID: <20180901003459.GG29370@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-31-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-31-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:42:20PM -0400, Josef Bacik wrote:
> We may abort the transaction during a commit and not have a chance to
> run the pending bgs stuff, which will leave block groups on our list and
> cause us accounting issues and leaked memory.  Fix this by running the
> pending bgs when we cleanup a transaction.

Reviewed-by: Omar Sandoval <osandov@fb.com>

Again, I think it's fine to reuse the same function as long as there's a
comment here.

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
>  	btrfs_trans_release_chunk_metadata(trans);
>  	trans->block_rsv = NULL;
>  	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
> -- 
> 2.14.3
> 
