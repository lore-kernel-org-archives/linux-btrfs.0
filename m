Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44108 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeIAEn6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 00:43:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id r1-v6so6125032pgp.11
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:34:00 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:33:54 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 29/35] btrfs: just delete pending bgs if we are aborted
Message-ID: <20180901003354.GF29370@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-30-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-30-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:42:19PM -0400, Josef Bacik wrote:
> We still need to do all of the accounting cleanup for pending block
> groups if we abort.  So set the ret to trans->aborted so if we aborted
> the cleanup happens and everybody is happy.

Reviewed-by: Omar Sandoval <osandov@fb.com>

Reusing the loop is fine IMO, but a comment would be appreciated.

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
>  	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
>  
>  	trans->can_flush_pending_bgs = false;
> -- 
> 2.14.3
> 
