Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33364 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbeIAEUs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 00:20:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id d4-v6so6213353pfn.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:10:53 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:10:49 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 22/35] btrfs: make sure we create all new bgs
Message-ID: <20180901001049.GA29370@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-23-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-23-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:42:12PM -0400, Josef Bacik wrote:
> We can actually allocate new chunks while we're creating our bg's, so
> instead of doing list_for_each_safe, just do while (!list_empty()) so we
> make sure to catch any new bg's that get added to the list.

Reviewed-by: Omar Sandoval <osandov@fb.com>

Since Nikolay pointed it out, might as well mention in the commit
message that this can happen because we modify the chunk and extent
trees.

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ca98c39308f6..fc30ff96f0d6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10331,7 +10331,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
>  {
>  	struct btrfs_fs_info *fs_info = trans->fs_info;
> -	struct btrfs_block_group_cache *block_group, *tmp;
> +	struct btrfs_block_group_cache *block_group;
>  	struct btrfs_root *extent_root = fs_info->extent_root;
>  	struct btrfs_block_group_item item;
>  	struct btrfs_key key;
> @@ -10339,7 +10339,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
>  	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
>  
>  	trans->can_flush_pending_bgs = false;
> -	list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
> +	while (!list_empty(&trans->new_bgs)) {
> +		block_group = list_first_entry(&trans->new_bgs,
> +					       struct btrfs_block_group_cache,
> +					       bg_list);
>  		if (ret)
>  			goto next;
>  
> -- 
> 2.14.3
> 
