Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55692 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3KBRIz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 13:08:55 -0400
Date: Sat, 2 Nov 2013 10:08:48 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Kelley Nielsen <kelleynnn@gmail.com>
Cc: linux-btrfs@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [OPW kernel] [PATCH 2/3] btrfs_find_item expanded to include
 find_root_ref functionality
Message-ID: <20131102170848.GN15704@leaf>
References: <cover.1383289182.git.kelleynnn@gmail.com>
 <289ccf95bca0d3366fb183faee8b368fa11b4bd3.1383289182.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <289ccf95bca0d3366fb183faee8b368fa11b4bd3.1383289182.git.kelleynnn@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 01, 2013 at 12:00:10AM -0700, Kelley Nielsen wrote:
> This patch is the second step in bootstrapping the btrfs_find_item
> interface. The function btrfs_find_root_ref is similar to the former
> __inode_info; it accepts four of its parameters, and duplicates the
> first half of its functionality.
> 
> The one former call to btrfs_find_root_ref has been replaced with a
> call to btrfs_find_item, along with the defined key type that was used
> internally by btrfs_find_root ref, and a null found key. In
> btrfs_find_item, a test for the null key has been added at the place
> where the functionality of btrfs_find_root_ref ends; btrfs_find_item
> then returns if the test passes. Finally, btrfs_find_root_ref has been
> removed.

Write your commit messages in imperative form, not passive voice:

Replace the one former call to btrfs_find_root_ref with a call to
btrfs_find_item, along with the defined key type used internally by
btrfs_find_root ref, and a null found key. In btrfs_find_item, add a
test for the null key at the place where the functionality of
btrfs_find_root_ref ends; btrfs_find_item then returns if the test
passes. Finally, remove btrfs_find_root_ref.

> 
> Signed-off-by: Kelley Nielsen <kelleynnn@gmail.com>
> Suggested-by: Zach Brown <zab@redhat.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  fs/btrfs/ctree.c     | 10 ++++++++--
>  fs/btrfs/inode.c     |  6 +++---
>  fs/btrfs/root-tree.c | 15 ---------------
>  3 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 3828352..498b19d 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2465,7 +2465,13 @@ static int key_search(struct extent_buffer *b, struct btrfs_key *key,
>  /* Proposed generic search function, meant to take the place of the
>  * various small search helper functions throughout the code and standardize
>  * the search interface. Right now, it only replaces the former __inode_info
> -* in backref.c.
> +* in backref.c, and the former btrfs_find_root_ref in root-tree.c.
> +*
> +* If a null key is passed, it returns immediately after running
> +* btrfs_search_slot, leaving the path filled as it is and passing its
> +* return value upward. If a real key is passed, it will set the caller's
> +* path to point to the first item in the tree after its specified
> +* objectid, type, and offset for which objectid and type match the input.
>  */
>  int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
>  		u64 inum, u64 ioff, u8 key_type,
> @@ -2480,7 +2486,7 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
>  	key.offset = ioff;
>  
>  	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
> -	if (ret < 0)
> +	if ((ret < 0) || (found_key == NULL))
>  		return ret;
>  
>  	eb = path->nodes[0];
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3911fca..c07afdf 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4672,9 +4672,9 @@ static int fixup_tree_root_location(struct btrfs_root *root,
>  	}
>  
>  	err = -ENOENT;
> -	ret = btrfs_find_root_ref(root->fs_info->tree_root, path,
> -				  BTRFS_I(dir)->root->root_key.objectid,
> -				  location->objectid);
> +	ret = btrfs_find_item(root->fs_info->tree_root, path,
> +				BTRFS_I(dir)->root->root_key.objectid,
> +				location->objectid, BTRFS_ROOT_REF_KEY, NULL);
>  	if (ret) {
>  		if (ret < 0)
>  			err = ret;
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index ec71ea4..fcc10eb 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -400,21 +400,6 @@ out:
>  	return err;
>  }
>  
> -int btrfs_find_root_ref(struct btrfs_root *tree_root,
> -		   struct btrfs_path *path,
> -		   u64 root_id, u64 ref_id)
> -{
> -	struct btrfs_key key;
> -	int ret;
> -
> -	key.objectid = root_id;
> -	key.type = BTRFS_ROOT_REF_KEY;
> -	key.offset = ref_id;
> -
> -	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
> -	return ret;
> -}
> -
>  /*
>   * add a btrfs_root_ref item.  type is either BTRFS_ROOT_REF_KEY
>   * or BTRFS_ROOT_BACKREF_KEY.
> -- 
> 1.8.1.2
> 
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
