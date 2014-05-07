Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29905 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaEGK4t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 06:56:49 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s47Aum9L026802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:49 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s47AulUq006888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:48 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s47AulZl002867
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:47 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: add another checksum algorithm xxhash
Date: Wed,  7 May 2014 18:56:32 +0800
Message-Id: <1399460193-1713-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"xxHash is an extremely fast non-cryptographic Hash algorithm, working at speeds
close to RAM limits."[1]  And xxhash is 32-bits hash, same as crc32.

This modifies btrfs's checksum API a bit and adopts xxhash as an alternative
checksum algorithm.

Note: We needs to update btrfs-progs side as well to set it up.

[1]: https://code.google.com/p/xxhash/

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/Kconfig            |  22 ++++++++
 fs/btrfs/compression.c      |   6 +--
 fs/btrfs/ctree.h            |  12 +++--
 fs/btrfs/dir-item.c         |  10 ++--
 fs/btrfs/disk-io.c          | 126 ++++++++++++++++++++++++--------------------
 fs/btrfs/disk-io.h          |   2 -
 fs/btrfs/extent-tree.c      |  43 ++++++++++-----
 fs/btrfs/file-item.c        |   9 ++--
 fs/btrfs/free-space-cache.c |  15 +++---
 fs/btrfs/hash.c             |  75 ++++++++++++++++++++------
 fs/btrfs/hash.h             |  22 ++++----
 fs/btrfs/inode-item.c       |   6 +--
 fs/btrfs/inode.c            |  16 +++---
 fs/btrfs/props.c            |  37 +++++++++++--
 fs/btrfs/props.h            |   3 +-
 fs/btrfs/scrub.c            |  70 +++++++++++++++++++-----
 fs/btrfs/send.c             |   7 ++-
 fs/btrfs/super.c            |   9 ++--
 fs/btrfs/tree-log.c         |   2 +-
 19 files changed, 331 insertions(+), 161 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index a66768e..ef45456 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -2,6 +2,7 @@ config BTRFS_FS
 	tristate "Btrfs filesystem support"
 	select CRYPTO
 	select CRYPTO_CRC32C
+	select CRYPTO_XXH32
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
@@ -88,3 +89,24 @@ config BTRFS_ASSERT
 	  any of the assertions trip.  This is meant for btrfs developers only.
 
 	  If unsure, say N.
+
+choice
+	prompt "choose checksum algorithm"
+	default BTRFS_CRC32C
+	help
+	   This option allows to select a checksum algorithm
+
+config BTRFS_CRC32C
+	depends on CRYPTO_CRC32C
+	bool "BTRFS_CRC32C"
+	help
+	   crc32c
+
+config BTRFS_XXH32
+	depends on CRYPTO_XXH32
+	bool "BTRFS_XXH32"
+	help
+	   xxhash
+
+endchoice
+
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d43c544..889b0f1 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -41,6 +41,7 @@
 #include "compression.h"
 #include "extent_io.h"
 #include "extent_map.h"
