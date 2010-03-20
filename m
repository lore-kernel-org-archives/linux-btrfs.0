From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: [PATCH 2/4] btrfs-convert: Add extent iteration functions.
Date: Sat, 20 Mar 2010 00:26:49 -0400
Message-ID: <20100320042649.GA17106@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A filesystem can have disk extents in arbitrary places on the disk, as
well as extents that must be read into memory because they have
compression or encryption btrfs doesn't support. These extents can be
passed to the new extent iteration functions, which will handle all the
details of alignment, allocation, etc.
---
 convert.c |  604 ++++++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 401 insertions(+), 203 deletions(-)

diff --git a/convert.c b/convert.c
index c48f8ba..bd91990 100644
--- a/convert.c
+++ b/convert.c
@@ -357,7 +357,7 @@ error:
 }
 
 static int read_disk_extent(struct btrfs_root *root, u64 bytenr,
-		            u32 num_bytes, char *buffer)
+		            u64 num_bytes, char *buffer)
 {
 	int ret;
 	struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
@@ -371,6 +371,23 @@ fail:
 		ret = -1;
 	return ret;
 }
+
+static int write_disk_extent(struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, const char *buffer)
+{
+	int ret;
+	struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
+
+	ret = pwrite(fs_devs->latest_bdev, buffer, num_bytes, bytenr);
+	if (ret != num_bytes)
+		goto fail;
+	ret = 0;
+fail:
+	if (ret > 0)
+		ret = -1;
+	return ret;
+}
+
 /*
  * Record a file extent. Do all the required works, such as inserting
  * file extent item, inserting extent item and backref item into extent
@@ -378,8 +395,7 @@ fail:
  */
 static int record_file_extent(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 objectid,
-			      struct btrfs_inode_item *inode,
-			      u64 file_pos, u64 disk_bytenr,
+			      u64 *inode_nbytes, u64 file_pos, u64 disk_bytenr,
 			      u64 num_bytes, int checksum)
 {
 	int ret;
@@ -391,7 +407,6 @@ static int record_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_path path;
 	struct btrfs_extent_item *ei;
 	u32 blocksize = root->sectorsize;
-	u64 nbytes;
 
 	if (disk_bytenr == 0) {
 		ret = btrfs_insert_file_extent(trans, root, objectid,
@@ -450,8 +465,7 @@ static int record_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
 	btrfs_mark_buffer_dirty(leaf);
 
-	nbytes = btrfs_stack_inode_nbytes(inode) + num_bytes;
-	btrfs_set_stack_inode_nbytes(inode, nbytes);
+	*inode_nbytes += num_bytes;
 
 	btrfs_release_path(root, &path);
 
@@ -492,95 +506,355 @@ fail:
 	return ret;
 }
 
-static int record_file_blocks(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root, u64 objectid,
-			      struct btrfs_inode_item *inode,
-			      u64 file_block, u64 disk_block,
-			      u64 num_blocks, int checksum)
-{
-	u64 file_pos = file_block * root->sectorsize;
-	u64 disk_bytenr = disk_block * root->sectorsize;
-	u64 num_bytes = num_blocks * root->sectorsize;
-	return record_file_extent(trans, root, objectid, inode, file_pos,
-				  disk_bytenr, num_bytes, checksum);
-}
-
-struct blk_iterate_data {
+struct extent_iterate_data {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
-	struct btrfs_inode_item *inode;
+	u64 *inode_nbytes;
 	u64 objectid;
-	u64 first_block;
-	u64 disk_block;
-	u64 num_blocks;
-	u64 boundary;
-	int checksum;
-	int errcode;
+	int checksum, packing;
+	u64 last_file_off;
+	u64 total_size;
+	enum {EXTENT_ITERATE_TYPE_NONE, EXTENT_ITERATE_TYPE_MEM,
+	      EXTENT_ITERATE_TYPE_DISK} type;
+	u64 size;
+	u64 file_off; /* always aligned to sectorsize */
+	char *data; /* for mem */
+	u64 disk_off; /* for disk */
 };
 
-static int block_iterate_proc(ext2_filsys ext2_fs,
-			      u64 disk_block, u64 file_block,
-		              struct blk_iterate_data *idata)
+static u64 extent_boundary(struct btrfs_root *root, u64 extent_start)
 {
-	int ret;
-	int sb_region;
-	int do_barrier;
-	struct btrfs_root *root = idata->root;
-	struct btrfs_trans_handle *trans = idata->trans;
-	struct btrfs_block_group_cache *cache;
-	u64 bytenr = disk_block * root->sectorsize;
-
-	sb_region = intersect_with_sb(bytenr, root->sectorsize);
-	do_barrier = sb_region || disk_block >= idata->boundary;
-	if ((idata->num_blocks > 0 && do_barrier) ||
-	    (file_block > idata->first_block + idata->num_blocks) ||
-	    (disk_block != idata->disk_block + idata->num_blocks)) {
-		if (idata->num_blocks > 0) {
-			ret = record_file_blocks(trans, root, idata->objectid,
-					idata->inode, idata->first_block,
-					idata->disk_block, idata->num_blocks,
-					idata->checksum);
-			if (ret)
-				goto fail;
-			idata->first_block += idata->num_blocks;
-			idata->num_blocks = 0;
+	int i;
+	u64 offset;
+	u64 boundary = (u64)-1;
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		offset = btrfs_sb_offset(i);
+		offset &= ~((u64)STRIPE_LEN - 1);
+		if (offset > extent_start) {
+			boundary = offset;
+			break;
+		}
+		if (offset + STRIPE_LEN > extent_start) {
+			boundary = offset + STRIPE_LEN;
+			break;
 		}
-		if (file_block > idata->first_block) {
-			ret = record_file_blocks(trans, root, idata->objectid,
-					idata->inode, idata->first_block,
-					0, file_block - idata->first_block,
-					idata->checksum);
+	}
+
+	struct btrfs_block_group_cache *cache;
+	cache = btrfs_lookup_block_group(root->fs_info, extent_start);
+	BUG_ON(!cache);
+	offset = cache->key.objectid + cache->key.offset;
+	return min_t(u64, boundary, offset);
+}
+
+static int commit_disk_extent(struct extent_iterate_data *priv,
+			      u64 file_pos, u64 disk_bytenr, u64 num_bytes)
+{
+	u64 boundary;
+	int ret;
+	if (disk_bytenr == 0)
+		return record_file_extent(priv->trans, priv->root,
+					  priv->objectid, priv->inode_nbytes,
+					  file_pos, disk_bytenr, num_bytes,
+					  priv->checksum);
+	/* Break up the disk extent on blockgroup and superblock boundaries. */
+	while (num_bytes) {
+		boundary = extent_boundary(priv->root, disk_bytenr);
+		u64 size = min_t(u64, boundary - disk_bytenr, num_bytes);
+		ret = record_file_extent(priv->trans, priv->root,
+					 priv->objectid, priv->inode_nbytes,
+					 file_pos, disk_bytenr, size,
+					 priv->checksum);
+		if (ret)
+			return ret;
+		file_pos += size;
+		disk_bytenr += size;
+		num_bytes -= size;
+	}
+	return 0;
+}
+
+static int commit_file_extents(struct extent_iterate_data *priv)
+{
+	int ret;
+	if (priv->type == EXTENT_ITERATE_TYPE_NONE)
+		return 0;
+	if (priv->size == 0)
+		return 0;
+	if (priv->file_off > priv->last_file_off) {
+		ret = commit_disk_extent(priv, priv->last_file_off, 0,
+					 priv->file_off - priv->last_file_off);
+		if (ret)
+			return ret;
+	}
+	priv->last_file_off = priv->file_off + priv->size;
+
+	if (priv->type == EXTENT_ITERATE_TYPE_MEM) {
+		/* allocate and write to disk */
+		struct btrfs_key key;
+		ret = custom_alloc_extent(priv->root, priv->root->sectorsize,
+					  0, &key);
+		if (ret)
+			return ret;
+		ret = write_disk_extent(priv->root, key.objectid, priv->size,
+					priv->data);
+		if (ret)
+			return ret;
+		priv->type = EXTENT_ITERATE_TYPE_DISK;
+		priv->disk_off = key.objectid;
+	}
+
+	u64 sectorsize = priv->root->sectorsize;
+	if (priv->size & (sectorsize - 1))
+		priv->size = (priv->size & ~(sectorsize - 1)) + sectorsize;
+	ret = commit_disk_extent(priv, priv->file_off, priv->disk_off,
+				 priv->size);
+	if (ret)
+		return ret;
+	priv->type = EXTENT_ITERATE_TYPE_NONE;
+	return 0;
+}
+
+int start_file_extents(struct extent_iterate_data *priv,
+		       struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, u64 *inode_nbytes,
+		       u64 objectid, int checksum, int packing, u64 total_size)
+{
+	priv->trans = trans;
+	priv->root = root;
+	priv->inode_nbytes = inode_nbytes;
+	priv->objectid = objectid;
+	priv->checksum = checksum;
+	priv->packing = packing;
+	priv->last_file_off = 0;
+	priv->type = 0;
+	priv->total_size = total_size;
+	priv->data = malloc(root->sectorsize);
+	if (!priv->data)
+		return -ENOMEM;
+	return 0;
+}
+
+int start_file_extents_range(struct extent_iterate_data *priv,
+			     struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 *inode_nbytes,
+			     u64 objectid, int checksum, u64 start, u64 end)
+{
+	priv->trans = trans;
+	priv->root = root;
+	priv->inode_nbytes = inode_nbytes;
+	priv->objectid = objectid;
+	priv->checksum = checksum;
+	priv->packing = 0;
+	priv->last_file_off = start;
+	priv->type = 0;
+	priv->total_size = end;
+	priv->data = malloc(root->sectorsize);
+	if (!priv->data)
+		return -ENOMEM;
+	return 0;
+}
+
+int finish_file_extents(struct extent_iterate_data *priv)
+{
+	int ret;
+
+	if (priv->packing
+	    && priv->type != EXTENT_ITERATE_TYPE_NONE
+	    && priv->total_size <= BTRFS_MAX_INLINE_DATA_SIZE(priv->root)) {
+		priv->size = min_t(u64, priv->size,
+					priv->total_size - priv->file_off);
+		/* make inline extent */
+		if (priv->type == EXTENT_ITERATE_TYPE_DISK) {
+			ret = read_disk_extent(priv->root, priv->disk_off,
+					       priv->size, priv->data);
 			if (ret)
-				goto fail;
+				return ret;
 		}
+		*priv->inode_nbytes += priv->size;
+		return btrfs_insert_inline_extent(priv->trans, priv->root,
+						  priv->objectid,
+						  priv->file_off, priv->data,
+						  priv->size);
+	}
 
-		if (sb_region) {
-			bytenr += STRIPE_LEN - 1;
-			bytenr &= ~((u64)STRIPE_LEN - 1);
-		} else {
-			cache = btrfs_lookup_block_group(root->fs_info, bytenr);
-			BUG_ON(!cache);
-			bytenr = cache->key.objectid + cache->key.offset;
+	ret = commit_file_extents(priv);
+	if (ret)
+		return ret;
+
+	if (priv->total_size > priv->last_file_off) {
+		ret = commit_disk_extent(priv, priv->last_file_off, 0,
+					priv->total_size - priv->last_file_off);
+		if (ret)
+			return ret;
+	}
+	free(priv->data);
+	return 0;
+}
+
+int add_file_mem_extent(struct extent_iterate_data *priv, u64 file_off,
+			u64 size, char *data);
+
+int add_file_disk_extent(struct extent_iterate_data *priv, u64 file_off,
+			 u64 disk_off, u64 size)
+{
+	BUG_ON(file_off < priv->last_file_off);
+	int ret;
+	u64 sectorsize = priv->root->sectorsize;
+	u64 mask = sectorsize - 1;
+	if (size == 0)
+		return 0;
+	if ((file_off & mask) != (disk_off & mask)) {
+		/* It's unclear how to CoW this, so don't. */
+		char *data = malloc(size);
+		if (!data)
+			return -ENOMEM;
+		ret = read_disk_extent(priv->root, disk_off, size, data);
+		if (ret) {
+			free(data);
+			return ret;
 		}
+		ret = add_file_mem_extent(priv, file_off, size, data);
+		free(data);
+		return ret;
+	}
+	if (priv->type == EXTENT_ITERATE_TYPE_DISK
+			&& priv->file_off + priv->size == file_off
+			&& priv->disk_off + priv->size == disk_off) {
+		/* It's a continuation of the same disk extent. */
+		priv->size += size;
+		return 0;
+	}
+	if (disk_off == 0 || disk_off & mask) {
+		/* We need to have an aligned start, so give the first part to
+		 * add_file_mem_extent if necessary. */
+		u64 mem_size = min_t(u64, sectorsize - (disk_off & mask), size);
+		char *data = malloc(mem_size);
+		if (!data)
+			return -ENOMEM;
+		ret = read_disk_extent(priv->root, disk_off, mem_size, data);
+		if (ret) {
+			free(data);
+			return ret;
+		}
+		ret = add_file_mem_extent(priv, file_off, mem_size, data);
+		free(data);
+		if (ret)
+			return ret;
+		file_off += mem_size;
+		disk_off += mem_size;
+		size -= mem_size;
+		if (size == 0)
+			return 0;
+	}
+	ret = commit_file_extents(priv);
+	if (ret)
+		return ret;
+	priv->type = EXTENT_ITERATE_TYPE_DISK;
+	priv->size = size;
+	priv->file_off = file_off;
+	priv->disk_off = disk_off;
+	return 0;
+}
+
+int add_file_mem_extent(struct extent_iterate_data *priv, u64 file_off,
+			u64 size, char *data)
+{
+	BUG_ON(file_off < priv->last_file_off);
+	int ret;
+	u64 sectorsize = priv->root->sectorsize;
+	u64 mask = sectorsize - 1;
+	u64 aligned_file_off = file_off & ~mask;
+	u32 alignment = file_off - aligned_file_off;
+	size += alignment;
+
+	/* If we share a sector with a DISK extent, commit most of it and turn
+	 * the shared part into a MEM extent. */
+	if (priv->type == EXTENT_ITERATE_TYPE_DISK
+			&& priv->file_off + priv->size > aligned_file_off) {
+		u64 mem_size = priv->file_off + priv->size - aligned_file_off;
+		ret = read_disk_extent(priv->root, aligned_file_off, mem_size,
+				       priv->data);
+		if (ret)
+			return ret;
+		priv->size -= mem_size;
+		ret = commit_file_extents(priv);
+		if (ret)
+			return ret;
+		priv->type = EXTENT_ITERATE_TYPE_MEM;
+		priv->size = mem_size;
+		priv->file_off = aligned_file_off;
+	}
+
+	/* Put our first sector in priv->data. If we share a sector with the
+	 * previous extent, combine with it. */
+	if (priv->type == EXTENT_ITERATE_TYPE_MEM
+			&& priv->file_off + priv->size > aligned_file_off) {
+		BUG_ON(priv->file_off != aligned_file_off);
+		memset(priv->data + priv->size, 0, sectorsize - priv->size);
+	} else {
+		ret = commit_file_extents(priv);
+		if (ret)
+			return ret;
+		memset(priv->data, 0, sectorsize);
+	}
+	if (size < sectorsize) {
+		memcpy(priv->data + alignment, data, size - alignment);
+		priv->type = EXTENT_ITERATE_TYPE_MEM;
+		priv->file_off = aligned_file_off;
+		priv->size = size;
+		return 0;
+	}
+	memcpy(priv->data + alignment, data, sectorsize - alignment);
+	data += sectorsize - alignment;
+
+	/* We have full sectors; allocate and write them. */
+	u64 aligned_size = size & ~mask;
+	struct btrfs_key key;
+	ret = custom_alloc_extent(priv->root, aligned_size, 0, &key);
+	if (ret)
+		return ret;
+	ret = write_disk_extent(priv->root, key.objectid,
+				sectorsize, priv->data);
+	if (ret)
+		return ret;
+	ret = write_disk_extent(priv->root, key.objectid + sectorsize,
+				aligned_size - sectorsize, data);
+	if (ret)
+		return ret;
+	ret = add_file_disk_extent(priv, aligned_file_off, key.objectid,
+				   aligned_size);
+	if (ret)
+		return ret;
 
-		idata->first_block = file_block;
-		idata->disk_block = disk_block;
-		idata->boundary = bytenr / root->sectorsize;
+	/* Leave the rest in priv. */
+	size -= aligned_size;
+	if (size) {
+		ret = commit_file_extents(priv);
+		if (ret)
+			return ret;
+		aligned_file_off += aligned_size;
+		data += aligned_size - sectorsize;
+		priv->type = EXTENT_ITERATE_TYPE_MEM;
+		priv->file_off = aligned_file_off;
+		priv->size = size;
+		memcpy(priv->data, data, size);
 	}
-	idata->num_blocks++;
 	return 0;
-fail:
-	idata->errcode = ret;
-	return BLOCK_ABORT;
 }
 
 static int __block_iterate_proc(ext2_filsys fs, blk_t *blocknr,
 			        e2_blkcnt_t blockcnt, blk_t ref_block,
 			        int ref_offset, void *priv_data)
 {
-	struct blk_iterate_data *idata;
-	idata = (struct blk_iterate_data *)priv_data;
-	return block_iterate_proc(fs, *blocknr, blockcnt, idata);
+	struct extent_iterate_data *idata;
+	idata = (struct extent_iterate_data *)priv_data;
+	u64 blocksize = fs->blocksize;
+	int ret = add_file_disk_extent(idata, blocksize * blockcnt,
+				       blocksize * *blocknr, blocksize);
+	if (ret)
+		return BLOCK_ABORT;
+	return 0;
 }
 
 /*
@@ -593,68 +867,23 @@ static int create_file_extents(struct btrfs_trans_handle *trans,
 			       int datacsum, int packing)
 {
 	int ret;
-	char *buffer = NULL;
 	errcode_t err;
-	u32 last_block;
-	u32 sectorsize = root->sectorsize;
+	u64 inode_nbytes = 0;
 	u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
-	struct blk_iterate_data data = {
-		.trans		= trans,
-		.root		= root,
-		.inode		= btrfs_inode,
-		.objectid	= objectid,
-		.first_block	= 0,
-		.disk_block	= 0,
-		.num_blocks	= 0,
-		.boundary	= (u64)-1,
-		.checksum	= datacsum,
-		.errcode	= 0,
-	};
+	struct extent_iterate_data data;
+	ret = start_file_extents(&data, trans, root, &inode_nbytes, objectid,
+				 datacsum, packing, inode_size);
+	if (ret)
+		return ret;
 	err = ext2fs_block_iterate2(ext2_fs, ext2_ino, BLOCK_FLAG_DATA_ONLY,
 				    NULL, __block_iterate_proc, &data);
 	if (err)
 		goto error;
-	ret = data.errcode;
+	ret = finish_file_extents(&data);
 	if (ret)
-		goto fail;
-	if (packing && data.first_block == 0 && data.num_blocks > 0 &&
-	    inode_size <= BTRFS_MAX_INLINE_DATA_SIZE(root)) {
-		u64 num_bytes = data.num_blocks * sectorsize;
-		u64 disk_bytenr = data.disk_block * sectorsize;
-		u64 nbytes;
-
-		buffer = malloc(num_bytes);
-		if (!buffer)
-			return -ENOMEM;
-		ret = read_disk_extent(root, disk_bytenr, num_bytes, buffer);
-		if (ret)
-			goto fail;
-		if (num_bytes > inode_size)
-			num_bytes = inode_size;
-		ret = btrfs_insert_inline_extent(trans, root, objectid,
-						 0, buffer, num_bytes);
-		if (ret)
-			goto fail;
-		nbytes = btrfs_stack_inode_nbytes(btrfs_inode) + num_bytes;
-		btrfs_set_stack_inode_nbytes(btrfs_inode, nbytes);
-	} else if (data.num_blocks > 0) {
-		ret = record_file_blocks(trans, root, objectid, btrfs_inode,
-					 data.first_block, data.disk_block,
-					 data.num_blocks, data.checksum);
-		if (ret)
-			goto fail;
-	}
-	data.first_block += data.num_blocks;
-	last_block = (inode_size + sectorsize - 1) / sectorsize;
-	if (last_block > data.first_block) {
-		ret = record_file_blocks(trans, root, objectid, btrfs_inode,
-					 data.first_block, 0, last_block -
-					 data.first_block, data.checksum);
-	}
-fail:
-	if (buffer)
-		free(buffer);
-	return ret;
+		return ret;
+	btrfs_set_stack_inode_nbytes(btrfs_inode, inode_nbytes);
+	return 0;
 error:
 	fprintf(stderr, "ext2fs_block_iterate2: %s\n", error_message(err));
 	return -1;
@@ -1206,52 +1435,33 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
  */
 static int create_image_file_range(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root, u64 objectid,
-				   struct btrfs_inode_item *inode,
+				   u64 *inode_nbytes,
 				   u64 start_byte, u64 end_byte,
 				   struct extent_io_tree *orig_free_tree)
 {
-	u32 blocksize = root->sectorsize;
-	u32 block = start_byte / blocksize;
-	u32 last_block = (end_byte + blocksize - 1) / blocksize;
 	int ret = 0;
-	struct blk_iterate_data data = {
-		.trans		= trans,
-		.root		= root,
-		.inode		= inode,
-		.objectid	= objectid,
-		.first_block	= block,
-		.disk_block	= 0,
-		.num_blocks	= 0,
-		.boundary	= (u64)-1,
-		.checksum 	= 0,
-		.errcode	= 0,
-	};
-	for (; start_byte < end_byte; block++, start_byte += blocksize) {
-		if (test_range_bit(orig_free_tree, start_byte,
-				   start_byte + blocksize, EXTENT_DIRTY, 1))
-			continue;
-		ret = block_iterate_proc(NULL, block, block, &data);
-		if (ret & BLOCK_ABORT) {
-			ret = data.errcode;
-			goto fail;
-		}
-	}
-	if (data.num_blocks > 0) {
-		ret = record_file_blocks(trans, root, objectid, inode,
-					 data.first_block, data.disk_block,
-					 data.num_blocks, 0);
-		if (ret)
-			goto fail;
-		data.first_block += data.num_blocks;
-	}
-	if (last_block > data.first_block) {
-		ret = record_file_blocks(trans, root, objectid, inode,
-					 data.first_block, 0, last_block -
-					 data.first_block, 0);
+	struct extent_iterate_data data;
+	ret = start_file_extents_range(&data, trans, root, inode_nbytes,
+				       objectid, 0, start_byte, end_byte);
+	if (ret)
+		return ret;
+	while (start_byte < end_byte) {
+		u64 start, end;
+		ret = find_first_extent_bit(orig_free_tree, start_byte,
+					    &start, &end, EXTENT_DIRTY);
 		if (ret)
-			goto fail;
+			start = end_byte;
+		if (start > start_byte) {
+			u64 size = min_t(u64, start - start_byte,
+					      end_byte - start_byte);
+			ret = add_file_disk_extent(&data, start_byte,
+						   start_byte, size);
+			if (ret)
+				return ret;
+		}
+		start_byte = end + 1;
 	}
-fail:
+	ret = finish_file_extents(&data);
 	return ret;
 }
 /*
@@ -1279,6 +1489,7 @@ static int create_ext2_image(struct btrfs_root *root, const char *name,
 	u64 last_byte;
 	u64 first_free;
 	u64 total_bytes;
+	u64 inode_nbytes;
 	u32 sectorsize = root->sectorsize;
 
 	total_bytes = btrfs_super_total_bytes(&fs_info->super_copy);
@@ -1289,7 +1500,7 @@ static int create_ext2_image(struct btrfs_root *root, const char *name,
 	btrfs_set_stack_inode_generation(&btrfs_inode, 1);
 	btrfs_set_stack_inode_size(&btrfs_inode, total_bytes);
 	btrfs_set_stack_inode_nlink(&btrfs_inode, 1);
-	btrfs_set_stack_inode_nbytes(&btrfs_inode, 0);
+	inode_nbytes = 0;
 	btrfs_set_stack_inode_mode(&btrfs_inode, S_IFREG | 0400);
 	btrfs_set_stack_inode_flags(&btrfs_inode, BTRFS_INODE_NODATASUM |
 				    BTRFS_INODE_READONLY);
@@ -1315,7 +1526,7 @@ static int create_ext2_image(struct btrfs_root *root, const char *name,
 		if (ret)
 			goto fail;
 		ret = record_file_extent(trans, root, objectid,
-					 &btrfs_inode, last_byte,
+					 &inode_nbytes, last_byte,
 					 key.objectid, sectorsize, 0);
 		if (ret)
 			goto fail;
@@ -1370,12 +1581,12 @@ next:
 
 		if (bytenr > last_byte) {
 			ret = create_image_file_range(trans, root, objectid,
-						      &btrfs_inode, last_byte,
+						      &inode_nbytes, last_byte,
 						      bytenr, orig_free_tree);
 			if (ret)
 				goto fail;
 		}
-		ret = record_file_extent(trans, root, objectid, &btrfs_inode,
+		ret = record_file_extent(trans, root, objectid, &inode_nbytes,
 					 bytenr, bytenr, num_bytes, 0);
 		if (ret)
 			goto fail;
@@ -1392,12 +1603,14 @@ next:
 	btrfs_release_path(root, &path);
 	if (total_bytes > last_byte) {
 		ret = create_image_file_range(trans, root, objectid,
-					      &btrfs_inode, last_byte,
+					      &inode_nbytes, last_byte,
 					      total_bytes, orig_free_tree);
 		if (ret)
 			goto fail;
 	}
 
+	btrfs_set_stack_inode_nbytes(&btrfs_inode, inode_nbytes);
+
 	ret = btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
 	if (ret)
 		goto fail;
@@ -1934,7 +2147,7 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_path path;
 	struct btrfs_inode_item inode;
-	struct blk_iterate_data data;
+	struct extent_iterate_data data;
 	u64 bytenr;
 	u64 num_bytes;
 	u64 cur_offset;
@@ -1990,22 +2203,14 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 	btrfs_release_path(root, &path);
 
 	BUG_ON(num_bytes & (sectorsize - 1));
-	nbytes = btrfs_stack_inode_nbytes(&inode) - num_bytes;
-	btrfs_set_stack_inode_nbytes(&inode, nbytes);
 	datacsum = !(btrfs_stack_inode_flags(&inode) & BTRFS_INODE_NODATASUM);
 
-	data = (struct blk_iterate_data) {
-		.trans		= trans,
-		.root		= root,
-		.inode		= &inode,
-		.objectid	= extent_key->objectid,
-		.first_block	= extent_key->offset / sectorsize,
-		.disk_block	= 0,
-		.num_blocks	= 0,
-		.boundary	= (u64)-1,
-		.checksum	= datacsum,
-		.errcode	= 0,
-	};
+	ret = start_file_extents_range(&data, trans, root, &nbytes,
+				       extent_key->objectid, datacsum,
+				       extent_key->offset,
+				       extent_key->offset + num_bytes);
+	if (ret)
+		goto fail;
 
 	cur_offset = extent_key->offset;
 	while (num_bytes > 0) {
@@ -2035,26 +2240,19 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 
-		ret = block_iterate_proc(NULL, new_pos / sectorsize,
-					 cur_offset / sectorsize, &data);
-		if (ret & BLOCK_ABORT) {
-			ret = data.errcode;
+		ret = add_file_disk_extent(&data, cur_offset, new_pos,
+					   sectorsize);
+		if (ret)
 			goto fail;
-		}
 
 		cur_offset += sectorsize;
 		bytenr += sectorsize;
 		num_bytes -= sectorsize;
 	}
 
-	if (data.num_blocks > 0) {
-		ret = record_file_blocks(trans, root,
-					 extent_key->objectid, &inode,
-					 data.first_block, data.disk_block,
-					 data.num_blocks, datacsum);
-		if (ret)
-			goto fail;
-	}
+	ret = finish_file_extents(&data);
+	if (ret)
+		goto fail;
 
 	key.objectid = extent_key->objectid;
 	key.offset = 0;
-- 
1.6.4.4

