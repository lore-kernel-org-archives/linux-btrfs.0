Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab2FUMJG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 08:09:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5LC93V6017749
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2012 20:09:03 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix unresolved refs bug of btrfsck
Date: Thu, 21 Jun 2012 20:17:28 +0800
Message-Id: <1340281048-4133-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ btrfs sub snap /mnt/ /mnt/s1
$ btrfs sub snap /mnt/ /mnt/s2
$ btrfsck disk

then we'll get several "unresolved ref" info, which is not expected.

The cause is that when we make a snapshot, we won't insert root ref/backref
for the snapshot, and btrfsck will report errors.

This is a btrfsck bug, since our metadata is all right, so we make such a rule:
When the src has the ref/backref on A, src's snapshot also has the ref/backref
on A.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 btrfsck.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 7aac736..3a2b4ec 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1439,6 +1439,76 @@ static int merge_root_recs(struct btrfs_root *root,
 	return 0;
 }
 
+/*
+ * 1: a snapshot,
+ * 0: not.
+ */
+static int check_snapshot(struct btrfs_root *root, u64 ref_root, u64 *root_ret)
+{
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *leaf;
+	int ret = 0;
+
+	*root_ret = 0;
+
+	btrfs_init_path(&path);
+
+	key.offset = 0;
+	key.objectid = ref_root;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
+	BUG_ON(ret < 0);
+
+	leaf = path.nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
+	if (key.type != BTRFS_ROOT_ITEM_KEY) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (key.offset == 0) {
+		ret = 0;
+		goto out;
+	}
+
+	/* key.offset is non-zero, a snapshot */
+	path.slots[0]++;
+	while (1) {
+		leaf = path.nodes[0];
+		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(tree_root, &path);
+			if (ret != 0)
+				break;
+			leaf = path.nodes[0];
+		}
+		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
+		if (key.type == BTRFS_ROOT_BACKREF_KEY) {
+			*root_ret = key.offset;
+			break;
+		}
+		path.slots[0]++;
+	}
+
+out:
+	btrfs_release_path(tree_root, &path);
+	return ret;
+}
+
+static void update_backref(struct root_record *rec, struct root_backref *ref,
+			u64 ref_root)
+{
+	struct root_backref *backref;
+
+	list_for_each_entry(backref, &rec->backrefs, list) {
+		if (backref->ref_root == ref_root) {
+			ref->found_back_ref = backref->found_back_ref;
+			ref->found_forward_ref = backref->found_forward_ref;
+			break;
+		}
+	}
+}
+
 static int check_root_refs(struct btrfs_root *root,
 			   struct cache_tree *root_cache)
 {
@@ -1511,6 +1581,18 @@ static int check_root_refs(struct btrfs_root *root,
 				backref->errors |= REF_ERR_NO_DIR_ITEM;
 			if (!backref->found_dir_index)
 				backref->errors |= REF_ERR_NO_DIR_INDEX;
+			if (!backref->found_back_ref &&
+			    !backref->found_forward_ref) {
+				u64 ref_root_objectid = 0;
+				int is_snap = 0;
+
+				is_snap = check_snapshot(root,
+							 backref->ref_root,
+							 &ref_root_objectid);
+				if (is_snap && ref_root_objectid)
+					update_backref(rec, backref,
+						       ref_root_objectid);
+			}
 			if (!backref->found_back_ref)
 				backref->errors |= REF_ERR_NO_ROOT_BACKREF;
 			if (!backref->found_forward_ref)
-- 
1.6.5.2