+#include "hash.h"
 
 struct compressed_bio {
 	/* number of bios pending for this compressed extent */
@@ -114,17 +115,16 @@ static int check_compressed_csum(struct inode *inode,
 	char *kaddr;
 	u32 csum;
 	u32 *cb_sum = &cb->sums;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		return 0;
 
 	for (i = 0; i < cb->nr_pages; i++) {
 		page = cb->compressed_pages[i];
-		csum = ~(u32)0;
 
 		kaddr = kmap_atomic(page);
-		csum = btrfs_csum_data(kaddr, csum, PAGE_CACHE_SIZE);
-		btrfs_csum_final(csum, (char *)&csum);
+		btrfs_csum_data(fs_info, kaddr, PAGE_CACHE_SIZE, (char *)&csum);
 		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ba6b885..cbb6533 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -176,12 +176,16 @@ struct btrfs_ordered_sum;
 /* 32 bytes in various csum fields */
 #define BTRFS_CSUM_SIZE 32
 
-/* csum types */
+/*
+ * csum types,
+ * - 4 bytes for CRC32(crc32c)
+ * - 4 bytes for XXH32(xxhash)
+ */
 #define BTRFS_CSUM_TYPE_CRC32	0
+#define BTRFS_CSUM_TYPE_XXH32	1
 
-static int btrfs_csum_sizes[] = { 4, 0 };
+static int btrfs_csum_sizes[] = { 4, 4, 0 };
 
-/* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
 
 /* spefic to btrfs_map_block(), therefore not in include/linux/blk_types.h */
@@ -1688,6 +1692,8 @@ struct btrfs_fs_info {
 
 	struct semaphore uuid_tree_rescan_sem;
 	unsigned int update_uuid_tree_gen:1;
+
+	struct crypto_shash *tfm;
 };
 
 struct btrfs_subvolume_writers {
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index a0691df..1332858 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -87,7 +87,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 
 	key.objectid = objectid;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	key.offset = btrfs_name_hash(name, name_len);
+	key.offset = btrfs_name_hash(root->fs_info, name, name_len);
 
 	data_size = sizeof(*dir_item) + name_len + data_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
@@ -138,7 +138,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	key.objectid = btrfs_ino(dir);
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
-	key.offset = btrfs_name_hash(name, name_len);
+	key.offset = btrfs_name_hash(root->fs_info, name, name_len);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -206,7 +206,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 
-	key.offset = btrfs_name_hash(name, name_len);
+	key.offset = btrfs_name_hash(root->fs_info, name, name_len);
 
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
@@ -235,7 +235,7 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
-	key.offset = btrfs_name_hash(name, name_len);
+	key.offset = btrfs_name_hash(root->fs_info, name, name_len);
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 
@@ -368,7 +368,7 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	key.offset = btrfs_name_hash(name, name_len);
+	key.offset = btrfs_name_hash(root->fs_info, name, name_len);
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9833149..e05535c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -242,34 +242,24 @@ out:
 	return em;
 }
 
-u32 btrfs_csum_data(char *data, u32 seed, size_t len)
+int btrfs_gen_csum_tree_block(struct btrfs_fs_info *info, struct extent_buffer *buf, char *result)
 {
-	return btrfs_crc32c(seed, data, len);
-}
-
-void btrfs_csum_final(u32 crc, char *result)
-{
-	put_unaligned_le32(~crc, result);
-}
-
-/*
- * compute the csum for a btree block, and either verify it or write it
- * into the csum field of the block.
- */
-static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-			   int verify)
-{
-	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
-	char *result = NULL;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(info->tfm)];
+	} desc;
 	unsigned long len;
 	unsigned long cur_len;
 	unsigned long offset = BTRFS_CSUM_SIZE;
-	char *kaddr;
 	unsigned long map_start;
 	unsigned long map_len;
+	char *kaddr;
 	int err;
-	u32 crc = ~(u32)0;
-	unsigned long inline_result;
+
+	desc.shash.tfm = info->tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
 
 	len = buf->len - offset;
 	while (len > 0) {
@@ -278,11 +268,27 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		if (err)
 			return 1;
 		cur_len = min(len, map_len - (offset - map_start));
-		crc = btrfs_csum_data(kaddr + offset - map_start,
-				      crc, cur_len);
+		crypto_shash_update(&desc.shash,
+					  kaddr + offset - map_start, cur_len);
 		len -= cur_len;
 		offset += cur_len;
 	}
+
+	return crypto_shash_final(&desc.shash, result);
+}
+
+/*
+ * compute the csum for a btree block, and either verify it or write it
+ * into the csum field of the block.
+ */
+static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
+			   int verify)
+{
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	char *result = NULL;
+	unsigned long inline_result;
+	int err;
+
 	if (csum_size > sizeof(inline_result)) {
 		result = kzalloc(csum_size * sizeof(char), GFP_NOFS);
 		if (!result)
@@ -291,7 +297,12 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		result = (char *)&inline_result;
 	}
 
-	btrfs_csum_final(crc, result);
+	err = btrfs_gen_csum_tree_block(root->fs_info, buf, result);
+	if (err) {
+		if (result != (char *)&inline_result)
+			kfree(result);
+		return 1;
+	}
 
 	if (verify) {
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
@@ -376,43 +387,40 @@ out:
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
  */
-static int btrfs_check_super_csum(char *raw_disk_sb)
+static int btrfs_check_super_csum(struct btrfs_fs_info *info, char *raw_disk_sb)
 {
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
 	u16 csum_type = btrfs_super_csum_type(disk_sb);
 	int ret = 0;
-
-	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
-		u32 crc = ~(u32)0;
-		const int csum_size = sizeof(crc);
-		char result[csum_size];
-
-		/*
-		 * The super_block structure does not span the whole
-		 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
-		 * is filled with zeros and is included in the checkum.
-		 */
-		crc = btrfs_csum_data(raw_disk_sb + BTRFS_CSUM_SIZE,
-				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-		btrfs_csum_final(crc, result);
-
-		if (memcmp(raw_disk_sb, result, csum_size))
-			ret = 1;
-
-		if (ret && btrfs_super_generation(disk_sb) < 10) {
-			printk(KERN_WARNING
-				"BTRFS: super block crcs don't match, older mkfs detected\n");
-			ret = 0;
-		}
-	}
+	const int csum_size = btrfs_super_csum_size(disk_sb);
+	char result[csum_size];
 
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
 		printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
 				csum_type);
 		ret = 1;
+		goto out;
 	}
 
+	/*
+	 * The super_block structure does not span the whole
+	 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
+	 * is filled with zeros and is included in the checkum.
+	 */
+	btrfs_csum_data(info, raw_disk_sb + BTRFS_CSUM_SIZE,
+			BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE, result);
+
+	if (memcmp(raw_disk_sb, result, csum_size))
+		ret = 1;
+
+	if (ret && btrfs_super_generation(disk_sb) < 10) {
+		printk(KERN_WARNING
+			"BTRFS: super block crcs don't match, older mkfs detected\n");
+		ret = 0;
+	}
+
+out:
 	return ret;
 }
 
