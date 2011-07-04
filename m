From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [PATCH] Btrfs: Make kernel support chunk tree backup
Date: Mon, 04 Jul 2011 16:07:39 +0800
Message-ID: <4E1174CB.1030509@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been diging into the idea of chunk tree backups. Here is the 
design, before finishing chunk alloc, the first block in this 
chunk will be written in some information, these information will be 
useful for chunk tree rebuilding if crash, also the first block will 
be moved into fs_info->freed_extents[2], just as the super block.
after crash, we can search all the stripe header to get the whole view
of the chunk tree and rebuild it.

Also I consider the balance stuff, cause the relocation will remove
the block group. If then, I clear the stripe header for fear mistake.

To keep backward compatibility, BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP
will be added for a incompat flag. This means the chunk tree only with
the new kernel can be recovered if crash.

What we should do is making some changes in these functions:
btrfs_make_block_group
btrfs_read_block_groups
btrfs_remove_block_group  

I have tested this patch by rebuilding chunk tree through writting
and deleting data(using fstress.sh) repeatly, Also for stuffs like 
defragment balance and "add/delete device". But I appreciated if 
anybody do extra test for it still.

Signed-off-by: Wu Bo <wu.bo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   14 +++--
 fs/btrfs/extent-tree.c |   95 ++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c     |  144 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h     |   25 ++++++++
 4 files changed, 267 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2e61fe1..29e9f30 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -43,6 +43,7 @@ extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
+struct map_lookup;
 
 #define BTRFS_MAGIC "_BHRfS_M"
 
@@ -410,6 +411,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
 #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
+#define BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP (1ULL << 4)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -417,7 +419,8 @@ struct btrfs_super_block {
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
-	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
+	 BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -2179,11 +2182,12 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_root *root);
 int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 bytes_used,
-			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-			   u64 size);
+			   struct btrfs_root *root, struct map_lookup *map,
+			   u64 bytes_used, u64 type, u64 chunk_objectid,
+			   u64 chunk_offset, u64 size);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 group_start);
+			     struct btrfs_root *root, struct map_lookup *map,
+			     u64 group_start);
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9ee6bd5..81141ad 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kthread.h>
 #include <linux/slab.h>
+#include <linux/buffer_head.h>
 #include "compat.h"
 #include "hash.h"
 #include "ctree.h"
@@ -248,6 +249,60 @@ static int exclude_super_stripes(struct btrfs_root *root,
 	return 0;
 }
 
