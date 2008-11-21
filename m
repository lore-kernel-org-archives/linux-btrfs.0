From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] add support for multiple csum algorithms
Date: Fri, 21 Nov 2008 12:55:05 -0500
Message-ID: <20081121175505.GA13529@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch gives us the space we will need in order to have different csum
algorithims at some point in the future.  We save the csum algorithim type and
the sectorsize in the superblock, and use those instead of define's.  Tested
with fs_mark to fill the entire disk, and then tar czf /dev/null ./ in the root
dir of the fs.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b5af1fc..770b720 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -109,8 +109,12 @@ struct btrfs_ordered_sum;
 
 /* 32 bytes in various csum fields */
 #define BTRFS_CSUM_SIZE 32
+
+/* csum types */
+#define BTRFS_CSUM_TYPE_CRC32	0
+
 /* four bytes for CRC32 */
-#define BTRFS_CRC32_SIZE 4
+//#define BTRFS_CRC32_SIZE 4
 #define BTRFS_EMPTY_DIR_SIZE 0
 
 #define BTRFS_FT_UNKNOWN	0
@@ -308,6 +312,8 @@ struct btrfs_super_block {
 	__le64 compat_flags;
 	__le64 compat_ro_flags;
 	__le64 incompat_flags;
+	__le16 csum_type;
+	__le16 csum_sectorsize;
 	u8 root_level;
 	u8 chunk_root_level;
 	u8 log_root_level;
@@ -1524,6 +1530,10 @@ BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
+			 csum_type, 16);
+BTRFS_SETGET_STACK_FUNCS(super_csum_sectorsize, struct btrfs_super_block,
+			 csum_sectorsize, 16);
 
 static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6047858..1ad9d66 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -175,7 +175,9 @@ void btrfs_csum_final(u32 crc, char *result)
 static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify)
 {
-	char result[BTRFS_CRC32_SIZE];
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
+	char *result;
 	unsigned long len;
 	unsigned long cur_len;
 	unsigned long offset = BTRFS_CSUM_SIZE;
@@ -203,25 +205,31 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		offset += cur_len;
 		unmap_extent_buffer(buf, map_token, KM_USER0);
 	}
+	result = kzalloc(csum_sectorsize * sizeof(char), GFP_NOFS);
+	if (!result)
+		return 1;
+
 	btrfs_csum_final(crc, result);
 
 	if (verify) {
 		/* FIXME, this is not good */
-		if (memcmp_extent_buffer(buf, result, 0, BTRFS_CRC32_SIZE)) {
+		if (memcmp_extent_buffer(buf, result, 0, csum_sectorsize)) {
 			u32 val;
 			u32 found = 0;
-			memcpy(&found, result, BTRFS_CRC32_SIZE);
+			memcpy(&found, result, csum_sectorsize);
 
-			read_extent_buffer(buf, &val, 0, BTRFS_CRC32_SIZE);
+			read_extent_buffer(buf, &val, 0, csum_sectorsize);
 			printk("btrfs: %s checksum verify failed on %llu "
 			       "wanted %X found %X level %d\n",
 			       root->fs_info->sb->s_id,
 			       buf->start, val, found, btrfs_header_level(buf));
+			kfree(result);
 			return 1;
 		}
 	} else {
-		write_extent_buffer(buf, result, 0, BTRFS_CRC32_SIZE);
+		write_extent_buffer(buf, result, 0, csum_sectorsize);
 	}
+	kfree(result);
 	return 0;
 }
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index f763788..3cc0c92 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -24,9 +24,9 @@
 #include "transaction.h"
 #include "print-tree.h"
 
-#define MAX_CSUM_ITEMS(r) ((((BTRFS_LEAF_DATA_SIZE(r) - \
-			       sizeof(struct btrfs_item) * 2) / \
-			       BTRFS_CRC32_SIZE) - 1))
+#define MAX_CSUM_ITEMS(r,size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
+				   sizeof(struct btrfs_item) * 2) / \
+				  size) - 1))
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
@@ -83,6 +83,8 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 	struct btrfs_csum_item *item;
 	struct extent_buffer *leaf;
 	u64 csum_offset = 0;
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 	int csums_in_item;
 
 	file_key.objectid = objectid;
@@ -105,7 +107,7 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 		csum_offset = (offset - found_key.offset) >>
 				root->fs_info->sb->s_blocksize_bits;
 		csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
-		csums_in_item /= BTRFS_CRC32_SIZE;
+		csums_in_item /= csum_sectorsize;
 
 		if (csum_offset >= csums_in_item) {
 			ret = -EFBIG;
@@ -114,7 +116,7 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 	}
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
 	item = (struct btrfs_csum_item *)((unsigned char *)item +
-					  csum_offset * BTRFS_CRC32_SIZE);
+					  csum_offset * csum_sectorsize);
 	return item;
 fail:
 	if (ret > 0)