@@ -2389,11 +2397,17 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	if (btrfs_hash_init(fs_info)) {
+		err = -EINVAL;
+		btrfs_err(fs_info, "BTRFS: hash init error");
+		goto fail_alloc;
+	}
+
 	/*
 	 * We want to check superblock checksum, the type is stored inside.
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
-	if (btrfs_check_super_csum(bh->b_data)) {
+	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
 		printk(KERN_ERR "BTRFS: superblock checksum mismatch\n");
 		err = -EINVAL;
 		goto fail_alloc;
@@ -2990,6 +3004,7 @@ fail_tree_roots:
 fail_sb_buffer:
 	btrfs_stop_all_workers(fs_info);
 fail_alloc:
+	btrfs_hash_exit(fs_info);
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
@@ -3110,7 +3125,6 @@ static int write_dev_supers(struct btrfs_device *device,
 	int i;
 	int ret;
 	int errors = 0;
-	u32 crc;
 	u64 bytenr;
 
 	if (max_mirrors == 0)
@@ -3141,12 +3155,8 @@ static int write_dev_supers(struct btrfs_device *device,
 		} else {
 			btrfs_set_super_bytenr(sb, bytenr);
 
-			crc = ~(u32)0;
-			crc = btrfs_csum_data((char *)sb +
-					      BTRFS_CSUM_SIZE, crc,
-					      BTRFS_SUPER_INFO_SIZE -
-					      BTRFS_CSUM_SIZE);
-			btrfs_csum_final(crc, sb->csum);
+			btrfs_csum_data(device->dev_root->fs_info, (char *)sb + BTRFS_CSUM_SIZE,
+					BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE, sb->csum);
 
 			/*
 			 * one reference for us, and we leave it for the
@@ -3658,6 +3668,8 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_free_block_rsv(root, root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
 
+	btrfs_hash_exit(fs_info);
+
 	return 0;
 }
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 53059df..d98451e 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -115,8 +115,6 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
-u32 btrfs_csum_data(char *data, u32 seed, size_t len);
-void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			int metadata);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5590af9..de43238 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -36,6 +36,7 @@
 #include "free-space-cache.h"
 #include "math.h"
 #include "sysfs.h"
+#include "hash.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -1067,26 +1068,44 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 }
 #endif
 
-static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
+static u64 hash_extent_data_ref(struct btrfs_fs_info *info, u64 root_objectid, u64 owner, u64 offset)
 {
-	u32 high_crc = ~(u32)0;
-	u32 low_crc = ~(u32)0;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(info->tfm)];
+	} desc;
+	int err;
+	u32 high_crc;
+	u32 low_crc;
 	__le64 lenum;
 
+	desc.shash.tfm = info->tfm;
+	desc.shash.flags = 0;
+
+	/* high part */
 	lenum = cpu_to_le64(root_objectid);
-	high_crc = btrfs_crc32c(high_crc, &lenum, sizeof(lenum));
+	crypto_shash_digest(&desc.shash, (u8 *)&lenum, sizeof(lenum), (char *)&high_crc);
+	high_crc = le32_to_cpu(high_crc);
+
+	/* low part */
+	crypto_shash_init(&desc.shash);
+
 	lenum = cpu_to_le64(owner);
