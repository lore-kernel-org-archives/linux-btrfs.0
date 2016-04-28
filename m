Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15659 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbcD1Bnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 21:43:51 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH RFC v1.1 02/16] btrfs-progs: fsck: Introduce function to check data backref in extent tree
Date: Thu, 28 Apr 2016 09:43:39 +0800
Message-Id: <1461807819-29771-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1461642543-4621-3-git-send-email-quwenruo@cn.fujitsu.com>
References: <1461642543-4621-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function check_data_extent_item() to check if the
corresponding data backref exists in extent tree.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1.1:
   Fix a typo which passed wrong parameter for hash_extent_data_ref()
   Fix a generation mismatch condition, as for inband dedupe or reflink
   case, file extent generation can be larger than extent item generation. 
---
 cmds-check.c  | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h       |   2 +
 extent-tree.c |   2 +-
 3 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 27fc26f..a6ea0fd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -322,6 +322,7 @@ struct root_item_info {
  */
 #define MISSING_BACKREF	(1 << 0) /* Completely no backref in extent tree */
 #define BAD_BACKREF	(1 << 1) /* Backref mismatch */
+#define UNALIGNED_BYTES	(1 << 2) /* Some bytes are not aligned */
 
 static void *print_status_check(void *p)
 {
@@ -8565,6 +8566,157 @@ out:
 	return -err;
 }
 
+/*
+ * Check EXTENT_DATA item, mainly for its dbackref in extent tree
+ *
+ * Return <0 any error found and output error message
+ * Return 0 for no error found
+ */
+static int check_extent_data_item(struct btrfs_root *root,
+				  struct extent_buffer *eb, int slot)
+{
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_path path;
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_key key;
+	struct btrfs_key orig_key;
+	struct btrfs_key found_key;
+	struct extent_buffer *leaf;
+	struct btrfs_extent_item *ei;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_extent_data_ref *dref;
+	u64 owner;
+	u64 file_extent_gen;
+	u64 disk_bytenr;
+	u64 disk_num_bytes;
+	u64 extent_num_bytes;
+	u64 extent_flags;
+	u64 extent_gen;
+	u32 item_size;
+	unsigned long end;
+	unsigned long ptr;
+	int type;
+	u64 ref_root;
+	int found_dbackref = 0;
+	int err = 0;
+	int ret;
+
+	btrfs_item_key_to_cpu(eb, &orig_key, slot);
+	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+	file_extent_gen = btrfs_file_extent_generation(eb, fi);
+
+	/* Nothing to check for hole and inline data extents */
+	if (btrfs_file_extent_type(eb, fi) == BTRFS_FILE_EXTENT_INLINE ||
+	    btrfs_file_extent_disk_bytenr(eb, fi) == 0)
+		return 0;
+
+	disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
+	disk_num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
+	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
+	/* Check unaligned disk_num_bytes and num_bytes */
+	if (!IS_ALIGNED(disk_num_bytes, root->sectorsize)) {
+		error("File extent [%llu, %llu] has unaligned disk num bytes: %llu, should be aligned to %u",
+		      key.objectid, key.offset, disk_num_bytes,
+		      root->sectorsize);
+		err |= UNALIGNED_BYTES;
+	} else
+		data_bytes_allocated += disk_num_bytes;
+	if (!IS_ALIGNED(extent_num_bytes, root->sectorsize)) {
+		error("File extent [%llu, %llu] has unaligned num bytes: %llu, should be aligned to %u",
+		      key.objectid, key.offset, extent_num_bytes,
+		      root->sectorsize);
+		err |= UNALIGNED_BYTES;
+	} else
+		data_bytes_referenced += extent_num_bytes;
+	owner = btrfs_header_owner(eb);
+
+	/* Check the data backref in extent tree */
+	btrfs_init_path(&path);
+	key.objectid = btrfs_file_extent_disk_bytenr(eb, fi);
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = btrfs_file_extent_disk_num_bytes(eb, fi);
+
+	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+	if (ret) {
+		err |= MISSING_BACKREF;
+		goto error;
+	}
+
+	leaf = path.nodes[0];
+	slot = path.slots[0];
+	btrfs_item_key_to_cpu(leaf, &found_key, slot);
+	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+
+	extent_flags = btrfs_extent_flags(leaf, ei);
+	extent_gen = btrfs_extent_generation(leaf, ei);
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	if (!(extent_flags & BTRFS_EXTENT_FLAG_DATA)) {
+		error("Extent[%llu %llu] backref type mismatch, wanted bit: %llx",
+		      disk_bytenr, disk_num_bytes,
+		      BTRFS_EXTENT_FLAG_DATA);
+		err |= BAD_BACKREF;
+	}
+
+	if (file_extent_gen < extent_gen) {
+		error("Extent[%llu %llu] backref generation mismatch, wanted: <=%llu, have: %llu",
+		      disk_bytenr, disk_num_bytes, file_extent_gen,
+		      extent_gen);
+		err = BAD_BACKREF;
+	}
+
+	/* Check data backref */
+	item_size = btrfs_item_size_nr(leaf, path.slots[0]);
+	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	ptr = (unsigned long)iref;
+	end = (unsigned long)ei + item_size;
+	while (ptr < end) {
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		type = btrfs_extent_inline_ref_type(leaf, iref);
+		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
+
+		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
+			ref_root = btrfs_extent_data_ref_root(leaf, dref);
+			if (ref_root == owner || ref_root == root->objectid)
+				found_dbackref = 1;
+		} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
+			found_dbackref = !check_tree_block_ref(root, NULL,
+				btrfs_extent_inline_ref_offset(leaf, iref),
+				0, owner);
+		}
+
+		if (found_dbackref)
+			break;
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+
+	/* Didn't found inlined data backref, try EXTENT_DATA_REF_KEY */
+	if (!found_dbackref) {
+		btrfs_release_path(&path);
+
+		btrfs_init_path(&path);
+		key.objectid = btrfs_file_extent_disk_bytenr(eb, fi);
+		key.type = BTRFS_EXTENT_DATA_REF_KEY;
+		key.offset = hash_extent_data_ref(root->objectid,
+				orig_key.objectid, key.offset);
+
+		ret = btrfs_search_slot(NULL, root->fs_info->extent_root,
+					&key, &path, 0, 0);
+		if (!ret)
+			found_dbackref = 1;
+	}
+
+	if (!found_dbackref)
+		err |= MISSING_BACKREF;
+error:
+	btrfs_release_path(&path);
+	if (err & MISSING_BACKREF) {
+		error("Data extent[%llu %llu] backref lost",
+		      disk_bytenr, disk_num_bytes);
+	}
+	return err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
diff --git a/ctree.h b/ctree.h
index 2da6f77..906d6cd 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2338,6 +2338,8 @@ int exclude_super_stripes(struct btrfs_root *root,
 			  struct btrfs_block_group_cache *cache);
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       struct btrfs_fs_info *info, u64 start, u64 end);
+u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset);
+
 /* ctree.c */
 int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index 5ca53fa..607facb 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -598,7 +598,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 }
 #endif
 
-static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
+u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
 {
 	u32 high_crc = ~(u32)0;
 	u32 low_crc = ~(u32)0;
-- 
2.8.0



