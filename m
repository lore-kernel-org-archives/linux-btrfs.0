From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs-progs: support for different csum algorithims
Date: Fri, 21 Nov 2008 12:57:48 -0500
Message-ID: <20081121175747.GB13529@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is the btrfs-progs version of the patch to add the ability to have
different csum algorithims.  Note I didn't change the image maker since it
seemed a bit more complicated than just changing some stuff around so I will let
Yan take care of that :).  Everything else was converted and for now a mkfs just
sets the sectorsize to be BTRFS_CRC32_SIZE and the type to be
BTRFS_CSUM_TYPE_CRC32.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/ctree.h b/ctree.h
index bce36e3..d770a29 100644
--- a/ctree.h
+++ b/ctree.h
@@ -92,6 +92,10 @@ struct btrfs_trans_handle;
 
 /* 32 bytes in various csum fields */
 #define BTRFS_CSUM_SIZE 32
+
+/* csum types */
+#define BTRFS_CSUM_TYPE_CRC32	0
+
 /* four bytes for CRC32 */
 #define BTRFS_CRC32_SIZE 4
 #define BTRFS_EMPTY_DIR_SIZE 0
@@ -292,6 +296,8 @@ struct btrfs_super_block {
 	__le64 compat_flags;
 	__le64 compat_ro_flags;
 	__le64 incompat_flags;
+	__le16 csum_type;
+	__le16 csum_sectorsize;
 	u8 root_level;
 	u8 chunk_root_level;
 	u8 log_root_level;
@@ -1353,6 +1359,10 @@ BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
+			 csum_type, 16);
+BTRFS_SETGET_STACK_FUNCS(super_csum_sectorsize, struct btrfs_super_block,
+			 csum_sectorsize, 16);
 
 static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 {
diff --git a/disk-io.c b/disk-io.c
index ccfd6e3..6deb0b7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -67,30 +67,44 @@ void btrfs_csum_final(u32 crc, char *result)
 	*(__le32 *)result = ~cpu_to_le32(crc);
 }
 
-int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-		    int verify)
+int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
+			 int verify)
 {
-	char result[BTRFS_CRC32_SIZE];
+	char *result;
 	u32 len;
 	u32 crc = ~(u32)0;
 
+	result = malloc(csum_sectorsize * sizeof(char));
+	if (!result)
+		return 1;
+
 	len = buf->len - BTRFS_CSUM_SIZE;
 	crc = crc32c(crc, buf->data + BTRFS_CSUM_SIZE, len);
 	btrfs_csum_final(crc, result);
 
 	if (verify) {
-		if (memcmp_extent_buffer(buf, result, 0, BTRFS_CRC32_SIZE)) {
+		if (memcmp_extent_buffer(buf, result, 0, csum_sectorsize)) {
 			printk("checksum verify failed on %llu wanted %X "
 			       "found %X\n", (unsigned long long)buf->start,
 			       *((int *)result), *((int *)buf));
+			free(result);
 			return 1;
 		}
 	} else {
-		write_extent_buffer(buf, result, 0, BTRFS_CRC32_SIZE);
+		write_extent_buffer(buf, result, 0, csum_sectorsize);
 	}
+	free(result);
 	return 0;
 }
 
+int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
+		    int verify)
+{
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
+	return csum_tree_block_size(buf, csum_sectorsize, verify);
+}
+
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize)
 {
diff --git a/disk-io.h b/disk-io.h
index 098f9e3..5b827e4 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -56,6 +56,8 @@ void btrfs_csum_final(u32 crc, char *result);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 int btrfs_open_device(struct btrfs_device *dev);
+int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
+			 int verify);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		    int verify);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
diff --git a/file-item.c b/file-item.c
index e5f5dea..0a30f37 100644
--- a/file-item.c
+++ b/file-item.c
@@ -26,9 +26,9 @@
 #include "print-tree.h"
 #include "crc32c.h"
 
-#define MAX_CSUM_ITEMS(r) ((((BTRFS_LEAF_DATA_SIZE(r) - \
+#define MAX_CSUM_ITEMS(r,size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
 			       sizeof(struct btrfs_item) * 2) / \
-			       BTRFS_CRC32_SIZE) - 1))
+			       size) - 1))
 int btrfs_create_file(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, u64 dirid, u64 *objectid)
 {
@@ -201,6 +201,8 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	u64 csum_offset = 0;
 	int csums_in_item;
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 
 	file_key.objectid = objectid;
 	file_key.offset = offset;
@@ -221,7 +223,7 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 		}
 		csum_offset = (offset - found_key.offset) >> root->sectorsize;
 		csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
