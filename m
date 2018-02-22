Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752804AbeBVIgV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 03:36:21 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
References: <20180222045215.16426-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bc11f64d-5e5a-54d0-79c1-1459f3eb7c68@suse.com>
Date: Thu, 22 Feb 2018 10:36:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180222045215.16426-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.02.2018 06:52, Qu Wenruo wrote:
> btrfs_read_block_groups() is used to build up the block group cache for
> all block groups, so it will iterate all block group items in extent
> tree.
> 
> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
> thousands times, which is the most time consuming part of mounting
> btrfs.
> 
> So this patch will try to speed it up by:
> 
> 1) Avoid unnecessary readahead
>    We were using READA_FORWARD to search for block group item.
>    However block group items are in fact scattered across quite a lot of
>    leaves. Doing readahead will just waste our IO (especially important
>    for HDD).
> 
>    In real world case, for a filesystem with 3T used space, it would
>    have about 50K extent tree leaves, but only have 3K block group
>    items. Meaning we need to iterate 16 leaves to meet one block group
>    on average.
> 
>    So readahead won't help but waste slow HDD seeks.
> 
> 2) Use chunk mapping to locate block group items
>    Since one block group item always has one corresponding chunk item,
>    we could use chunk mapping to get the block group item size.
> 
>    With block group item size, we can do a pinpoint tree search, instead
>    of searching with some uncertain value and do forward search.
> 
>    In some case, like next BLOCK_GROUP_ITEM is in the next leaf of
>    current path, we could save such unnecessary tree block read.
> 
> Cc: Ellis H. Wilson III <ellisw@panasas.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Since all my TB level storage is all occupied by my NAS, any feedback
> (especially for the real world mount speed change) is welcome.
> ---
>  fs/btrfs/extent-tree.c | 88 +++++++++++++++-----------------------------------
>  1 file changed, 26 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2f4328511ac8..a3faa0cbe056 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9713,60 +9713,6 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  	return ret;
>  }
>  
> -static int find_first_block_group(struct btrfs_fs_info *fs_info,
> -				  struct btrfs_path *path,
> -				  struct btrfs_key *key)
> -{
> -	struct btrfs_root *root = fs_info->extent_root;
> -	int ret = 0;
> -	struct btrfs_key found_key;
> -	struct extent_buffer *leaf;
> -	int slot;
> -
> -	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
> -	if (ret < 0)
> -		goto out;
> -
> -	while (1) {
> -		slot = path->slots[0];
> -		leaf = path->nodes[0];
> -		if (slot >= btrfs_header_nritems(leaf)) {
> -			ret = btrfs_next_leaf(root, path);
> -			if (ret == 0)
> -				continue;
> -			if (ret < 0)
> -				goto out;
> -			break;
> -		}
> -		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> -
> -		if (found_key.objectid >= key->objectid &&
> -		    found_key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
> -			struct extent_map_tree *em_tree;
> -			struct extent_map *em;
> -
> -			em_tree = &root->fs_info->mapping_tree.map_tree;
> -			read_lock(&em_tree->lock);
> -			em = lookup_extent_mapping(em_tree, found_key.objectid,
> -						   found_key.offset);
> -			read_unlock(&em_tree->lock);
> -			if (!em) {
> -				btrfs_err(fs_info,
> -			"logical %llu len %llu found bg but no related chunk",
> -					  found_key.objectid, found_key.offset);
> -				ret = -ENOENT;
> -			} else {
> -				ret = 0;
> -			}
> -			free_extent_map(em);
> -			goto out;
> -		}
> -		path->slots[0]++;
> -	}
> -out:
> -	return ret;
> -}
> -
>  void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
>  {
>  	struct btrfs_block_group_cache *block_group;
> @@ -9988,12 +9934,15 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  {
>  	struct btrfs_path *path;
>  	int ret;
> +	struct btrfs_mapping_tree *map_tree = &info->mapping_tree;
> +	struct btrfs_root *extent_root = info->extent_root;
>  	struct btrfs_block_group_cache *cache;
>  	struct btrfs_space_info *space_info;
>  	struct btrfs_key key;
>  	struct btrfs_key found_key;
>  	struct extent_buffer *leaf;
>  	int need_clear = 0;
> +	u64 cur = 0;
>  	u64 cache_gen;
>  	u64 feature;
>  	int mixed;
> @@ -10001,13 +9950,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  	feature = btrfs_super_incompat_flags(info->super_copy);
>  	mixed = !!(feature & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS);
>  
> -	key.objectid = 0;
> -	key.offset = 0;
> -	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> -	path->reada = READA_FORWARD;
>  
>  	cache_gen = btrfs_super_cache_generation(info->super_copy);
>  	if (btrfs_test_opt(info, SPACE_CACHE) &&
> @@ -10017,10 +9962,30 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  		need_clear = 1;
>  
>  	while (1) {
> -		ret = find_first_block_group(info, path, &key);
> -		if (ret > 0)
> +		struct extent_map *em;
> +
> +		read_lock(&map_tree->map_tree.lock);
> +		em = lookup_extent_mapping(&map_tree->map_tree, cur,
> +					   ((u64)-1) - cur);
> +		read_unlock(&map_tree->map_tree.lock);
> +		if (!em)
>  			break;
> -		if (ret != 0)
> +
> +		key.objectid = em->start;
> +		key.offset = em->len;
> +		key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
> +		cur = em->start + em->len;
> +		free_extent_map(em);
> +
> +		ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
> +		if (ret > 0) {
> +			WARN(1, KERN_ERR
> +			"chunk [%llu %llu) doesn't has its block group item\n",

I'd rephrase this to "chunk [%llu %llu) doesn't have matching block
group item"

> +			     key.objectid, key.objectid + key.offset);
> +			ret = -ENOENT;
> +			goto error;
> +		}

Looks good, howevr when the time for merging comes I'd rather have this
code be part of a function named find_block_group or some such. Let's
see if this code brings any improvements and then bikeshed on the details.

> +		if (ret < 0)
>  			goto error;
>  
>  		leaf = path->nodes[0];
> @@ -10062,7 +10027,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  			goto error;
>  		}
>  
> -		key.objectid = found_key.objectid + found_key.offset;
>  		btrfs_release_path(path);
>  
>  		/*
> 
