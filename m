Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37251 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaEGPVR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 11:21:17 -0400
Date: Wed, 7 May 2014 23:21:01 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: faster/more efficient insertion of file extent
 items
Message-ID: <20140507152100.GA2702@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1391989512-31797-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391989512-31797-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 09, 2014 at 11:45:12PM +0000, Filipe David Borba Manana wrote:
> This is an extension to my previous commit titled:
> 
>   "Btrfs: faster file extent item replace operations"
>   (hash 1acae57b161ef1282f565ef907f72aeed0eb71d9)
> 
> Instead of inserting the new file extent item if we deleted existing
> file extent items covering our target file range, also allow to insert
> the new file extent item if we didn't find any existing items to delete
> and replace_extent != 0, since in this case our caller would do another
> tree search to insert the new file extent item anyway, therefore just
> combine the two tree searches into a single one, saving cpu time, reducing
> lock contention and reducing btree node/leaf COW operations.
> 
> This covers the case where applications keep doing tail append writes to
> files, which for example is the case of Apache CouchDB (its database and
> view index files are always open with O_APPEND).

(I'm tracking a bug which is very hard to reproduce and the stack seems to
locate on this area.)

Even I know that this has been merged, I still have to say that this just
makes the code nearly hard-to-maintained.

__btrfs_drop_extents() has already been one of the most complex function since
it was written, but now it's become more and more complex!

I'm not sure whether the gained performance number deserves that kind of
complexity, man, to be honest, try to ask yourself how much time you'll spend in
re-understanding the code and all the details.

thanks,
-liubo

> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/file.c |   52 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 0165b86..006af2f 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -720,7 +720,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
>  	if (drop_cache)
>  		btrfs_drop_extent_cache(inode, start, end - 1, 0);
>  
> -	if (start >= BTRFS_I(inode)->disk_i_size)
> +	if (start >= BTRFS_I(inode)->disk_i_size && !replace_extent)
>  		modify_tree = 0;
>  
>  	while (1) {
> @@ -938,34 +938,42 @@ next_slot:
>  		 * Set path->slots[0] to first slot, so that after the delete
>  		 * if items are move off from our leaf to its immediate left or
>  		 * right neighbor leafs, we end up with a correct and adjusted
> -		 * path->slots[0] for our insertion.
> +		 * path->slots[0] for our insertion (if replace_extent != 0).
>  		 */
>  		path->slots[0] = del_slot;
>  		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
>  		if (ret)
>  			btrfs_abort_transaction(trans, root, ret);
> +	}
>  
> -		leaf = path->nodes[0];
> -		/*
> -		 * leaf eb has flag EXTENT_BUFFER_STALE if it was deleted (that
> -		 * is, its contents got pushed to its neighbors), in which case
> -		 * it means path->locks[0] == 0
> -		 */
> -		if (!ret && replace_extent && leafs_visited == 1 &&
> -		    path->locks[0] &&
> -		    btrfs_leaf_free_space(root, leaf) >=
> -		    sizeof(struct btrfs_item) + extent_item_size) {
> -
> -			key.objectid = ino;
> -			key.type = BTRFS_EXTENT_DATA_KEY;
> -			key.offset = start;
> -			setup_items_for_insert(root, path, &key,
> -					       &extent_item_size,
> -					       extent_item_size,
> -					       sizeof(struct btrfs_item) +
> -					       extent_item_size, 1);
> -			*key_inserted = 1;
> +	leaf = path->nodes[0];
> +	/*
> +	 * If btrfs_del_items() was called, it might have deleted a leaf, in
> +	 * which case it unlocked our path, so check path->locks[0] matches a
> +	 * write lock.
> +	 */
> +	if (!ret && replace_extent && leafs_visited == 1 &&
> +	    (path->locks[0] == BTRFS_WRITE_LOCK_BLOCKING ||
> +	     path->locks[0] == BTRFS_WRITE_LOCK) &&
> +	    btrfs_leaf_free_space(root, leaf) >=
> +	    sizeof(struct btrfs_item) + extent_item_size) {
> +
> +		key.objectid = ino;
> +		key.type = BTRFS_EXTENT_DATA_KEY;
> +		key.offset = start;
> +		if (!del_nr && path->slots[0] < btrfs_header_nritems(leaf)) {
> +			struct btrfs_key slot_key;
> +
> +			btrfs_item_key_to_cpu(leaf, &slot_key, path->slots[0]);
> +			if (btrfs_comp_cpu_keys(&key, &slot_key) > 0)
> +				path->slots[0]++;
>  		}
> +		setup_items_for_insert(root, path, &key,
> +				       &extent_item_size,
> +				       extent_item_size,
> +				       sizeof(struct btrfs_item) +
> +				       extent_item_size, 1);
> +		*key_inserted = 1;
>  	}
>  
>  	if (!replace_extent || !(*key_inserted))
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