-	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+	crypto_shash_update(&desc.shash, (u8 *)&lenum, sizeof(lenum));
+
 	lenum = cpu_to_le64(offset);
-	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+	crypto_shash_update(&desc.shash, (u8 *)&lenum, sizeof(lenum));
+
+	err = crypto_shash_final(&desc.shash, (char *)&low_crc);
+	low_crc = le32_to_cpu(low_crc);
 
 	return ((u64)high_crc << 31) ^ (u64)low_crc;
 }
 
-static u64 hash_extent_data_ref_item(struct extent_buffer *leaf,
+static u64 hash_extent_data_ref_item(struct btrfs_fs_info *info, struct extent_buffer *leaf,
 				     struct btrfs_extent_data_ref *ref)
 {
-	return hash_extent_data_ref(btrfs_extent_data_ref_root(leaf, ref),
+	return hash_extent_data_ref(info, btrfs_extent_data_ref_root(leaf, ref),
 				    btrfs_extent_data_ref_objectid(leaf, ref),
 				    btrfs_extent_data_ref_offset(leaf, ref));
 }
@@ -1123,7 +1142,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		key.offset = parent;
 	} else {
 		key.type = BTRFS_EXTENT_DATA_REF_KEY;
-		key.offset = hash_extent_data_ref(root_objectid,
+		key.offset = hash_extent_data_ref(root->fs_info, root_objectid,
 						  owner, offset);
 	}
 again:
@@ -1209,7 +1228,7 @@ static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
 		size = sizeof(struct btrfs_shared_data_ref);
 	} else {
 		key.type = BTRFS_EXTENT_DATA_REF_KEY;
-		key.offset = hash_extent_data_ref(root_objectid,
+		key.offset = hash_extent_data_ref(root->fs_info, root_objectid,
 						  owner, offset);
 		size = sizeof(struct btrfs_extent_data_ref);
 	}
@@ -1612,8 +1631,8 @@ again:
 				err = 0;
 				break;
 			}
-			if (hash_extent_data_ref_item(leaf, dref) <
-			    hash_extent_data_ref(root_objectid, owner, offset))
+			if (hash_extent_data_ref_item(root->fs_info, leaf, dref) <
+			    hash_extent_data_ref(root->fs_info, root_objectid, owner, offset))
 				break;
 		} else {
 			u64 ref_offset;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 127555b..4e3ec0f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -25,6 +25,7 @@
 #include "transaction.h"
 #include "volumes.h"
 #include "print-tree.h"
+#include "hash.h"
 
 #define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
 				   sizeof(struct btrfs_item) * 2) / \
@@ -491,13 +492,9 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		}
 
 		data = kmap_atomic(bvec->bv_page);
-		sums->sums[index] = ~(u32)0;
-		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
-						    sums->sums[index],
-						    bvec->bv_len);
+		btrfs_csum_data(root->fs_info, data + bvec->bv_offset,
+			    bvec->bv_len, (char *)(sums->sums + index));
 		kunmap_atomic(data);
-		btrfs_csum_final(sums->sums[index],
-				 (char *)(sums->sums + index));
 
 		bio_index++;
 		index++;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 73f3de7..0c16d5b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -27,6 +27,7 @@
 #include "disk-io.h"
 #include "extent_io.h"
 #include "inode-map.h"
+#include "hash.h"
 
 #define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