@@ -150,6 +152,8 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 	u64 item_start_offset = 0;
 	u64 item_last_offset = 0;
 	u32 diff;
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_csum_item *item = NULL;
@@ -195,7 +199,7 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 			item_size = btrfs_item_size_nr(path->nodes[0],
 						       path->slots[0]);
 			item_last_offset = item_start_offset +
-				(item_size / BTRFS_CRC32_SIZE) *
+				(item_size / csum_sectorsize) *
 				root->sectorsize;
 			item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 					      struct btrfs_csum_item);
@@ -206,11 +210,11 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 		 */
 		diff = offset - item_start_offset;
 		diff = diff / root->sectorsize;
-		diff = diff * BTRFS_CRC32_SIZE;
+		diff = diff * csum_sectorsize;
 
 		read_extent_buffer(path->nodes[0], &sum,
 				   ((unsigned long)item) + diff,
-				   BTRFS_CRC32_SIZE);
+				   csum_sectorsize);
 found:
 		set_state_private(io_tree, offset, sum);
 		bio_index++;
@@ -383,6 +387,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	char *eb_token;
 	unsigned long map_len;
 	unsigned long map_start;
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -408,7 +414,8 @@ again:
 		/* we found one, but it isn't big enough yet */
 		leaf = path->nodes[0];
 		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-		if ((item_size / BTRFS_CRC32_SIZE) >= MAX_CSUM_ITEMS(root)) {
+		if ((item_size / csum_sectorsize) >=
+		    MAX_CSUM_ITEMS(root, csum_sectorsize)) {
 			/* already at max size, make a new one */
 			goto insert;
 		}
@@ -441,7 +448,7 @@ again:
 	 */
 	btrfs_release_path(root, path);
 	ret = btrfs_search_slot(trans, root, &file_key, path,
-				BTRFS_CRC32_SIZE, 1);
+				csum_sectorsize, 1);
 	if (ret < 0)
 		goto fail_unlock;
 	if (ret == 0) {
@@ -457,14 +464,14 @@ again:
 			root->fs_info->sb->s_blocksize_bits;
 	if (btrfs_key_type(&found_key) != BTRFS_CSUM_ITEM_KEY ||
 	    found_key.objectid != objectid ||
-	    csum_offset >= MAX_CSUM_ITEMS(root)) {
+	    csum_offset >= MAX_CSUM_ITEMS(root, csum_sectorsize)) {
 		goto insert;
 	}
 	if (csum_offset >= btrfs_item_size_nr(leaf, path->slots[0]) /
-	    BTRFS_CRC32_SIZE) {
-		u32 diff = (csum_offset + 1) * BTRFS_CRC32_SIZE;
+	    csum_sectorsize) {
+		u32 diff = (csum_offset + 1) * csum_sectorsize;
 		diff = diff - btrfs_item_size_nr(leaf, path->slots[0]);
-		if (diff != BTRFS_CRC32_SIZE)
+		if (diff != csum_sectorsize)
 			goto insert;
 		ret = btrfs_extend_item(trans, root, path, diff);
 		BUG_ON(ret);
@@ -479,10 +486,10 @@ insert:
 		tmp -= offset & ~((u64)root->sectorsize -1);
 		tmp >>= root->fs_info->sb->s_blocksize_bits;
 		tmp = max((u64)1, tmp);
-		tmp = min(tmp, (u64)MAX_CSUM_ITEMS(root));
-		ins_size = BTRFS_CRC32_SIZE * tmp;
+		tmp = min(tmp, (u64)MAX_CSUM_ITEMS(root, csum_sectorsize));
+		ins_size = csum_sectorsize * tmp;
 	} else {
-		ins_size = BTRFS_CRC32_SIZE;
+		ins_size = csum_sectorsize;
 	}
 	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
 				      ins_size);
