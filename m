Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728719AbeGPNds (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 09:33:48 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A1B8ADBD
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 13:06:23 +0000 (UTC)
Date: Mon, 16 Jul 2018 15:06:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Introduce mount time chunk <-> dev extent
 mapping check
Message-ID: <20180716130617.GG3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180709064203.32409-1-wqu@suse.com>
 <20180709064203.32409-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180709064203.32409-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2018 at 02:42:02PM +0800, Qu Wenruo wrote:
> This patch will introduce chunk <-> dev extent mapping check, to protect
> us against invalid dev extents or chunks.
> 
> Since chunk mapping is the fundamental infrastructure of btrfs, extra
> check at mount time could prevent a lot of unexpected behavior (BUG_ON).
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Links: https://bugzilla.kernel.org/show_bug.cgi?id=200403

Link:

> Links: https://bugzilla.kernel.org/show_bug.cgi?id=200407
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c |   7 ++
>  fs/btrfs/volumes.c | 173 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h |   2 +
>  3 files changed, 182 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 205092dc9390..068ca7498e94 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3075,6 +3075,13 @@ int open_ctree(struct super_block *sb,
>  	fs_info->generation = generation;
>  	fs_info->last_trans_committed = generation;
>  
> +	ret = btrfs_verify_dev_extents(fs_info);
> +	if (ret) {
> +		btrfs_err(fs_info,
> +			  "failed to verify dev extents against chunks: %d",
> +			  ret);
> +		goto fail_block_groups;
> +	}
>  	ret = btrfs_recover_balance(fs_info);
>  	if (ret) {
>  		btrfs_err(fs_info, "failed to recover balance: %d", ret);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e6a8e4aabc66..05e418cb37f3 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6440,6 +6440,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
>  	map->type = btrfs_chunk_type(leaf, chunk);
>  	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
> +	map->verified_stripes = 0;
>  	for (i = 0; i < num_stripes; i++) {
>  		map->stripes[i].physical =
>  			btrfs_stripe_offset_nr(leaf, chunk, i);
> @@ -7295,3 +7296,175 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info)
>  		fs_devices = fs_devices->seed;
>  	}
>  }
> +
> +static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripes)
> +{
> +	switch (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
> +	case BTRFS_BLOCK_GROUP_RAID0:
> +		return div_u64(chunk_len, num_stripes);
> +	case BTRFS_BLOCK_GROUP_RAID10:
> +		return div_u64(chunk_len * 2, num_stripes);
> +	case BTRFS_BLOCK_GROUP_RAID5:
> +		return div_u64(chunk_len, num_stripes - 1);
> +	case BTRFS_BLOCK_GROUP_RAID6:
> +		return div_u64(chunk_len, num_stripes - 2);
> +	default:
> +		return chunk_len;
> +	}
> +}

There are already too many hardcoded values for the raid profiles,
please don't add another one unless really necessary and use existing
predefined constants or helpers (eg. nr_data_stripes or
btrfs_raid_array).

