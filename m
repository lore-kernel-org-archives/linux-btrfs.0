Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbcEQJjG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:06 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 13/16] btrfs-progs: fsck: Introduce hub function for later fsck
Date: Tue, 17 May 2016 17:38:47 +0800
Message-Id: <1463477930-3925-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a hub function, check_items() to check all known/valuable
items and update related accounting like total_bytes and csum_bytes.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 8070eb9..7735ff3 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9547,6 +9547,87 @@ out:
 	return err;
 }
 
+/*
+ * Hub function to check known items and update related accounting info
+ */
+static int check_leaf_items(struct btrfs_root *root, struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_key key;
+	int slot = 0;
+	int type;
+	struct btrfs_extent_data_ref *dref;
+	int ret;
+	int err = 0;
+
+next:
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	type = btrfs_key_type(&key);
+
+	switch (type) {
+	case BTRFS_EXTENT_DATA_KEY:
+		ret = check_extent_data_item(root, eb, slot);
+		err |= ret;
+		break;
+	case BTRFS_BLOCK_GROUP_ITEM_KEY:
+		ret = check_block_group_item(fs_info, eb, slot);
+		err |= ret;
+		break;
+	case BTRFS_DEV_ITEM_KEY:
+		ret = check_dev_item(fs_info, eb, slot);
+		err |= ret;
+		break;
+	case BTRFS_CHUNK_ITEM_KEY:
+		ret = check_chunk_item(fs_info, eb, slot);
+		err |= ret;
+		break;
+	case BTRFS_DEV_EXTENT_KEY:
+		ret = check_dev_extent_item(fs_info, eb, slot);
+		err |= ret;
+		break;
+	case BTRFS_EXTENT_ITEM_KEY:
+	case BTRFS_METADATA_ITEM_KEY:
+		ret = check_extent_item(fs_info, eb, slot);
+		err |= ret;
+		break;
+	case BTRFS_EXTENT_CSUM_KEY:
+		total_csum_bytes += btrfs_item_size_nr(eb, slot);
+		break;
+	case BTRFS_TREE_BLOCK_REF_KEY:
+		ret = check_tree_block_backref(fs_info, key.offset,
+					       key.objectid, -1);
+		err |= ret;
+		break;
+	case BTRFS_EXTENT_DATA_REF_KEY:
+		dref = btrfs_item_ptr(eb, slot, struct btrfs_extent_data_ref);
+		ret = check_extent_data_backref(fs_info,
+				btrfs_extent_data_ref_root(eb, dref),
+				btrfs_extent_data_ref_objectid(eb, dref),
+				btrfs_extent_data_ref_offset(eb, dref),
+				key.objectid, 0,
+				btrfs_extent_data_ref_count(eb, dref));
+		err |= ret;
+		break;
+	case BTRFS_SHARED_BLOCK_REF_KEY:
+		ret = check_shared_block_backref(fs_info, key.offset,
+						 key.objectid, -1);
+		err |= ret;
+		break;
+	case BTRFS_SHARED_DATA_REF_KEY:
+		ret = check_shared_data_backref(fs_info, key.offset,
+						key.objectid);
+		err |= ret;
+		break;
+	default:
+		break;
+	}
+
+	if (++slot < btrfs_header_nritems(eb))
+		goto next;
+
+	return err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



