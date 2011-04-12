From: WuBo <wu.bo@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] Btrfs: about chunk tree backups
Date: Tue, 12 Apr 2011 16:47:16 +0800
Message-ID: <4DA41194.1070508@cn.fujitsu.com>
References: <4D9D6E7E.3080307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9D6E7E.3080307@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


If no one has comments on this, I'll work on finishing it.

Thanks
Wubo

On 04/07/2011 03:57 PM, WuBo wrote:
> hi,all
> 
> I've been diging into the idea of chunk tree backups. Here is the 
> predesign, before finishing chunk alloc, the first block in this 
> chunk will be written in some information, these information will be 
> useful for chunk tree rebuilding if crash, also the first block will 
> be moved into fs_info->freed_extents[2], just as the super block.
> what we should do is making some changes in these functions:
> btrfs_make_block_group
> btrfs_read_block_groups
> btrfs_remove_block_group  
> what do you think about it?
> 
> There's something strait with backward compatibility. The mkfs.btrfs
> has been made several chunks when creating the fs. It also need to do 
> the same thing as above. But it will be confusing in some situations 
> such as old fs mount on new kernel. I think it's better to add a 
> incompat flag in super block to mark weather the fs is formaten with
> new mkfs.btrfs.
> 
> if that's OK, TODOLIST:
> -design the information on chunk's first block to make it uniqueness
> -backward compatibility handle(for example:fix mkfs.btrfs)
> 
> Signed-off-by: Wu Bo <wu.bo@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h       |   13 +++-
>  fs/btrfs/extent-tree.c |  135 +++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/volumes.c     |  168 ++++++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/volumes.h     |   25 +++++++
>  4 files changed, 322 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8b4b9d1..580dd1c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -41,6 +41,7 @@ extern struct kmem_cache *btrfs_transaction_cachep;
>  extern struct kmem_cache *btrfs_bit_radix_cachep;
>  extern struct kmem_cache *btrfs_path_cachep;
>  struct btrfs_ordered_sum;
> +struct map_lookup;
>  
>  #define BTRFS_MAGIC "_BHRfS_M"
>  
> @@ -408,6 +409,7 @@ struct btrfs_super_block {
>  #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
>  #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
>  #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
> +#define BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP (1ULL << 4)
>  
>  #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
> @@ -415,7 +417,8 @@ struct btrfs_super_block {
>  	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
>  	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
>  	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
> -	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)
> +	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
> +	 BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP)
>  
>  /*
>   * A leaf is full of items. offset and size tell us where to find
> @@ -2172,10 +2175,12 @@ int btrfs_extent_readonly(struct btrfs_root *root, u64 bytenr);
>  int btrfs_free_block_groups(struct btrfs_fs_info *info);
>  int btrfs_read_block_groups(struct btrfs_root *root);
>  int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr);
> +
>  int btrfs_make_block_group(struct btrfs_trans_handle *trans,
> -			   struct btrfs_root *root, u64 bytes_used,
> -			   u64 type, u64 chunk_objectid, u64 chunk_offset,
> -			   u64 size);
> +			   struct btrfs_root *root, struct map_lookup *map,
> +			   u64 bytes_used, u64 type, u64 chunk_objectid,
> +			   u64 chunk_offset, u64 size);
> +
>  int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root, u64 group_start);
>  u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f1db57d..27ea7d5 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -23,6 +23,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/kthread.h>
>  #include <linux/slab.h>
> +#include <linux/buffer_head.h>
>  #include "compat.h"
>  #include "hash.h"
>  #include "ctree.h"
> @@ -231,6 +232,113 @@ static int exclude_super_stripes(struct btrfs_root *root,
>  	return 0;
>  }
>  
> +static int exclude_chunk_stripes_header_slow(struct btrfs_root *root,
> +					struct btrfs_block_group_cache *cache)
> +{
> +	int i;
> +	int nr;
> +	u64 devid;
> +	u64 physical;
> +	int stripe_len;
> +	u64 stripe_num;
> +	u64 *logical;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +	struct btrfs_chunk *chunk;
> +	struct btrfs_key found_key;
> +	struct extent_buffer *leaf;
> +	int ret;
> +
> +	ret = 0;
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -1;
> +
> +	root = root->fs_info->chunk_root;
> +
> +	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> +	key.offset = cache->key.objectid;
> +	key.type = BTRFS_CHUNK_ITEM_KEY;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret != 0)
> +		goto error;
> +
> +	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
> +
> +	if (found_key.objectid != BTRFS_FIRST_CHUNK_TREE_OBJECTID ||
> +		btrfs_key_type(&found_key) != BTRFS_CHUNK_ITEM_KEY ||
> +		found_key.offset != cache->key.objectid) {
> +		ret = -1;
> +		goto error;
> +	}
> +
> +	leaf = path->nodes[0];
> +	chunk = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_chunk);
> +	stripe_num = btrfs_chunk_num_stripes(leaf, chunk);
> +
> +	i = 0;
> +	while (i < stripe_num) {
> +		devid = btrfs_stripe_devid_nr(leaf, chunk, i);
> +		physical = btrfs_stripe_offset_nr(leaf, chunk, i);
> +
> +		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
> +				cache->key.objectid, physical, devid, &logical,
> +				&nr, &stripe_len);
> +		while (nr--) {
> +			add_excluded_extent(root, logical[nr], stripe_len);
> +
> +			/* FIXME.here just use the bytes_super */
> +			cache->bytes_super += stripe_len;
> +		}
> +
> +		kfree(logical);
> +		i++;
> +	}
> +
> +error:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
> +static int exclude_chunk_stripes_header(struct btrfs_root *root,
> +					struct btrfs_block_group_cache *cache,
> +					struct map_lookup *map)
> +{
> +	int i;
> +	int nr;
> +	u64 devid;
> +	u64 physical;
> +	int stripe_len;
> +	u64 *logical;
> +	int ret;
> +
> +	if (!map)
> +		goto slow;
> +
> +	i = 0;
> +	while (i < map->num_stripes) {
> +		devid = map->stripes[i].dev->devid;
> +		physical = map->stripes[i].physical;
> +		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
> +				cache->key.objectid, physical, devid, &logical,
> +				&nr, &stripe_len);
> +		while (nr--) {
> +			add_excluded_extent(root, logical[nr], stripe_len);
> +
> +			/* FIXME.here just use the bytes_super */
> +			cache->bytes_super += stripe_len;
> +		}
> +
> +		kfree(logical);
> +		i++;
> +	}
> +
> +	return 0;
> +slow:
> +	return exclude_chunk_stripes_header_slow(root, cache);
> +}
> +
>  static struct btrfs_caching_control *
>  get_caching_control(struct btrfs_block_group_cache *cache)
>  {
> @@ -8402,6 +8510,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>  	struct extent_buffer *leaf;
>  	int need_clear = 0;
>  	u64 cache_gen;
> +	u64 feature;
>  
>  	root = info->extent_root;
>  	key.objectid = 0;
> @@ -8470,6 +8579,15 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>  		exclude_super_stripes(root, cache);
>  
>  		/*
> +		 * FIXME, it's should consider the backward compatibility
> +		 * also with the user tools for example  mkfs.btrfs
> +		 * Maybe we can judge sb flags to determine whether exclude it
> +		 */
> +		feature = btrfs_super_incompat_flags(&root->fs_info->super_copy);
> +		if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP)
> +			exclude_chunk_stripes_header(root, cache, NULL);
> +
> +		/*
>  		 * check for two cases, either we are full, and therefore
>  		 * don't need to bother with the caching work since we won't
>  		 * find any space, or we are empty, and we can just add all
> @@ -8533,13 +8651,14 @@ error:
>  }
>  
>  int btrfs_make_block_group(struct btrfs_trans_handle *trans,
> -			   struct btrfs_root *root, u64 bytes_used,
> -			   u64 type, u64 chunk_objectid, u64 chunk_offset,
> -			   u64 size)
> +			   struct btrfs_root *root, struct map_lookup *map,
> +			   u64 bytes_used, u64 type, u64 chunk_objectid,
> +			   u64 chunk_offset, u64 size)
>  {
>  	int ret;
>  	struct btrfs_root *extent_root;
>  	struct btrfs_block_group_cache *cache;
> +	u64 feature;
>  
>  	extent_root = root->fs_info->extent_root;
>  
> @@ -8577,6 +8696,10 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>  	cache->cached = BTRFS_CACHE_FINISHED;
>  	exclude_super_stripes(root, cache);
>  
> +	feature = btrfs_super_incompat_flags(&root->fs_info->super_copy);
> +	if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP)
> +		exclude_chunk_stripes_header(root, cache, map);
> +
>  	add_new_free_space(cache, root->fs_info, chunk_offset,
>  			   chunk_offset + size);
>  
> @@ -8615,6 +8738,12 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  	struct inode *inode;
>  	int ret;
>  	int factor;
> +	u64 feature;
> +
> +	/* erase the first block which record this chunk info */
> +	feature = btrfs_super_incompat_flags(&root->fs_info->super_copy);
> +	if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP)
> +		erase_chunk_stripes_header(root, group_start);
>  
>  	root = root->fs_info->extent_root;
>  
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 94334d9..a9ac2b1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -33,17 +33,6 @@
>  #include "volumes.h"
>  #include "async-thread.h"
>  
> -struct map_lookup {
> -	u64 type;
> -	int io_align;
> -	int io_width;
> -	int stripe_len;
> -	int sector_size;
> -	int num_stripes;
> -	int sub_stripes;
> -	struct btrfs_bio_stripe stripes[];
> -};
> -
>  static int init_first_rw_device(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *root,
>  				struct btrfs_device *device);
> @@ -2667,7 +2656,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	BUG_ON(ret);
>  	free_extent_map(em);
>  
> -	ret = btrfs_make_block_group(trans, extent_root, 0, type,
> +	ret = btrfs_make_block_group(trans, extent_root, map, 0, type,
>  				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
>  				     start, *num_bytes);
>  	BUG_ON(ret);
> @@ -2761,6 +2750,151 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> +static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
> +{
> +	char b[BDEVNAME_SIZE];
> +
> +	if (uptodate) {
> +		set_buffer_uptodate(bh);
> +	} else {
> +		if (!buffer_eopnotsupp(bh) && printk_ratelimit()) {
> +			printk(KERN_WARNING "lost page write due to I/O error on %s\n",
> +				       bdevname(bh->b_bdev, b));
> +		}
> +		clear_buffer_uptodate(bh);
> +	}
> +	unlock_buffer(bh);
> +	put_bh(bh);
> +}
> +
> +static int mark_chunk_stripes_header(struct btrfs_root *root,
> +		struct map_lookup *map, u64 chunk_offset,
> +		u64 chunk_size, u64 stripe_size, u64 flag)
> +{
> +	struct buffer_head *bh;
> +	struct btrfs_device *device = NULL;
> +	struct btrfs_stripe_header header;
> +	u64 bytenr;
> +	u32 sectorsize;
> +	int index;
> +	int ret;
> +
> +	ret = 0;
> +	index = 0;
> +	while (index < map->num_stripes) {
> +		device = map->stripes[index].dev;
> +		bytenr = map->stripes[index].physical;
> +		sectorsize = root->sectorsize;
> +		do_div(bytenr, sectorsize);
> +		bh = __getblk(device->bdev, bytenr, sectorsize);
> +		if (!bh)
> +			return -1;
> +
> +		memset(&header, 0, sizeof(header));
> +		header.magic =	cpu_to_le64(BTRFS_STRIPE_HEADER_MAGIC);
> +		header.chunk_offset = cpu_to_le64(chunk_offset);
> +		header.chunk_size = cpu_to_le64(chunk_size);
> +		header.stripe_size = cpu_to_le64(stripe_size);
> +		header.stripe_index = cpu_to_le32(index);
> +		header.flag = cpu_to_le64(flag);
> +		memcpy(header.fsid, root->fs_info->fsid, BTRFS_FSID_SIZE);
> +
> +		memset(bh->b_data, 0, sectorsize);
> +		memcpy(bh->b_data, &header, sizeof(header));
> +
> +		get_bh(bh);
> +		set_buffer_uptodate(bh);
> +		lock_buffer(bh);
> +		bh->b_end_io = btrfs_end_buffer_write_sync;
> +
> +		ret = submit_bh(WRITE_SYNC, bh);
> +		wait_on_buffer(bh);
> +		brelse(bh);
> +
> +		index++;
> +	}
> +	return ret;
> +}
> +
> +int erase_chunk_stripes_header(struct btrfs_root *root,
> +					u64 chunk_offset)
> +{
> +	int i;
> +	int ret;
> +	u64 devid;
> +	u64 physical;
> +	u32 sectorsize;
> +	u64 stripe_num;
> +	u8 uuid[BTRFS_UUID_SIZE];
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +	struct btrfs_chunk *chunk;
> +	struct btrfs_key found_key;
> +	struct extent_buffer *leaf;
> +	struct btrfs_device *device;
> +	struct buffer_head *bh;
> +
> +	ret = 0;
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -1;
> +
> +	root = root->fs_info->chunk_root;
> +
> +	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> +	key.offset = chunk_offset;
> +	key.type = BTRFS_CHUNK_ITEM_KEY;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret != 0) {
> +		ret = -1;
> +		goto error;
> +	}
> +
> +	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
> +
> +	if (found_key.objectid != BTRFS_FIRST_CHUNK_TREE_OBJECTID ||
> +		btrfs_key_type(&found_key) != BTRFS_CHUNK_ITEM_KEY ||
> +		found_key.offset != chunk_offset) {
> +		ret = -1;
> +		goto error;
> +	}
> +
> +	leaf = path->nodes[0];
> +	chunk = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_chunk);
> +	stripe_num = btrfs_chunk_num_stripes(leaf, chunk);
> +	i = 0;
> +	while (i < stripe_num) {
> +		devid = btrfs_stripe_devid_nr(leaf, chunk, i);
> +		physical = btrfs_stripe_offset_nr(leaf, chunk, i);
> +		read_extent_buffer(leaf, uuid, (unsigned long)
> +				btrfs_stripe_dev_uuid_nr(chunk, i),
> +				BTRFS_UUID_SIZE);
> +		device = btrfs_find_device(root, devid, uuid, NULL);
> +
> +		sectorsize = root->sectorsize;
> +		do_div(physical, sectorsize);
> +		bh = __getblk(device->bdev, physical, sectorsize);
> +		if (!bh) {
> +			i++;
> +			continue;
> +		}
> +		memset(bh->b_data, 0, sectorsize);
> +		get_bh(bh);
> +		set_buffer_uptodate(bh);
> +		lock_buffer(bh);
> +		bh->b_end_io = btrfs_end_buffer_write_sync;
> +
> +		submit_bh(WRITE_SYNC, bh);
> +		wait_on_buffer(bh);
> +		brelse(bh);
> +		i++;
> +	}
> +error:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>  /*
>   * Chunk allocation falls into two parts. The first part does works
>   * that make the new allocated chunk useable, but not do any operation
> @@ -2777,6 +2911,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	struct map_lookup *map;
>  	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
>  	int ret;
> +	u64 feature;
>  
>  	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
>  			      &chunk_offset);
> @@ -2791,6 +2926,15 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
>  				   chunk_size, stripe_size);
>  	BUG_ON(ret);
> +
> +	feature = btrfs_super_incompat_flags(&extent_root->fs_info->super_copy);
> +	if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP) {
> +		ret = mark_chunk_stripes_header(extent_root, map, chunk_offset,
> +					chunk_size, stripe_size, type);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 7af6144..7166a3b 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -146,6 +146,31 @@ struct btrfs_device_info {
>  	u64 max_avail;
>  };
>  
> +struct map_lookup {
> +	u64 type;
> +	int io_align;
> +	int io_width;
> +	int stripe_len;
> +	int sector_size;
> +	int num_stripes;
> +	int sub_stripes;
> +	struct btrfs_bio_stripe stripes[];
> +};
> +
> +#define BTRFS_STRIPE_HEADER_MAGIC 111111
> +
> +struct btrfs_stripe_header {
> +	__le64 magic;
> +	__le64 chunk_offset;
> +	__le64 chunk_size;
> +	__le64 stripe_size;
> +	__le32 stripe_index;
> +	__le64 flag;
> +	u8 fsid[BTRFS_FSID_SIZE];
> +} __attribute__ ((__packed__));
> +
> +int erase_chunk_stripes_header(struct btrfs_root *root, u64 chunk_offset);
> +
>  /* Used to sort the devices by max_avail(descending sort) */
>  int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
>  