> +static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
> +				 u64 chunk_offset, u64 devid,
> +				 u64 physical_offset, u64 physical_len)
> +{
> +	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
> +	struct extent_map *em;
> +	struct map_lookup *map;
> +	u64 stripe_len;
> +	bool found = false;

This variable is only set and never checked.

> +	int ret = 0;
> +	int i;
> +
> +	read_lock(&em_tree->lock);
> +	em = lookup_extent_mapping(em_tree, chunk_offset, 1);
> +	read_unlock(&em_tree->lock);
> +
> +	if (!em) {
> +		ret = -EUCLEAN;
> +		btrfs_err(fs_info,
> +		"dev extent (%llu, %llu) doesn't have corresponding chunk",
> +			  devid, physical_offset);
> +		goto out;
> +	}
> +
> +	map = em->map_lookup;
> +	stripe_len = calc_stripe_length(map->type, em->len, map->num_stripes);
> +	if (physical_len != stripe_len) {
> +		btrfs_err(fs_info,
> +"dev extent (%llu, %llu) length doesn't match with chunk %llu, have %llu expect %llu",
> +			  devid, physical_offset, em->start, physical_len,
> +			  stripe_len);
> +		ret = -EUCLEAN;
> +		goto out;
> +	}
> +
> +	for (i = 0; i < map->num_stripes; i++) {
> +		if (map->stripes[i].dev->devid == devid &&
> +		    map->stripes[i].physical == physical_offset) {
> +			found = true;

2nd time set

> +			if (map->verified_stripes >= map->num_stripes) {
> +				btrfs_err(fs_info,
> +			"too many dev extent for chunk %llu is detected",
> +					  em->start);
> +				ret = -EUCLEAN;
> +				goto out;
> +			}
> +			map->verified_stripes++;
> +			break;
> +		}
> +	}
> +out:
> +	free_extent_map(em);
> +	return ret;
> +}
> +
> +static int verify_chunk_dev_extent_mapping(struct btrfs_fs_info *fs_info)
> +{
> +	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
> +	struct extent_map *em;
> +	struct rb_node *node;
> +	int ret = 0;
> +
> +	read_lock(&em_tree->lock);
> +	for (node = rb_first(&em_tree->map); node; node = rb_next(node)) {
> +		em = rb_entry(node, struct extent_map, rb_node);
> +		if (em->map_lookup->num_stripes !=
> +		    em->map_lookup->verified_stripes) {
> +			btrfs_err(fs_info,
> +			"chunk %llu has missing dev extent, have %d expect %d",
> +				  em->start, em->map_lookup->verified_stripes,
> +				  em->map_lookup->num_stripes);
> +			ret = -EUCLEAN;
> +			goto out;
> +		}
> +	}
> +out:
> +	read_unlock(&em_tree->lock);
> +	return ret;
> +}
> +
> +/*
> + * Ensure all dev extents are mapped to correct chunk.
> + * Or later chunk allocation/free would cause unexpected behavior.
> + *
> + * NOTE: This will iterate through the whole device tree, which should be
> + * at the same size level of chunk tree.
> + * This would increase mount time by a tiny fraction.
> + */
> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_root *root = fs_info->dev_root;
> +	struct btrfs_key key;
> +	int ret = 0;
> +
> +	key.objectid = 1;
> +	key.type = BTRFS_DEV_EXTENT_KEY;
> +	key.offset = 0;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	path->reada = READA_FORWARD;
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
> +		ret = btrfs_next_item(root, path);
> +		if (ret < 0)
> +			goto out;
> +		/* No dev extents at all? Not good */
> +		if (ret > 0) {
> +			ret = -EUCLEAN;
> +			goto out;
> +		}
> +	}
> +	while (1) {
> +		struct extent_buffer *leaf = path->nodes[0];
> +		struct btrfs_dev_extent *dext;
> +		int slot = path->slots[0];
> +		u64 chunk_offset;
> +		u64 physical_offset;
> +		u64 physical_len;
> +		u64 devid;
> +
> +		btrfs_item_key_to_cpu(leaf, &key, slot);
> +		if (key.type != BTRFS_DEV_EXTENT_KEY)
> +			break;
> +		devid = key.objectid;
> +		physical_offset = key.offset;
> +
> +		dext = btrfs_item_ptr(leaf, slot, struct btrfs_dev_extent);
> +		chunk_offset = btrfs_dev_extent_chunk_offset(leaf, dext);
> +		physical_len = btrfs_dev_extent_length(leaf, dext);
> +
> +		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
> +					    physical_offset, physical_len);
> +		if (ret < 0)
> +			goto out;
> +		ret = btrfs_next_item(root, path);
> +		if (ret < 0)
> +			goto out;
> +		if (ret > 0) {
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	/* Ensure all chunks have corresponding dev extents */
> +	ret = verify_chunk_dev_extent_mapping(fs_info);
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 6d4f38ad9f5c..4301bf2d0534 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -345,6 +345,7 @@ struct map_lookup {
>  	u64 stripe_len;
>  	int num_stripes;
>  	int sub_stripes;
> +	int verified_stripes; /* For mount time dev extent verification */
>  	struct btrfs_bio_stripe stripes[];
>  };
>  
> @@ -559,5 +560,6 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>  bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
>  					struct btrfs_device *failing_dev);
> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
>  
>  #endif
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