+static int exclude_chunk_stripes_header(struct btrfs_root *root,
+					struct btrfs_block_group_cache *cache,
+					struct map_lookup *map)
+{
+	int ret = 0;
+	int i;
+	u64 chunk_offset;
+	struct extent_map *em = NULL;
+	struct btrfs_mapping_tree *map_tree;
+
+	map_tree = &root->fs_info->mapping_tree;
+	chunk_offset = cache->key.objectid;
+
+	/* before read_block_groups, the mapping tree should be ready */
+	if (!map) {
+		read_lock(&map_tree->map_tree.lock);
+		em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
+		read_unlock(&map_tree->map_tree.lock);
+
+		/* here i made a strict check */
+		if (em && em->start == chunk_offset &&
+		    em->len == cache->key.offset)
+			map = (struct map_lookup *)em->bdev;
+		else
+			BUG_ON(1);
+	}
+
+	for (i = 0; i < map->num_stripes; i++) {
+		int nr;
+		int stripe_len;
+		u64 devid;
+		u64 physical;
+		u64 *logical;
+
+		devid = map->stripes[i].dev->devid;
+		physical = map->stripes[i].physical;
+		ret = btrfs_rmap_block(map_tree, chunk_offset, physical,
+				       devid, &logical, &nr, &stripe_len);
+		if (ret)
+			goto error;
+
+		while (nr--) {
+			add_excluded_extent(root, logical[nr],
+					    root->sectorsize);
+			cache->bytes_super += root->sectorsize;
+		}
+		kfree(logical);
+	}
+
+error:
+	free_extent_map(em);
+	return ret;
+}
+
 static struct btrfs_caching_control *
 get_caching_control(struct btrfs_block_group_cache *cache)
 {
@@ -8524,6 +8579,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	struct extent_buffer *leaf;
 	int need_clear = 0;
 	u64 cache_gen;
+	u64 feature;
 
 	root = info->extent_root;
 	key.objectid = 0;
@@ -8592,6 +8648,18 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		exclude_super_stripes(root, cache);
 
 		/*
+		 * it's should consider the backward compatibility.
+		 * in mkfs.btrfs, some chunks has already been created and
+		 * the incompat flag will be set.
+		 */
+		feature = btrfs_super_incompat_flags(&root->fs_info->super_copy);
+		if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP) {
+			ret = exclude_chunk_stripes_header(root, cache, NULL);
+			if (ret)
+				goto error;
+		}
+
+		/*
 		 * check for two cases, either we are full, and therefore
 		 * don't need to bother with the caching work since we won't
 		 * find any space, or we are empty, and we can just add all
@@ -8655,13 +8723,14 @@ error:
 }
 
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 bytes_used,
-			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-			   u64 size)
+			   struct btrfs_root *root, struct map_lookup *map,
+			   u64 bytes_used, u64 type, u64 chunk_objectid,
+			   u64 chunk_offset, u64 size)
 {
 	int ret;
 	struct btrfs_root *extent_root;
 	struct btrfs_block_group_cache *cache;
+	u64 feature;
 
 	extent_root = root->fs_info->extent_root;
 
@@ -8699,6 +8768,13 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->cached = BTRFS_CACHE_FINISHED;
 	exclude_super_stripes(root, cache);
 
+	feature = btrfs_super_incompat_flags(&root->fs_info->super_copy);
+	if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP) {
+		ret = exclude_chunk_stripes_header(root, cache, map);
+		if (ret)
+			return ret;
+	}
+
 	add_new_free_space(cache, root->fs_info, chunk_offset,
 			   chunk_offset + size);
 
@@ -8727,7 +8803,9 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 group_start)
+			     struct btrfs_root *root,
+			     struct map_lookup *map,
+			     u64 group_start)
 {
 	struct btrfs_path *path;
 	struct btrfs_block_group_cache *block_group;
@@ -8737,6 +8815,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	struct inode *inode;
 	int ret;
 	int factor;
+	u64 feature;
 
 	root = root->fs_info->extent_root;
 
@@ -8848,6 +8927,14 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		goto out;
 
 	ret = btrfs_del_item(trans, root, path);
+	if (ret)
+		goto out;
+
+	/* erase the first block which record this chunk info */
+	feature = btrfs_super_incompat_flags(&root->fs_info->super_copy);
+	if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP)
+		ret = erase_chunk_stripes_header(root, map);
+
 out:
 	btrfs_free_path(path);
 	return ret;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b9fb8c..a69255f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -23,6 +23,7 @@
 #include <linux/random.h>
 #include <linux/iocontext.h>
 #include <linux/capability.h>
+#include <linux/crc32c.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -1919,7 +1920,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 		BUG_ON(ret);
 	}
 
-	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset);
+	ret = btrfs_remove_block_group(trans, extent_root, map, chunk_offset);
 	BUG_ON(ret);
 
 	write_lock(&em_tree->lock);
@@ -2661,7 +2662,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 	free_extent_map(em);
 