@@ -418,7 +419,7 @@ static int io_ctl_check_generation(struct io_ctl *io_ctl, u64 generation)
 static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 {
 	u32 *tmp;
-	u32 crc = ~(u32)0;
+	u32 crc;
 	unsigned offset = 0;
 
 	if (!io_ctl->check_crcs) {
@@ -429,9 +430,8 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-	crc = btrfs_csum_data(io_ctl->orig + offset, crc,
-			      PAGE_CACHE_SIZE - offset);
-	btrfs_csum_final(crc, (char *)&crc);
+	btrfs_csum_data(io_ctl->root->fs_info, io_ctl->orig + offset,
+			      PAGE_CACHE_SIZE - offset, (char *)&crc);
 	io_ctl_unmap_page(io_ctl);
 	tmp = kmap(io_ctl->pages[0]);
 	tmp += index;
@@ -442,7 +442,7 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 {
 	u32 *tmp, val;
-	u32 crc = ~(u32)0;
+	u32 crc;
 	unsigned offset = 0;
 
 	if (!io_ctl->check_crcs) {
@@ -459,9 +459,8 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 	kunmap(io_ctl->pages[0]);
 
 	io_ctl_map_page(io_ctl, 0);
-	crc = btrfs_csum_data(io_ctl->orig + offset, crc,
-			      PAGE_CACHE_SIZE - offset);
-	btrfs_csum_final(crc, (char *)&crc);
+	btrfs_csum_data(io_ctl->root->fs_info, io_ctl->orig + offset,
+			      PAGE_CACHE_SIZE - offset, (char *)&crc);
 	if (val != crc) {
 		printk_ratelimited(KERN_ERR "BTRFS: csum mismatch on free "
 				   "space cache\n");
diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
index 85889aa..f93e07d 100644
--- a/fs/btrfs/hash.c
+++ b/fs/btrfs/hash.c
@@ -11,40 +11,85 @@
  * General Public License for more details.
  */
 
-#include <crypto/hash.h>
-#include <linux/err.h>
 #include "hash.h"
 
-static struct crypto_shash *tfm;
-
-int __init btrfs_hash_init(void)
+int btrfs_hash_init(struct btrfs_fs_info *info)
 {
+	struct crypto_shash *tfm = NULL;
+	int ret = -EINVAL;
+
+#if defined(CONFIG_BTRFS_CRC32C)
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
+	ret = 0;
+#elif defined(CONFIG_BTRFS_XXH32)
+	tfm = crypto_alloc_shash("xxh32", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	ret = 0;
+#endif
 
-	return 0;
+	info->tfm = tfm;
+	return ret;
 }
 
-void btrfs_hash_exit(void)
+void btrfs_hash_exit(struct btrfs_fs_info *info)
 {
-	crypto_free_shash(tfm);
+	crypto_free_shash(info->tfm);
 }
 
-u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
+int btrfs_csum_data(struct btrfs_fs_info *info, const void *address, unsigned int length, u8 *out)
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
+		char ctx[crypto_shash_descsize(info->tfm)];
 	} desc;
 	int err;
 
-	desc.shash.tfm = tfm;
+	desc.shash.tfm = info->tfm;
 	desc.shash.flags = 0;
-	*(u32 *)desc.ctx = crc;
 
-	err = crypto_shash_update(&desc.shash, address, length);
-	BUG_ON(err);
+	err = crypto_shash_digest(&desc.shash, address, length, out);
+	ASSERT(!err);
+
+	return err;
+}
+
+u64 btrfs_name_hash(struct btrfs_fs_info *info, const char *name, int len)
+{
+	u32 hash;
+
+	btrfs_csum_data(info, name, len, (char *)&hash);
 
-	return *(u32 *)desc.ctx;
+	return le32_to_cpu(hash);
 }
+
+/*
+ * Figure the key offset of an extended inode ref
+ */
+u64 btrfs_extref_hash(struct btrfs_fs_info *info, u64 parent_objectid, const char *name, int len)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(info->tfm)];
+	} desc;
+	int err;
+	u32 hash;
+
+	desc.shash.tfm = info->tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
+
+	crypto_shash_update(&desc.shash, (char *)&parent_objectid, sizeof(u64));
+
+	crypto_shash_update(&desc.shash, name, len);
+
+	err = crypto_shash_final(&desc.shash, (char *)&hash);
+	ASSERT(!err);
+
+	return le32_to_cpu(hash);
+}
+
+
diff --git a/fs/btrfs/hash.h b/fs/btrfs/hash.h
index 118a231..2a16a4f 100644
--- a/fs/btrfs/hash.h
+++ b/fs/btrfs/hash.h
@@ -19,24 +19,22 @@
 #ifndef __HASH__
 #define __HASH__
 
-int __init btrfs_hash_init(void);
+#include <crypto/hash.h>
+#include <linux/err.h>
+#include <crypto/xxhash.h>
+#include "ctree.h"
 
-void btrfs_hash_exit(void);
+int btrfs_hash_init(struct btrfs_fs_info *info);
 
-u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length);
+void btrfs_hash_exit(struct btrfs_fs_info *info);
 