@@ -497,7 +504,7 @@ csum:
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
 	ret = 0;
 	item = (struct btrfs_csum_item *)((unsigned char *)item +
-					  csum_offset * BTRFS_CRC32_SIZE);
+					  csum_offset * csum_sectorsize);
 found:
 	item_end = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
 	item_end = (struct btrfs_csum_item *)((unsigned char *)item_end +
@@ -508,14 +515,14 @@ found:
 next_sector:
 
 	if (!eb_token ||
-	   (unsigned long)item  + BTRFS_CRC32_SIZE >= map_start + map_len) {
+	   (unsigned long)item + csum_sectorsize >= map_start + map_len) {
 		int err;
 
 		if (eb_token)
 			unmap_extent_buffer(leaf, eb_token, KM_USER1);
 		eb_token = NULL;
 		err = map_private_extent_buffer(leaf, (unsigned long)item,
-						BTRFS_CRC32_SIZE,
+						csum_sectorsize,
 						&eb_token, &eb_map,
 						&map_start, &map_len, KM_USER1);
 		if (err)
@@ -523,17 +530,17 @@ next_sector:
 	}
 	if (eb_token) {
 		memcpy(eb_token + ((unsigned long)item & (PAGE_CACHE_SIZE - 1)),
-		       &sector_sum->sum, BTRFS_CRC32_SIZE);
+		       &sector_sum->sum, csum_sectorsize);
 	} else {
 		write_extent_buffer(leaf, &sector_sum->sum,
-				    (unsigned long)item, BTRFS_CRC32_SIZE);
+				    (unsigned long)item, csum_sectorsize);
 	}
 
 	total_bytes += root->sectorsize;
 	sector_sum++;
 	if (total_bytes < sums->len) {
 		item = (struct btrfs_csum_item *)((char *)item +
-						  BTRFS_CRC32_SIZE);
+						  csum_sectorsize);
 		if (item < item_end && offset + PAGE_CACHE_SIZE ==
 		    sector_sum->offset) {
 			    offset = sector_sum->offset;
@@ -577,7 +584,8 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 	new_item_span = isize - key.offset;
 	blocks = (new_item_span + root->sectorsize - 1) >>
 		root->fs_info->sb->s_blocksize_bits;
-	new_item_size = blocks * BTRFS_CRC32_SIZE;
+	new_item_size = blocks *
+		btrfs_super_sectorsize(&root->fs_info->super_copy);
 	if (new_item_size >= btrfs_item_size_nr(leaf, slot))
 		return 0;
 	ret = btrfs_truncate_item(trans, root, path, new_item_size, 1);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8828109..2c8f18a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -713,7 +713,8 @@ long btrfs_ioctl_clone(struct file *file, unsigned long srcfd, u64 off,
 	u64 len = olen;
 	u64 bs = root->fs_info->sb->s_blocksize;
 	u64 hint_byte;
-
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 	/*
 	 * TODO:
 	 * - split compressed inline extents.  annoying: we need to
@@ -963,7 +964,7 @@ long btrfs_ioctl_clone(struct file *file, unsigned long srcfd, u64 off,
 			int coff, clen;
 
 			size = btrfs_item_size_nr(leaf, slot);
-			coverslen = (size / BTRFS_CRC32_SIZE) <<
+			coverslen = (size / csum_sectorsize) <<
 				root->fs_info->sb->s_blocksize_bits;
 			printk("csums for %llu~%llu\n",
 			       key.offset, coverslen);
@@ -980,12 +981,12 @@ long btrfs_ioctl_clone(struct file *file, unsigned long srcfd, u64 off,
 			if (off > key.offset)
 				coff = ((off - key.offset) >>
 					root->fs_info->sb->s_blocksize_bits) *
-					BTRFS_CRC32_SIZE;
+					csum_sectorsize;
 			clen = size - coff;
 			if (key.offset + coverslen > off+len)
 				clen -= ((key.offset+coverslen-off-len) >>
 					 root->fs_info->sb->s_blocksize_bits) *
-					BTRFS_CRC32_SIZE;
+					csum_sectorsize;
 			printk(" will dup %d~%d of %d\n",
 			       coff, clen, size);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index be4fc30..478b4dc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -928,13 +928,15 @@ static noinline int replay_one_csum(struct btrfs_trans_handle *trans,
 	int ret;
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 cur_offset;
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 	unsigned long file_bytes;
 	struct btrfs_ordered_sum *sums;
 	struct btrfs_sector_sum *sector_sum;
 	struct inode *inode;
 	unsigned long ptr;
 
-	file_bytes = (item_size / BTRFS_CRC32_SIZE) * root->sectorsize;
+	file_bytes = (item_size / csum_sectorsize) * root->sectorsize;
 	inode = read_one_inode(root, key->objectid);
 	if (!inode) {
 		return -EIO;
@@ -958,10 +960,10 @@ static noinline int replay_one_csum(struct btrfs_trans_handle *trans,
 	ptr = btrfs_item_ptr_offset(eb, slot);
 	while(item_size > 0) {
 		sector_sum->offset = cur_offset;
-		read_extent_buffer(eb, &sector_sum->sum, ptr, BTRFS_CRC32_SIZE);
+		read_extent_buffer(eb, &sector_sum->sum, ptr, csum_sectorsize);
 		sector_sum++;
-		item_size -= BTRFS_CRC32_SIZE;
-		ptr += BTRFS_CRC32_SIZE;
+		item_size -= csum_sectorsize;
+		ptr += csum_sectorsize;
 		cur_offset += root->sectorsize;
 	}
 
