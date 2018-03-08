Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34549 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754547AbeCHPkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 10:40:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7BC1ADDF
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 15:40:34 +0000 (UTC)
Subject: Re: [PATCH 17/22] btrfs: kill tree_mod_log_set_root_pointer helper
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1520518876.git.dsterba@suse.com>
 <72ff37265349f68c04229797f49a09670ae46934.1520518876.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <daf312a4-a82d-8376-47e3-55c29eceb3e8@suse.com>
Date: Thu, 8 Mar 2018 17:40:33 +0200
MIME-Version: 1.0
In-Reply-To: <72ff37265349f68c04229797f49a09670ae46934.1520518876.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.03.2018 16:33, David Sterba wrote:
> A useless wrapper around tree_mod_log_insert_root that hides missing
> error handling. Move it to the callers.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

For 15-17:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/ctree.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index ceb0836d74cd..30950439731e 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -883,16 +883,6 @@ static noinline int tree_mod_log_free_eb(struct extent_buffer *eb)
>  	return ret;
>  }
>  
> -static noinline void
> -tree_mod_log_set_root_pointer(struct btrfs_root *root,
> -			      struct extent_buffer *new_root_node,
> -			      int log_removal)
> -{
> -	int ret;
> -	ret = tree_mod_log_insert_root(root->node, new_root_node, log_removal);
> -	BUG_ON(ret < 0);
> -}
> -
>  /*
>   * check if the tree block can be shared by multiple trees
>   */
> @@ -1119,7 +1109,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
>  			parent_start = buf->start;
>  
>  		extent_buffer_get(cow);
> -		tree_mod_log_set_root_pointer(root, cow, 1);
> +		ret = tree_mod_log_insert_root(root->node, cow, 1);
> +		BUG_ON(ret < 0);
>  		rcu_assign_pointer(root->node, cow);
>  
>  		btrfs_free_tree_block(trans, root, buf, parent_start,
> @@ -1873,7 +1864,8 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  			goto enospc;
>  		}
>  
> -		tree_mod_log_set_root_pointer(root, child, 1);
> +		ret = tree_mod_log_insert_root(root->node, child, 1);
> +		BUG_ON(ret < 0);
>  		rcu_assign_pointer(root->node, child);
>  
>  		add_root_to_dirty_list(root);
> @@ -3319,6 +3311,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
>  	struct extent_buffer *c;
>  	struct extent_buffer *old;
>  	struct btrfs_disk_key lower_key;
> +	int ret;
>  
>  	BUG_ON(path->nodes[level]);
>  	BUG_ON(path->nodes[level-1] != root->node);
> @@ -3357,7 +3350,8 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
>  	btrfs_mark_buffer_dirty(c);
>  
>  	old = root->node;
> -	tree_mod_log_set_root_pointer(root, c, 0);
> +	ret = tree_mod_log_insert_root(root->node, c, 0);
> +	BUG_ON(ret < 0);
>  	rcu_assign_pointer(root->node, c);
>  
>  	/* the super has an extra ref to root->node */
> 