-static inline u64 btrfs_name_hash(const char *name, int len)
-{
-	return btrfs_crc32c((u32)~1, name, len);
-}
+int btrfs_csum_data(struct btrfs_fs_info *info, const void *address, unsigned int length, u8 *out);
+
+u64 btrfs_name_hash(struct btrfs_fs_info *info, const char *name, int len);
 
 /*
  * Figure the key offset of an extended inode ref
  */
-static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
-				    int len)
-{
-	return (u64) btrfs_crc32c(parent_objectid, name, len);
-}
+u64 btrfs_extref_hash(struct btrfs_fs_info *info, u64 parent_objectid, const char *name, int len);
 
 #endif
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 2be38df..efca894 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -106,7 +106,7 @@ btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
 
 	key.objectid = inode_objectid;
 	key.type = BTRFS_INODE_EXTREF_KEY;
-	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
+	key.offset = btrfs_extref_hash(root->fs_info, ref_objectid, name, name_len);
 
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
@@ -136,7 +136,7 @@ static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 
 	key.objectid = inode_objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
-	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
+	key.offset = btrfs_extref_hash(root->fs_info, ref_objectid, name, name_len);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -283,7 +283,7 @@ static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
 
 	key.objectid = inode_objectid;
 	key.type = BTRFS_INODE_EXTREF_KEY;
-	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
+	key.offset = btrfs_extref_hash(root->fs_info, ref_objectid, name, name_len);
 
 	path = btrfs_alloc_path();
 	if (!path)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f805bc..10dde99 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2825,7 +2825,7 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	char *kaddr;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u32 csum_expected;
-	u32 csum = ~(u32)0;
+	u32 csum;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 	                              DEFAULT_RATELIMIT_BURST);
 
@@ -2848,8 +2848,7 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	csum_expected = *(((u32 *)io_bio->csum) + phy_offset);
 
 	kaddr = kmap_atomic(page);
-	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
-	btrfs_csum_final(csum, (char *)&csum);
+	btrfs_csum_data(root->fs_info, kaddr + offset, end - start + 1, (char *)&csum);
 	if (csum != csum_expected)
 		goto zeroit;
 
@@ -3307,9 +3306,9 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 	int scanned = 0;
 
 	if (!xattr_access) {
-		xattr_access = btrfs_name_hash(POSIX_ACL_XATTR_ACCESS,
+		xattr_access = btrfs_name_hash(leaf->fs_info, POSIX_ACL_XATTR_ACCESS,
 					strlen(POSIX_ACL_XATTR_ACCESS));
-		xattr_default = btrfs_name_hash(POSIX_ACL_XATTR_DEFAULT,
+		xattr_default = btrfs_name_hash(leaf->fs_info, POSIX_ACL_XATTR_DEFAULT,
 					strlen(POSIX_ACL_XATTR_DEFAULT));
 	}
 
@@ -7017,14 +7016,13 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
 			struct page *page = bvec->bv_page;
 			char *kaddr;
-			u32 csum = ~(u32)0;
+			u32 csum;
 			unsigned long flags;
 
 			local_irq_save(flags);
 			kaddr = kmap_atomic(page);
-			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
-					       csum, bvec->bv_len);
-			btrfs_csum_final(csum, (char *)&csum);
+			btrfs_csum_data(root->fs_info, kaddr + bvec->bv_offset,
+					       bvec->bv_len, (char *)&csum);
 			kunmap_atomic(kaddr);
 			local_irq_restore(flags);
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 129b1dd..0f70daa 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -23,6 +23,8 @@
 #include "transaction.h"
 #include "xattr.h"
 
+static struct crypto_shash *tfm;
+
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
 
@@ -54,17 +56,46 @@ static struct prop_handler prop_handlers[] = {
 	}
 };
 
