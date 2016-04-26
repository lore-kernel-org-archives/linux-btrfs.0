Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbcDZDtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 23:49:39 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 06/16] btrfs-progs: fsck: Introduce function to check referencer for data backref
Date: Tue, 26 Apr 2016 11:48:53 +0800
Message-Id: <1461642543-4621-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce new function check_extent_data_backref() to search referencer
for a given data backref.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 1d1b198..8f971b9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8873,6 +8873,102 @@ out:
 	return 0;
 }
 
+/*
+ * Check referencer for normal(inlined) data ref
+ * If len == 0, it will be resolved by searching in extent tree
+ */
+static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
+				     u64 root_id, u64 objectid, u64 offset,
+				     u64 bytenr, u64 len)
+{
+	struct btrfs_root *root;
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	int slot;
+	int found_referencer = 0;
+	int ret = 0;
+
+	if (!len) {
+		key.objectid = bytenr;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		btrfs_init_path(&path);
+		ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+		if (ret < 0)
+			goto out;
+		ret = btrfs_previous_extent_item(extent_root, &path, bytenr);
+		if (ret)
+			goto out;
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.objectid != bytenr ||
+		    key.type != BTRFS_EXTENT_ITEM_KEY)
+			goto out;
+		len = key.offset;
+		btrfs_release_path(&path);
+	}
+	key.objectid = root_id;
+	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+	key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(root))
+		goto out;
+
+	btrfs_init_path(&path);
+	key.objectid = objectid;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	/* 
+	 * It can be nasty as data backref offset is
+	 * file offset - file extent offset, which is smaller or
+	 * equal to original backref offset.
+	 * The only special case is overflow.
+	 * So we need to special judgement and do further search
+	 */
+	key.offset = offset & (1ULL << 63) ? 0 : offset;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	/* Search afterwards to get correct one */
+	while (1) {
+		leaf = path.nodes[0];
+		slot = path.slots[0];
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
+			break;
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		/*
+		 * Except normal disk bytenr and disk num bytes, we still
+		 * need to do extra check on dbackref offset as
+		 * dbackref offset = file_offset - file_extent_offset
+		 */
+		if (btrfs_file_extent_disk_bytenr(leaf, fi) == bytenr &&
+		    btrfs_file_extent_disk_num_bytes(leaf, fi) == len &&
+		    (u64)(key.offset - btrfs_file_extent_offset(leaf, fi)) ==
+		    offset) {
+			found_referencer = 1;
+			break;
+		}
+		ret = btrfs_next_item(root, &path);
+		if (ret)
+			break;
+	}
+out:
+	btrfs_release_path(&path);
+	if (!found_referencer) {
+		error("Extent[%llu, %llu] lost referencer(root: %llu, owner: %llu, offset: %llu)",
+		      bytenr, len, root_id, objectid, offset);
+		return -MISSING_REFERENCER;
+	}
+	return 0;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.0



