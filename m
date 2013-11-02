Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37307 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3KBRFI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 13:05:08 -0400
Date: Sat, 2 Nov 2013 10:05:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Kelley Nielsen <kelleynnn@gmail.com>
Cc: linux-btrfs@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [OPW kernel] [PATCH 1/3] Bootstrap generic btrfs_find_item
 interface
Message-ID: <20131102170502.GL15704@leaf>
References: <cover.1383287959.git.kelleynnn@gmail.com>
 <4a397119c8d634b82198fe728b9ea3ac4690444c.1383287959.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a397119c8d634b82198fe728b9ea3ac4690444c.1383287959.git.kelleynnn@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 31, 2013 at 11:53:41PM -0700, Kelley Nielsen wrote:
> There are many btrfs functions that manually search the tree for an
> item. They all reimplement the same mechanism and differ in the
> conditions that they use to find the item.__inode_info() is one such

You need a space after the '.' here; otherwise, this looks like a call
to "item.__inode_info()".

> example. It has been proposed that a new interface be created to
> take the place of these functions.

Same suggestion as in the cover letter: "It has been proposed that a new
interface be created" -> "Zach Brown proposed creating a new interface"

> This patch is the first step to creating the interface. A new function,
> btrfs_find_item, has been added to ctree.c and prototyped in ctree.h.
> It is identical to __inode_info, except that the order of the parameters
> has been rearranged to more closely those of similar functions elsewhere
> in the code (now, root and path come first, then the objectid, offset
> and type, and the key to be filled in last). __inode_info's callers have
> been set to call this new function instead, and __inode_info itself has
> been removed.
> 
> Signed-off-by: Kelley Nielsen <kelleynnn@gmail.com>
> Suggested-by: Zach Brown <zab@redhat.com>

With the fix above,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  fs/btrfs/backref.c | 40 ++++------------------------------------
>  fs/btrfs/ctree.c   | 37 +++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ctree.h   |  2 ++
>  3 files changed, 43 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 3775947..595bd1f 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1107,38 +1107,6 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> -
> -static int __inode_info(u64 inum, u64 ioff, u8 key_type,
> -			struct btrfs_root *fs_root, struct btrfs_path *path,
> -			struct btrfs_key *found_key)
> -{
> -	int ret;
> -	struct btrfs_key key;
> -	struct extent_buffer *eb;
> -
> -	key.type = key_type;
> -	key.objectid = inum;
> -	key.offset = ioff;
> -
> -	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
> -	if (ret < 0)
> -		return ret;
> -
> -	eb = path->nodes[0];
> -	if (ret && path->slots[0] >= btrfs_header_nritems(eb)) {
> -		ret = btrfs_next_leaf(fs_root, path);
> -		if (ret)
> -			return ret;
> -		eb = path->nodes[0];
> -	}
> -
> -	btrfs_item_key_to_cpu(eb, found_key, path->slots[0]);
> -	if (found_key->type != key.type || found_key->objectid != key.objectid)
> -		return 1;
> -
> -	return 0;
> -}
> -
>  /*
>   * this makes the path point to (inum INODE_ITEM ioff)
>   */
> @@ -1146,16 +1114,16 @@ int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
>  			struct btrfs_path *path)
>  {
>  	struct btrfs_key key;
> -	return __inode_info(inum, ioff, BTRFS_INODE_ITEM_KEY, fs_root, path,
> -				&key);
> +	return btrfs_find_item(fs_root, path, inum, ioff,
> +			BTRFS_INODE_ITEM_KEY, &key);
>  }
>  
>  static int inode_ref_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
>  				struct btrfs_path *path,
>  				struct btrfs_key *found_key)
>  {
> -	return __inode_info(inum, ioff, BTRFS_INODE_REF_KEY, fs_root, path,
> -				found_key);
> +	return btrfs_find_item(fs_root, path, inum, ioff,
> +			BTRFS_INODE_REF_KEY, found_key);
>  }
>  
>  int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 316136b..3828352 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2462,6 +2462,43 @@ static int key_search(struct extent_buffer *b, struct btrfs_key *key,
>  	return 0;
>  }
>  
> +/* Proposed generic search function, meant to take the place of the
> +* various small search helper functions throughout the code and standardize
> +* the search interface. Right now, it only replaces the former __inode_info
> +* in backref.c.
> +*/

Very nice work; even your comments are bisectable. :)

> +int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
> +		u64 inum, u64 ioff, u8 key_type,
> +		struct btrfs_key *found_key)
> +{
> +	int ret;
> +	struct btrfs_key key;
> +	struct extent_buffer *eb;
> +
> +	key.type = key_type;
> +	key.objectid = inum;
> +	key.offset = ioff;
> +
> +	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	eb = path->nodes[0];
> +	if (ret && path->slots[0] >= btrfs_header_nritems(eb)) {
> +		ret = btrfs_next_leaf(fs_root, path);
> +		if (ret)
> +			return ret;
> +		eb = path->nodes[0];
> +	}
> +
> +	btrfs_item_key_to_cpu(eb, found_key, path->slots[0]);
> +	if (found_key->type != key.type ||
> +			found_key->objectid != key.objectid)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  /*
>   * look for key in the tree.  path is filled in with nodes along the way
>   * if key is found, we return zero and you can find the item in the leaf
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 941019d..aa9993c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3357,6 +3357,8 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
>  			 struct btrfs_root *root,
>  			 struct btrfs_path *path,
>  			 struct btrfs_key *new_key);
> +int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
> +		u64 inum, u64 ioff, u8 key_type, struct btrfs_key *found_key);
>  int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
>  		      *root, struct btrfs_key *key, struct btrfs_path *p, int
>  		      ins_len, int cow);
> -- 
> 1.8.1.2
> 
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
