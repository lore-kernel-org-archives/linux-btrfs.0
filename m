Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727191AbeHaLwx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:52:53 -0400
Subject: Re: [PATCH 29/35] btrfs: just delete pending bgs if we are aborted
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-30-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8d7a8f25-285d-e98e-9094-fe16ed62ab78@suse.com>
Date: Fri, 31 Aug 2018 10:46:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-30-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We still need to do all of the accounting cleanup for pending block
> groups if we abort.  So set the ret to trans->aborted so if we aborted
> the cleanup happens and everybody is happy.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 90f267f4dd0f..132a1157982c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10333,7 +10333,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
>  	struct btrfs_root *extent_root = fs_info->extent_root;
>  	struct btrfs_block_group_item item;
>  	struct btrfs_key key;
> -	int ret = 0;
> +	int ret = trans->aborted;

This is really subtle and magical and not obvious from the context of
the patch, but if the transaction is aborted this will change the loop
to actually just delete all block groups in ->new_bgs. I'd rather have
an explicit loop for that honestly.

>  	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
>  
>  	trans->can_flush_pending_bgs = false;
> 
