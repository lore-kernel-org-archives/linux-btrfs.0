Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750919AbcLUOZm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 09:25:42 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A6D0BABB4
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Dec 2016 14:25:40 +0000 (UTC)
Date: Wed, 21 Dec 2016 15:25:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs-progs: Get the highest inode for lost+found
Message-ID: <20161221142525.GC12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161220120854.4270-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161220120854.4270-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 20, 2016 at 06:08:54AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> root->highest_inode is not accurate at the time of creating a lost+found
> and it fails because the highest_inode+1 is already present. This could be
> because of fixes after highest_inode is set. Instead, search
> for the highest inode in the tree and use it for lost+found.
> 
> This makes root->highest_inode unnecessary and hence deleted.

There's a slight change in how the highest number is found, but I
haven't found a major problem with that. Currently the highest is
obtained from a "cache", that's being built, so we can be relatively
sure that we found all the correct objects in the filesystem or repaired
them and use the cached versions.

The new approach is to actively search in the existing tree. So this
expects that this will work without encountering any unexpected problems
(corruption etc). This should be still fine IMO, as creating the
lost+found directory searches the tree anyway and modifies it.

> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  cmds-check.c | 46 +++++++++++++++++++++++++++-------------------
>  ctree.h      |  1 -
>  disk-io.c    |  1 -
>  3 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 1dba298..a55d00d 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -2853,6 +2853,31 @@ out:
>  	return ret;
>  }
>  
> +static int get_highest_inode(struct btrfs_trans_handle *trans,
> +				struct btrfs_root *root,
> +				struct btrfs_path *path,
> +				u64 *highest_ino)
> +{
> +	struct btrfs_key key, found_key;
> +	int ret;
> +
> +	btrfs_init_path(path);
> +	key.objectid = BTRFS_LAST_FREE_OBJECTID;
> +	key.offset = -1;
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> +	if (ret == 1) {
> +		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
> +				path->slots[0] - 1);
> +		*highest_ino = found_key.objectid;
> +		ret = 0;
> +	}

All the ret values should be handled, no? At least the error case < 0,
and == 0 as a sanity check.

Otherwise looks good, I'll wait if Qu has more to comment.

> +	if (*highest_ino >= BTRFS_LAST_FREE_OBJECTID)
> +		ret = -EOVERFLOW;
> +	btrfs_release_path(path);
> +	return ret;
> +}
> +
>  static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *root,
>  			       struct btrfs_path *path,
> @@ -2898,11 +2923,9 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
>  	}
>  
>  	if (rec->found_link == 0) {
> -		lost_found_ino = root->highest_inode;
> -		if (lost_found_ino >= BTRFS_LAST_FREE_OBJECTID) {
> -			ret = -EOVERFLOW;
> +		ret = get_highest_inode(trans, root, path, &lost_found_ino);
> +		if (ret < 0)
>  			goto out;
> -		}
>  		lost_found_ino++;
>  		ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
>  				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
> @@ -3266,21 +3289,6 @@ static int check_inode_recs(struct btrfs_root *root,
>  	}
>  
>  	/*
> -	 * We need to record the highest inode number for later 'lost+found'
> -	 * dir creation.
> -	 * We must select an ino not used/referred by any existing inode, or
> -	 * 'lost+found' ino may be a missing ino in a corrupted leaf,
> -	 * this may cause 'lost+found' dir has wrong nlinks.
> -	 */
> -	cache = last_cache_extent(inode_cache);
> -	if (cache) {
> -		node = container_of(cache, struct ptr_node, cache);
> -		rec = node->data;
> -		if (rec->ino > root->highest_inode)
> -			root->highest_inode = rec->ino;
> -	}
> -
> -	/*
>  	 * We need to repair backrefs first because we could change some of the
>  	 * errors in the inode recs.
>  	 *
> diff --git a/ctree.h b/ctree.h
> index dd02ef8..0c34ae2 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -1177,7 +1177,6 @@ struct btrfs_root {
>  
>  
>  	u32 type;
> -	u64 highest_inode;
>  	u64 last_inode_alloc;
>  
>  	/*
> diff --git a/disk-io.c b/disk-io.c
> index 9140a81..2a94d4f 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -494,7 +494,6 @@ void btrfs_setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
>  	root->fs_info = fs_info;
>  	root->objectid = objectid;
>  	root->last_trans = 0;
> -	root->highest_inode = 0;
>  	root->last_inode_alloc = 0;
>  
>  	INIT_LIST_HEAD(&root->dirty_list);
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
