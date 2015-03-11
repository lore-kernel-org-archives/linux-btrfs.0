Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbCKEJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Mar 2015 00:09:00 -0400
Date: Wed, 11 Mar 2015 12:08:39 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)
 V3
Message-ID: <20150311040827.GA3292@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1426040144-6150-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426040144-6150-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 10, 2015 at 10:15:44PM -0400, Josef Bacik wrote:
> Dave could hit this assert consistently running btrfs/078.  This is because
> when we update the block groups we could truncate the free space, which would
> try to delete the csums for that range and dirty the csum root.  For this to
> happen we have to have already written out the csum root so it's kind of hard to
> hit this case.  This patch fixes this by changing the logic to only write the
> dirty block groups if the dirty_cowonly_roots list is empty.  This will get us
> the same effect as before since we add the extent root last, and will cover the
> case that we dirty some other root again but not the extent root.  Thanks,

I know this fix the bug, but the changelog doesn't tell me that --
why we still got oops while turning down csum for free space inode?
Someone else get other trees dirty?

Thanks,

-liubo
> 
> Reported-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> V2->V3: Actually fix the bug.  Move the write dirty bgs stuff out of the update
> cowonly roots, then just check if we dirtied roots again and do the whole thing
> over again.
> 
>  fs/btrfs/transaction.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 038fcf6..a703131 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1023,7 +1023,6 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
>  	u64 old_root_bytenr;
>  	u64 old_root_used;
>  	struct btrfs_root *tree_root = root->fs_info->tree_root;
> -	bool extent_root = (root->objectid == BTRFS_EXTENT_TREE_OBJECTID);
>  
>  	old_root_used = btrfs_root_used(&root->root_item);
>  	btrfs_write_dirty_block_groups(trans, root);
> @@ -1031,9 +1030,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
>  	while (1) {
>  		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
>  		if (old_root_bytenr == root->node->start &&
> -		    old_root_used == btrfs_root_used(&root->root_item) &&
> -		    (!extent_root ||
> -		     list_empty(&trans->transaction->dirty_bgs)))
> +		    old_root_used == btrfs_root_used(&root->root_item))
>  			break;
>  
>  		btrfs_set_root_node(&root->root_item, root->node);
> @@ -1044,17 +1041,6 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
>  			return ret;
>  
>  		old_root_used = btrfs_root_used(&root->root_item);
> -		if (extent_root) {
> -			ret = btrfs_write_dirty_block_groups(trans, root);
> -			if (ret)
> -				return ret;
> -		}
> -		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
> -		if (ret)
> -			return ret;
> -		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
> -		if (ret)
> -			return ret;
>  	}
>  
>  	return 0;
> @@ -1071,6 +1057,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
>  					 struct btrfs_root *root)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct list_head *dirty_bgs = &trans->transaction->dirty_bgs;
>  	struct list_head *next;
>  	struct extent_buffer *eb;
>  	int ret;
> @@ -1102,7 +1089,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
>  	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
>  	if (ret)
>  		return ret;
> -
> +again:
>  	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
>  		next = fs_info->dirty_cowonly_roots.next;
>  		list_del_init(next);
> @@ -1115,8 +1102,23 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
>  		ret = update_cowonly_root(trans, root);
>  		if (ret)
>  			return ret;
> +		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
> +		if (ret)
> +			return ret;
>  	}
>  
> +	while (!list_empty(dirty_bgs)) {
> +		ret = btrfs_write_dirty_block_groups(trans, root);
> +		if (ret)
> +			return ret;
> +		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (!list_empty(&fs_info->dirty_cowonly_roots))
> +		goto again;
> +
>  	list_add_tail(&fs_info->extent_root->dirty_list,
>  		      &trans->transaction->switch_commits);
>  	btrfs_after_dev_replace_commit(fs_info);
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