-void __init btrfs_props_init(void)
+static u64 btrfs_prop_name_hash(const char *name, unsigned long len)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(tfm)];
+	} desc;
+	int err;
+	u32 h;
+
+	desc.shash.tfm = tfm;
+	desc.shash.flags = 0;
+
+	err = crypto_shash_digest(&desc.shash, name, len, (char *)&h);
+	ASSERT(!err);
+
+	return le32_to_cpu(h);
+}
+
+int __init btrfs_props_init(void)
 {
 	struct prop_handler *p;
 
+	tfm = crypto_alloc_shash("xxhash", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
 	hash_init(prop_handlers_ht);
 
 	for (p = &prop_handlers[0]; p->xattr_name; p++) {
-		u64 h = btrfs_name_hash(p->xattr_name, strlen(p->xattr_name));
+		u64 h = btrfs_prop_name_hash(p->xattr_name, strlen(p->xattr_name));
 
 		hash_add(prop_handlers_ht, &p->node, h);
 	}
+
+	return 0;
+}
+
+void btrfs_props_exit(void)
+{
+	crypto_free_shash(tfm);
 }
 
 static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
@@ -85,7 +116,7 @@ find_prop_handler(const char *name,
 	struct prop_handler *h;
 
 	if (!handlers) {
-		u64 hash = btrfs_name_hash(name, strlen(name));
+		u64 hash = btrfs_prop_name_hash(name, strlen(name));
 
 		handlers = find_prop_handlers_by_hash(hash);
 		if (!handlers)
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 100f188..7cce909 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -21,7 +21,8 @@
 
 #include "ctree.h"
 
-void __init btrfs_props_init(void);
+int __init btrfs_props_init(void);
+void btrfs_props_exit(void);
 
 int btrfs_set_prop(struct inode *inode,
 		   const char *name,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0be7799..927fa1e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -29,6 +29,7 @@
 #include "check-integrity.h"
 #include "rcu-string.h"
 #include "raid56.h"
+#include "hash.h"
 
 /*
  * This is only the first step towards a full-features scrub. It reads all
@@ -1368,8 +1369,11 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 {
 	int page_num;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
-	u32 crc = ~(u32)0;
 	void *mapped_buffer;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->tfm)];
+	} desc;
 
 	WARN_ON(!sblock->pagev[0]->page);
 	if (is_metadata) {
@@ -1395,13 +1399,19 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		mapped_buffer = kmap_atomic(sblock->pagev[0]->page);
 	}
 
+	desc.shash.tfm = fs_info->tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
+
 	for (page_num = 0;;) {
 		if (page_num == 0 && is_metadata)
-			crc = btrfs_csum_data(
+			crypto_shash_update(&desc.shash,
 				((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE,
-				crc, PAGE_SIZE - BTRFS_CSUM_SIZE);
+				PAGE_SIZE - BTRFS_CSUM_SIZE);
 		else
-			crc = btrfs_csum_data(mapped_buffer, crc, PAGE_SIZE);
+			crypto_shash_update(&desc.shash, mapped_buffer,
+					 PAGE_SIZE);
 
 		kunmap_atomic(mapped_buffer);
 		page_num++;
@@ -1412,7 +1422,8 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		mapped_buffer = kmap_atomic(sblock->pagev[page_num]->page);
 	}
 
-	btrfs_csum_final(crc, calculated_csum);
+	crypto_shash_final(&desc.shash, calculated_csum);
+
 	if (memcmp(calculated_csum, csum, csum_size))
 		sblock->checksum_error = 1;
 }
@@ -1676,10 +1687,14 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	u8 *on_disk_csum;
 	struct page *page;
 	void *buffer;
-	u32 crc = ~(u32)0;
 	int fail = 0;
 	u64 len;
 	int index;
+	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->tfm)];
+	} desc;
 
 	BUG_ON(sblock->page_count < 1);
 	if (!sblock->pagev[0]->have_csum)
@@ -1691,10 +1706,16 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 
 	len = sctx->sectorsize;
 	index = 0;
+
+	desc.shash.tfm = fs_info->tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
+
 	for (;;) {
 		u64 l = min_t(u64, len, PAGE_SIZE);
 
-		crc = btrfs_csum_data(buffer, crc, l);
+		crypto_shash_update(&desc.shash, buffer, l);
 		kunmap_atomic(buffer);
 		len -= l;
 		if (len == 0)
@@ -1706,7 +1727,8 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 		buffer = kmap_atomic(page);
 	}
 
-	btrfs_csum_final(crc, csum);
+	crypto_shash_final(&desc.shash, csum);
+
 	if (memcmp(csum, on_disk_csum, sctx->csum_size))
 		fail = 1;
 
@@ -1725,11 +1747,14 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	void *mapped_buffer;
 	u64 mapped_size;
 	void *p;
-	u32 crc = ~(u32)0;
 	int fail = 0;
 	int crc_fail = 0;
 	u64 len;
 	int index;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->tfm)];
+	} desc;
 
 	BUG_ON(sblock->page_count < 1);
 	page = sblock->pagev[0]->page;
@@ -1761,10 +1786,16 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
 	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
 	index = 0;
+
+	desc.shash.tfm = fs_info->tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
+
 	for (;;) {
 		u64 l = min_t(u64, len, mapped_size);
 
-		crc = btrfs_csum_data(p, crc, l);
+		crypto_shash_update(&desc.shash, p, l);
 		kunmap_atomic(mapped_buffer);
 		len -= l;
 		if (len == 0)
@@ -1778,7 +1809,8 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 		p = mapped_buffer;
 	}
 
-	btrfs_csum_final(crc, calculated_csum);
+	crypto_shash_final(&desc.shash, calculated_csum);
+
 	if (memcmp(calculated_csum, on_disk_csum, sctx->csum_size))
 		++crc_fail;
 
@@ -1797,11 +1829,14 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	void *mapped_buffer;
 	u64 mapped_size;
 	void *p;
-	u32 crc = ~(u32)0;
 	int fail_gen = 0;
 	int fail_cor = 0;
 	u64 len;
 	int index;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->tfm)];
+	} desc;
 
 	BUG_ON(sblock->page_count < 1);
 	page = sblock->pagev[0]->page;
@@ -1822,10 +1857,16 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
 	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
 	index = 0;
+
+	desc.shash.tfm = fs_info->tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
+
 	for (;;) {
 		u64 l = min_t(u64, len, mapped_size);
 
-		crc = btrfs_csum_data(p, crc, l);
+		crypto_shash_update(&desc.shash, p, l);
 		kunmap_atomic(mapped_buffer);
 		len -= l;
 		if (len == 0)
@@ -1839,7 +1880,8 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		p = mapped_buffer;
 	}
 
-	btrfs_csum_final(crc, calculated_csum);
+	crypto_shash_final(&desc.shash, calculated_csum);
+
 	if (memcmp(calculated_csum, on_disk_csum, sctx->csum_size))
 		++fail_cor;
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index eb6537a..0bc2f71 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -664,13 +664,16 @@ static int send_cmd(struct send_ctx *sctx)
 	int ret;
 	struct btrfs_cmd_header *hdr;
 	u32 crc;
+	char *result;
 
 	hdr = (struct btrfs_cmd_header *)sctx->send_buf;
 	hdr->len = cpu_to_le32(sctx->send_size - sizeof(*hdr));
 	hdr->crc = 0;
 
-	crc = btrfs_crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
-	hdr->crc = cpu_to_le32(crc);
+	result = (char *)&crc;
+	btrfs_csum_data(sctx->send_root->fs_info, (unsigned char *)sctx->send_buf, sctx->send_size, result);
+	/* crc is already convert to __le32. */
+	hdr->crc = crc;
 
 	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
 					&sctx->send_off);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9601d25..e89338f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -880,6 +880,7 @@ static struct dentry *get_default_root(struct super_block *sb,
 		 * it's always been there, but don't freak out, just try and
 		 * mount to root most subvolume.
 		 */
+		btrfs_info(fs_info, "default NOT FOUND, go for fsroot\n");
 		btrfs_free_path(path);
 		dir_id = BTRFS_FIRST_FREE_OBJECTID;
 		new_root = fs_info->fs_root;
@@ -1903,12 +1904,10 @@ static int __init init_btrfs_fs(void)
 {
 	int err;
 
-	err = btrfs_hash_init();
+	err = btrfs_props_init();
 	if (err)
 		return err;
 
-	btrfs_props_init();
-
 	err = btrfs_init_sysfs();
 	if (err)
 		goto free_hash;
@@ -1987,7 +1986,7 @@ free_compress:
 	btrfs_exit_compress();
 	btrfs_exit_sysfs();
 free_hash:
-	btrfs_hash_exit();
+	btrfs_props_exit();
 	return err;
 }
 
@@ -2006,7 +2005,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_exit_sysfs();
 	btrfs_cleanup_fs_uuids();
 	btrfs_exit_compress();
-	btrfs_hash_exit();
+	btrfs_props_exit();
 }
 
 late_initcall(init_btrfs_fs);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e2f45fc..42c68fb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1014,7 +1014,7 @@ again:
 
 			search_key.objectid = inode_objectid;
 			search_key.type = BTRFS_INODE_EXTREF_KEY;
-			search_key.offset = btrfs_extref_hash(parent_objectid,
+			search_key.offset = btrfs_extref_hash(root->fs_info, parent_objectid,
 							      victim_name,
 							      victim_name_len);
 			ret = 0;
-- 
1.8.1.4