-	ret = btrfs_make_block_group(trans, extent_root, 0, type,
+	ret = btrfs_make_block_group(trans, extent_root, map, 0, type,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     start, *num_bytes);
 	BUG_ON(ret);
@@ -2756,6 +2757,121 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
+{
+	if (uptodate)
+		set_buffer_uptodate(bh);
+	else
+		clear_buffer_uptodate(bh);
+
+	unlock_buffer(bh);
+	put_bh(bh);
+}
+
+static int mark_chunk_stripes_header(struct btrfs_root *extent_root,
+				     struct map_lookup *map,
+				     u64 chunk_offset,
+				     u64 chunk_size)
+{
+	struct buffer_head *bh;
+	struct btrfs_device *device = NULL;
+	struct btrfs_stripe_header *header;
+	u64 bytenr;
+	u64 blocknr;
+	u32 sectorsize;
+	u32 crc;
+	int index;
+	int ret;
+
+	ret = 0;
+	header = kzalloc(sizeof(*header), GFP_NOFS);
+	if (!header)
+		return -ENOMEM;
+
+	for (index = 0; index < map->num_stripes; index++) {
+		device = map->stripes[index].dev;
+		bytenr = map->stripes[index].physical;
+		blocknr = bytenr;
+		sectorsize = extent_root->sectorsize;
+		do_div(blocknr, sectorsize);
+		bh = __getblk(device->bdev, blocknr, sectorsize);
+		if (!bh) {
+			kfree(header);
+			return -EFAULT;
+		}
+
+		memset(header, 0, sizeof(*header));
+		header->tag = cpu_to_le64(BTRFS_STRIPE_HEADER_TAG);
+		header->owner = cpu_to_le64(extent_root->root_key.objectid);
+		header->devid = cpu_to_le64(device->devid);
+		header->dev_offset = cpu_to_le64(bytenr);
+		header->chunk_offset = cpu_to_le64(chunk_offset);
+		header->chunk_size = cpu_to_le64(chunk_size);
+		header->type = cpu_to_le64(map->type);
+		header->stripe_len = cpu_to_le64(map->stripe_len);
+		header->stripe_index = cpu_to_le32(index);
+		header->io_align = cpu_to_le32(map->io_align);
+		header->io_width = cpu_to_le32(map->io_width);
+		header->sector_size = cpu_to_le32(map->sector_size);
+		header->num_stripes = cpu_to_le16(map->num_stripes);
+		header->sub_stripes = cpu_to_le16(map->sub_stripes);
+		memcpy(header->uuid, device->uuid, BTRFS_UUID_SIZE);
+		memcpy(header->fsid, extent_root->fs_info->fsid, BTRFS_FSID_SIZE);
+		crc = crc32c(0, (unsigned char *)header, sizeof(*header));
+		header->crc = cpu_to_le32(crc);
+
+		memset(bh->b_data, 0, sectorsize);
+		memcpy(bh->b_data, header, sizeof(*header));
+
+		get_bh(bh);
+		set_buffer_uptodate(bh);
+		lock_buffer(bh);
+		bh->b_end_io = btrfs_end_buffer_write_sync;
+
+		submit_bh(WRITE_SYNC, bh);
+		wait_on_buffer(bh);
+		brelse(bh);
+	}
+
+	kfree(header);
+	return ret;
+}
+
+int erase_chunk_stripes_header(struct btrfs_root *root,
+			       struct map_lookup *map)
+{
+	int index;
+	u64 blocknr;
+	u32 sectorsize;
+	struct btrfs_device *device;
+	struct buffer_head *bh;
+
+	if (!map)
+		return -EIO;
+
+	for (index = 0; index < map->num_stripes; index++) {
+		device = map->stripes[index].dev;
+		blocknr = map->stripes[index].physical;
+		sectorsize = root->sectorsize;
+		do_div(blocknr, sectorsize);
+		bh = __getblk(device->bdev, blocknr, sectorsize);
+		if (!bh)
+			return -EFAULT;
+
+		memset(bh->b_data, 0, sectorsize);
+		get_bh(bh);
+		set_buffer_uptodate(bh);
+		lock_buffer(bh);
+		bh->b_end_io = btrfs_end_buffer_write_sync;
+
+		submit_bh(WRITE_SYNC, bh);
+		wait_on_buffer(bh);
+		brelse(bh);
+	}
+
+	return 0;
+}
+
 /*
  * Chunk allocation falls into two parts. The first part does works
  * that make the new allocated chunk useable, but not do any operation
@@ -2772,6 +2888,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct map_lookup *map;
 	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
 	int ret;
+	u64 feature;
 
 	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 			      &chunk_offset);
@@ -2786,6 +2903,15 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
 				   chunk_size, stripe_size);
 	BUG_ON(ret);
+
+	feature = btrfs_super_incompat_flags(&extent_root->fs_info->super_copy);
+	if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP) {
+		ret = mark_chunk_stripes_header(extent_root, map,
+						chunk_offset, chunk_size);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -2805,6 +2931,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	int ret;
+	u64 feature;
 
 	ret = find_next_chunk(fs_info->chunk_root,
 			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
@@ -2848,6 +2975,19 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 				   sys_chunk_offset, sys_chunk_size,
 				   sys_stripe_size);
 	BUG_ON(ret);
+
+	feature = btrfs_super_incompat_flags(&root->fs_info->super_copy);
+	if (feature & BTRFS_FEATURE_INCOMPAT_CHUNK_TREE_BACKUP) {
+		ret = mark_chunk_stripes_header(root, map,
+						chunk_offset,
+						chunk_size);
+		BUG_ON(ret);
+
+		ret = mark_chunk_stripes_header(root, sys_map,
+						sys_chunk_offset,
+						sys_chunk_size);
+		BUG_ON(ret);
+	}
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index cc2eada..101acf2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -157,6 +157,31 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
+#define BTRFS_STRIPE_HEADER_TAG 19860505
+
+struct btrfs_stripe_header {
+	u8 fsid[BTRFS_FSID_SIZE];
+	u8 uuid[BTRFS_UUID_SIZE];
+	__le64 tag;
+	__le64 owner;
+	__le64 devid;
+	__le64 dev_offset;
+	__le64 chunk_offset;
+	__le64 chunk_size;
+	__le64 type;
+	__le64 stripe_len;
+	__le32 stripe_index;
+	__le32 io_align;
+	__le32 io_width;
+	__le32 sector_size;
+	__le16 num_stripes;
+	__le16 sub_stripes;
+	__le32 crc;
+} __attribute__ ((__packed__));
+
+int erase_chunk_stripes_header(struct btrfs_root *root,
+			       struct map_lookup *map);
+
 /* Used to sort the devices by max_avail(descending sort) */
 int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
 
-- 
1.7.3.1
