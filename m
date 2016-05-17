Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbcEQJjN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:13 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 11/16] btrfs-progs: fsck: Introduce function to check block group item
Date: Tue, 17 May 2016 17:38:45 +0800
Message-Id: <1463477930-3925-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function check_block_group_item() to check a block group item.
It will check the referencer chunk and the used space accounting with
extent tree.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index eec9648..fa059c6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -328,6 +328,7 @@ struct root_item_info {
 #define ITEM_SIZE_MISMATCH	(1 << 5) /* Bad item size */
 #define UNKNOWN_TYPE		(1 << 6) /* Unknown type */
 #define ACCOUNTING_MISMATCH	(1 << 7) /* Used space accounting error */
+#define CHUNK_TYPE_MISMATCH	(1 << 8)
 
 static void *print_status_check(void *p)
 {
@@ -9315,6 +9316,125 @@ next:
 	return 0;
 }
 
+/*
+ * Check a block group item with its referener(chunk) and its used space
+ * with extent/metadata item
+ */
+static int check_block_group_item(struct btrfs_fs_info *fs_info,
+				  struct extent_buffer *eb, int slot)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_block_group_item *bi;
+	struct btrfs_block_group_item bg_item;
+	struct btrfs_path path;
+	struct btrfs_key bg_key;
+	struct btrfs_key chunk_key;
+	struct btrfs_key extent_key;
+	struct btrfs_chunk *chunk;
+	struct extent_buffer *leaf;
+	struct btrfs_extent_item *ei;
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u64 flags;
+	u64 bg_flags;
+	u64 used;
+	u64 total = 0;
+	int ret;
+	int err = 0;
+
+	btrfs_item_key_to_cpu(eb, &bg_key, slot);
+	bi = btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
+	read_extent_buffer(eb, &bg_item, (unsigned long)bi, sizeof(bg_item));
+	used = btrfs_block_group_used(&bg_item);
+	bg_flags = btrfs_block_group_flags(&bg_item);
+
+	chunk_key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	chunk_key.type = BTRFS_CHUNK_ITEM_KEY;
+	chunk_key.offset = bg_key.objectid;
+
+	btrfs_init_path(&path);
+	/* Search for the referencer chunk */
+	ret = btrfs_search_slot(NULL, chunk_root, &chunk_key, &path, 0, 0);
+	if (ret) {
+		error("Block group[%llu %llu] didn't find the releative chunk item",
+		      bg_key.objectid, bg_key.offset);
+		err |= REFERENCER_MISSING;
+	} else {
+		chunk = btrfs_item_ptr(path.nodes[0], path.slots[0],
+					struct btrfs_chunk);
+		if (btrfs_chunk_length(path.nodes[0], chunk) !=
+						bg_key.offset) {
+			error("Block group[%llu %llu] relative chunk item length don't match",
+			      bg_key.objectid, bg_key.offset);
+			err |= REFERENCER_MISMATCH;
+		}
+	}
+	btrfs_release_path(&path);
+
+	/* Search from the block group bytenr */
+	extent_key.objectid = bg_key.objectid;
+	extent_key.type = 0;
+	extent_key.offset = 0;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, extent_root, &extent_key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	/* Iterate extent tree to account used space */
+	while (1) {
+		leaf = path.nodes[0];
+		btrfs_item_key_to_cpu(leaf, &extent_key, path.slots[0]);
+		if (extent_key.objectid >= bg_key.objectid + bg_key.offset)
+			break;
+
+		if (extent_key.type != BTRFS_METADATA_ITEM_KEY &&
+		    extent_key.type != BTRFS_EXTENT_ITEM_KEY)
+			goto next;
+		if (extent_key.objectid < bg_key.objectid)
+			goto next;
+
+		if (extent_key.type == BTRFS_METADATA_ITEM_KEY)
+			total += nodesize;
+		else
+			total += extent_key.offset;
+
+		ei = btrfs_item_ptr(leaf, path.slots[0],
+				    struct btrfs_extent_item);
+		flags = btrfs_extent_flags(leaf, ei);
+		if (flags & BTRFS_EXTENT_FLAG_DATA) {
+			if (!(bg_flags & BTRFS_BLOCK_GROUP_DATA)) {
+				error("bad extent[%llu, %llu) type mismatch with chunk",
+				      extent_key.objectid,
+				      extent_key.objectid + extent_key.offset);
+				err |= CHUNK_TYPE_MISMATCH;
+			}
+		} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+			if (!(bg_flags & (BTRFS_BLOCK_GROUP_SYSTEM |
+				    BTRFS_BLOCK_GROUP_METADATA))) {
+				error("bad extent[%llu, %llu) type mismatch with chunk",
+				      extent_key.objectid,
+				      extent_key.objectid + nodesize);
+				err |= CHUNK_TYPE_MISMATCH;
+			}
+		}
+next:
+		ret = btrfs_next_item(extent_root, &path);
+		if (ret)
+			break;
+	}
+
+out:
+	btrfs_release_path(&path);
+
+	if (total != used) {
+		error("Block group[%llu %llu] used(%llu) but extent items used(%llu)",
+		      bg_key.objectid, bg_key.offset, used, total);
+		err |= ACCOUNTING_MISMATCH;
+	}
+	return err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



