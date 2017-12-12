Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752131AbdLLTQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 14:16:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 77C08AE04
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 19:16:01 +0000 (UTC)
Date: Tue, 12 Dec 2017 20:14:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Improve btrfs_search_slot description
Message-ID: <20171212191401.GV3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512745585-19969-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512745585-19969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 08, 2017 at 05:06:25PM +0200, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 880f4f693263..1f001d31bda8 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2653,18 +2653,30 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
>  	return 0;
>  }
>  
> -/*
> - * look for key in the tree.  path is filled in with nodes along the way
> - * if key is found, we return zero and you can find the item in the leaf
> - * level of the path (level 0)
> +/* btrfs_search_slot - look for a key in a tree and perform necessary

 /*
  * ...

> + * modifications to preserve tree invariants.
> + *
> + * @trans:	Handle of transaction, used when modifying the tree
> + * @p:		Holds all btree nodes along the search path
> + * @root:	The root node of the tree
> + * @key:	The key we are looking for
> + * @ins_len:	Indicates purpose of search, for inserts it is 1, for
> + *		deletions it's -1. 0 for plain searches
> + * @cow:	boolean should CoW operations be performed. Must always be 1
> + *		when modifying the tree.
> + *
> + * If @ins_len > 0, nodes and leaves will be split as we walk down the tree.
> + * If @ins_len < 0, nodes will be merged as we walk down the tree (if possible)
> + *
> + * If @key is found, 0 is returned and you can find the item in the leaf level
> + * of the path (level 0)
>   *
> - * If the key isn't found, the path points to the slot where it should
> - * be inserted, and 1 is returned.  If there are other errors during the
> - * search a negative error number is returned.
> + * If @key isn't found, 1 is returned and the leaf level of the path (level 0)
> + * points to the slot where it should be inserted
> + * be inserted, and 1 is returned.

looks like some editing artifact

>   *
> - * if ins_len > 0, nodes and leaves will be split as we walk down the
> - * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
> - * possible)
> + * If an error is encountered while searching the tree a negative error number
> + * is returned
>   */
>  int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  		      const struct btrfs_key *key, struct btrfs_path *p,
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
