Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727191AbeHaLh6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 07:37:58 -0400
Subject: Re: [PATCH 22/35] btrfs: make sure we create all new bgs
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-23-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a433a3b0-dbe1-da97-2d30-1e3ab85e9ec0@suse.com>
Date: Fri, 31 Aug 2018 10:31:49 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-23-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We can actually allocate new chunks while we're creating our bg's, so
> instead of doing list_for_each_safe, just do while (!list_empty()) so we
> make sure to catch any new bg's that get added to the list.

HOw can this occur, please elaborate and put an example callstack in the
commit log.

> 
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
> 
