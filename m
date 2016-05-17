Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbcEQJjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:10 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 14/16] btrfs-progs: fsck: Introduce function to speed up fs tree check
Date: Tue, 17 May 2016 17:38:48 +0800
Message-Id: <1463477930-3925-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function should_check() to reduced duplicated tree block check
for fs/subvolume tree.

The idea is, we only check the fs/subvolue tree block if we have the
highest referencer rootid, according to extent tree.

In that case, we can skip a lot of fs/subvolume tree block check if
there are a lot of snapshots.

Although we will do a lot of extent tree search for it.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 7735ff3..c12d9c9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9628,6 +9628,96 @@ next:
 	return err;
 }
 
+/*
+ * Helper function for later fs/subvol tree check.
+ * To determine if a tree block should be checked.
+ * This function will ensure only the directly referencer with lowest
+ * rootid to check a fs/subvolume tree block.
+ *
+ * Backref check at extent tree would detect error like missing subvolume
+ * tree, so we can do aggressive judgement to reduce duplicated check.
+ */
+static int should_check(struct btrfs_root *root, struct extent_buffer *eb)
+{
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *leaf;
+	int slot;
+	struct btrfs_extent_item *ei;
+	unsigned long ptr;
+	unsigned long end;
+	int type;
+	u32 item_size;
+	u64 offset;
+	struct btrfs_extent_inline_ref *iref;
+	int ret;
+
+	btrfs_init_path(&path);
+	key.objectid = btrfs_header_bytenr(eb);
+	key.type = BTRFS_METADATA_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	/*
+	 * Any failure in backref resolving means we can't determine
+	 * who the tree block belongs to.
+	 * So in that case, we need to check that tree block
+	 */
+	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto need_check;
+
+	ret = btrfs_previous_extent_item(extent_root, &path,
+					 btrfs_header_bytenr(eb));
+	if (ret)
+		goto need_check;
+
+	leaf = path.nodes[0];
+	slot = path.slots[0];
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+
+	if (key.type == BTRFS_METADATA_ITEM_KEY) {
+		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	} else {
+		struct btrfs_tree_block_info *info;
+
+		info = (struct btrfs_tree_block_info *)(ei + 1);
+		iref = (struct btrfs_extent_inline_ref *)(info + 1);
+	}
+
+	item_size = btrfs_item_size_nr(leaf, slot);
+	ptr = (unsigned long)iref;
+	end = (unsigned long)ei + item_size;
+	while (ptr < end) {
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		type = btrfs_extent_inline_ref_type(leaf, iref);
+		offset = btrfs_extent_inline_ref_offset(leaf, iref);
+
+		/*
+		 * We only check the tree block if current root is
+		 * the lowest referencer of it.
+		 */
+		if (type == BTRFS_TREE_BLOCK_REF_KEY &&
+		    offset < root->objectid) {
+			btrfs_release_path(&path);
+			return 0;
+		}
+
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+	/*
+	 * Normally we should also check keyed tree block ref,
+	 * but that may be very time consuming.
+	 * Inlined ref should already make us skip a lot of refs now.
+	 * So skip search keyed tree block ref.
+	 */
+
+need_check:
+	btrfs_release_path(&path);
+	return 1;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