-		csums_in_item /= BTRFS_CRC32_SIZE;
+		csums_in_item /= csum_sectorsize;
 
 		if (csum_offset >= csums_in_item) {
 			ret = -EFBIG;
@@ -230,7 +232,7 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 	}
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
 	item = (struct btrfs_csum_item *)((unsigned char *)item +
-					  csum_offset * BTRFS_CRC32_SIZE);
+					  csum_offset * csum_sectorsize);
 	return item;
 fail:
 	if (ret > 0)
@@ -274,6 +276,8 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	u32 csum_result = ~(u32)0;
 	u32 nritems;
 	u32 ins_size;
+	u16 csum_sectorsize =
+		btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -293,7 +297,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 		/* we found one, but it isn't big enough yet */
 		leaf = path->nodes[0];
 		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-		if ((item_size / BTRFS_CRC32_SIZE) >= MAX_CSUM_ITEMS(root)) {
+		if ((item_size / csum_sectorsize) >= MAX_CSUM_ITEMS(root, csum_sectorsize)) {
 			/* already at max size, make a new one */
 			goto insert;
 		}
@@ -326,7 +330,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	 */
 	btrfs_release_path(root, path);
 	ret = btrfs_search_slot(trans, root, &file_key, path,
-				BTRFS_CRC32_SIZE, 1);
+				csum_sectorsize, 1);
 	if (ret < 0)
 		goto fail;
 	if (ret == 0) {
@@ -341,14 +345,14 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	csum_offset = (offset - found_key.offset) / root->sectorsize;
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
@@ -363,10 +367,10 @@ insert:
 		tmp -= offset & ~((u64)root->sectorsize -1);
 		tmp /= root->sectorsize;
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
@@ -381,7 +385,7 @@ csum:
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
 	ret = 0;
 	item = (struct btrfs_csum_item *)((unsigned char *)item +
-					  csum_offset * BTRFS_CRC32_SIZE);
+					  csum_offset * csum_sectorsize);
 found:
 	csum_result = btrfs_csum_data(root, data, csum_result, len);
 	btrfs_csum_final(csum_result, (char *)&csum_result);
@@ -392,7 +396,7 @@ found:
 	}
 
 	write_extent_buffer(leaf, &csum_result, (unsigned long)item,
-			    BTRFS_CRC32_SIZE);
+			    csum_sectorsize);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 fail:
 	btrfs_release_path(root, path);
@@ -417,7 +421,8 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 		return 0;
 	new_item_span = isize - key.offset;
 	blocks = (new_item_span + root->sectorsize - 1) / root->sectorsize;
-	new_item_size = blocks * BTRFS_CRC32_SIZE;
+	new_item_size = blocks *
+	       btrfs_super_csum_sectorsize(&root->fs_info->super_copy);
 	if (new_item_size >= btrfs_item_size_nr(leaf, slot))
 		return 0;
 	ret = btrfs_truncate_item(trans, root, path, new_item_size, 1);
diff --git a/utils.c b/utils.c
index 4eb9046..27337af 100644
--- a/utils.c
+++ b/utils.c
@@ -101,6 +101,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_super_leafsize(&super, leafsize);
 	btrfs_set_super_nodesize(&super, nodesize);
 	btrfs_set_super_stripesize(&super, stripesize);
+	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
+	btrfs_set_super_csum_sectorsize(&super, BTRFS_CRC32_SIZE);
 	btrfs_set_super_chunk_root_generation(&super, 1);
 	if (label)
 		strcpy(super.label, label);
@@ -174,7 +176,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	nritems++;
 
 
-	csum_tree_block(NULL, buf, 0);
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[1]);
 	BUG_ON(ret != leafsize);
 
@@ -233,7 +235,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_bytenr(buf, blocks[2]);
 	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block(NULL, buf, 0);
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[2]);
 	BUG_ON(ret != leafsize);
 
@@ -315,7 +317,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_bytenr(buf, blocks[3]);
 	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block(NULL, buf, 0);
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
 
 	/* create the device tree */
@@ -348,14 +350,14 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_bytenr(buf, blocks[4]);
 	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block(NULL, buf, 0);
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
 
 	/* finally create the FS root */
 	btrfs_set_header_bytenr(buf, blocks[5]);
 	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-	csum_tree_block(NULL, buf, 0);
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[5]);
 	BUG_ON(ret != leafsize);
 
@@ -364,7 +366,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	memset(buf->data, 0, sectorsize);
 	memcpy(buf->data, &super, sizeof(super));
 	buf->len = sectorsize;
-	csum_tree_block(NULL, buf, 0);
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
 	BUG_ON(ret != sectorsize);
 
