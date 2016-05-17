Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbcEQJjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:10 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 12/16] btrfs-progs: fsck: Introduce function to check chunk item
Date: Tue, 17 May 2016 17:38:46 +0800
Message-Id: <1463477930-3925-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function check_chunk_item() to check a chunk item.
It will check all chunk stripes with dev extents and the corresponding
block group item.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index fa059c6..8070eb9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9435,6 +9435,118 @@ out:
 	return err;
 }
 
+/*
+ * Check a chunk item.
+ * Including checking all referred dev_extents and block group
+ */
+static int check_chunk_item(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *eb, int slot)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_path path;
+	struct btrfs_key chunk_key;
+	struct btrfs_key bg_key;
+	struct btrfs_key devext_key;
+	struct btrfs_chunk *chunk;
+	struct extent_buffer *leaf;
+	struct btrfs_block_group_item *bi;
+	struct btrfs_block_group_item bg_item;
+	struct btrfs_dev_extent *ptr;
+	u32 sectorsize = btrfs_super_sectorsize(fs_info->super_copy);
+	u64 length;
+	u64 chunk_end;
+	u64 type;
+	u64 profile;
+	int num_stripes;
+	u64 offset;
+	u64 objectid;
+	int i;
+	int ret;
+	int err = 0;
+
+	btrfs_item_key_to_cpu(eb, &chunk_key, slot);
+	chunk = btrfs_item_ptr(eb, slot, struct btrfs_chunk);
+	length = btrfs_chunk_length(eb, chunk);
+	chunk_end = chunk_key.offset + length;
+	if (!IS_ALIGNED(length, sectorsize)) {
+		error("Chunk[%llu %llu) not aligned to %u",
+		      chunk_key.offset, chunk_end, sectorsize);
+		err |= BYTES_UNALIGNED;
+		goto out;
+	}
+
+	type = btrfs_chunk_type(eb, chunk);
+	profile = type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+		error("Chunk[%llu %llu) has no chunk type",
+		      chunk_key.offset, chunk_end);
+		err |= UNKNOWN_TYPE;
+	}
+	if (profile && (profile & (profile - 1))) {
+		error("Chunk[%llu %llu) multiple profiled detected",
+		      chunk_key.offset, chunk_end);
+		err |= UNKNOWN_TYPE;
+	}
+
+	bg_key.objectid = chunk_key.offset;
+	bg_key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	bg_key.offset = length;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, extent_root, &bg_key, &path, 0, 0);
+	if (ret) {
+		error("Chunk[%llu %llu) didn't find the releative block group item",
+		      chunk_key.offset, chunk_end);
+		err |= REFERENCER_MISSING;
+	} else{
+		leaf = path.nodes[0];
+		bi = btrfs_item_ptr(leaf, path.slots[0],
+				    struct btrfs_block_group_item);
+		read_extent_buffer(leaf, &bg_item, (unsigned long)bi,
+				   sizeof(bg_item));
+		if (btrfs_block_group_flags(&bg_item) != type) {
+			error("Chunk[%llu %llu) releative block group item flags mismatch, wanted: %llu, have: %llu",
+			      chunk_key.offset, chunk_end, type,
+			      btrfs_block_group_flags(&bg_item));
+			err |= REFERENCER_MISSING;
+		}
+	}
+
+	num_stripes = btrfs_chunk_num_stripes(eb, chunk);
+	for (i = 0; i < num_stripes; i++) {
+		btrfs_release_path(&path);
+		btrfs_init_path(&path);
+		devext_key.objectid = btrfs_stripe_devid_nr(eb, chunk, i);
+		devext_key.type = BTRFS_DEV_EXTENT_KEY;
+		devext_key.offset = btrfs_stripe_offset_nr(eb, chunk, i);
+
+		ret = btrfs_search_slot(NULL, dev_root, &devext_key, &path,
+					0, 0);
+		if (ret)
+			goto not_match_dev;
+
+		leaf = path.nodes[0];
+		ptr = btrfs_item_ptr(leaf, path.slots[0],
+				     struct btrfs_dev_extent);
+		objectid = btrfs_dev_extent_chunk_objectid(leaf, ptr);
+		offset = btrfs_dev_extent_chunk_offset(leaf, ptr);
+		if (objectid != chunk_key.objectid ||
+		    offset != chunk_key.offset ||
+		    btrfs_dev_extent_length(leaf, ptr) != length)
+			goto not_match_dev;
+		continue;
+not_match_dev:
+		err |= BACKREF_MISSING;
+		error("Chunk[%llu %llu) stripe %d didn't find the releative dev extent",
+		      chunk_key.objectid, chunk_end, i);
+		continue;
+	}
+	btrfs_release_path(&path);
+out:
+	return err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



