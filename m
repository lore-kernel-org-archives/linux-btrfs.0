Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60341 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeFSFYk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 01:24:40 -0400
Subject: Re: [PATCH 1/3] btrfs: Remove fs_info argument from
 __btrfs_inc_extent_ref
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
 <1529323166-29931-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c1c0611a-a46c-14e9-3a23-510fa8c7e8ff@gmx.com>
Date: Tue, 19 Jun 2018 13:24:28 +0800
MIME-Version: 1.0
In-Reply-To: <1529323166-29931-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月18日 19:59, Nikolay Borisov wrote:
> This function already takes a transaction which holds a reference to
> the fs_info struct. Use that reference and remove the extra arg. No
> functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/extent-tree.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4850e538ab10..59645ced6fbc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2208,12 +2208,12 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  }
>  
>  static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
> -				  struct btrfs_fs_info *fs_info,
>  				  struct btrfs_delayed_ref_node *node,
>  				  u64 parent, u64 root_objectid,
>  				  u64 owner, u64 offset, int refs_to_add,
>  				  struct btrfs_delayed_extent_op *extent_op)
>  {
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	struct btrfs_path *path;
>  	struct extent_buffer *leaf;
>  	struct btrfs_extent_item *item;
> @@ -2297,10 +2297,9 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
>  						 ref->objectid, ref->offset,
>  						 &ins, node->ref_mod);
>  	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
> -		ret = __btrfs_inc_extent_ref(trans, fs_info, node, parent,
> -					     ref_root, ref->objectid,
> -					     ref->offset, node->ref_mod,
> -					     extent_op);
> +		ret = __btrfs_inc_extent_ref(trans, node, parent, ref_root,
> +					     ref->objectid, ref->offset,
> +					     node->ref_mod, extent_op);
>  	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
>  		ret = __btrfs_free_extent(trans, fs_info, node, parent,
>  					  ref_root, ref->objectid,
> @@ -2450,10 +2449,8 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  		BUG_ON(!extent_op || !extent_op->update_flags);
>  		ret = alloc_reserved_tree_block(trans, node, extent_op);
>  	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
> -		ret = __btrfs_inc_extent_ref(trans, fs_info, node,
> -					     parent, ref_root,
> -					     ref->level, 0, 1,
> -					     extent_op);
> +		ret = __btrfs_inc_extent_ref(trans, node, parent, ref_root,
> +					     ref->level, 0, 1, extent_op);
>  	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
>  		ret = __btrfs_free_extent(trans, fs_info, node,
>  					  parent, ref_root,
> 
