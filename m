Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45424 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753048AbaIZHgh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 03:36:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8Q7adnA024215
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Sep 2014 15:36:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Check the consistence between the parent node and child node/leaf.
Date: Fri, 26 Sep 2014 15:36:35 +0800
Message-ID: <1411716995-22537-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs-progs walk down the tree, it does not check whether the child
node/leaf is valid.
In fact, there is some corrupted image whose csum is all valid but
parent node points to a invalid leaf.

In my case, the parent node in fs tree point to a invalid leaf(gen 11),
whose generation(15) and first key(EXTENT_TREE ROOT_ITEM 0) is
completely invalid, and will cause BUG_ON in process_inode_item().

Unfortunately, we are unable to fix when it happens.
So we can only output meaningful error message and avoid the insane
node/leaf, which is still much better than the original BUG_ON().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index d479361..9471709 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1302,6 +1302,52 @@ static void reada_walk_down(struct btrfs_root *root,
 	}
 }
 
+/*
+ * Check the child node/leaf by the following condition:
+ * 1. the first item key of the node/leaf should be the same with the one
+ *    in parent.
+ * 2. block in parent node should match the child node/leaf.
+ * 3. generation of parent node and child's header should be consistent.
+ *
+ * Or the child node/leaf pointed by the key in parent is not valid.
+ *
+ * We hope to check leaf owner too, but since subvol may share leaves,
+ * which makes leaf owner check not so strong, key check should be
+ * sufficient enough for that case.
+ */
+static int check_child_node(struct btrfs_root *root,
+			    struct extent_buffer *parent, int slot,
+			    struct extent_buffer *child)
+{
+	struct btrfs_key parent_key;
+	struct btrfs_key child_key;
+	int ret = 0;
+
+	btrfs_item_key_to_cpu(parent, &parent_key, slot);
+	btrfs_item_key_to_cpu(child, &child_key, 0);
+	if (memcmp(&parent_key, &child_key, sizeof(parent_key))) {
+		ret = -EINVAL;
+		fprintf(stderr,
+			"Wrong key of child node/leaf, wanted: (%llu, %u, %llu), have: (%llu, %u, %llu)\n",
+			parent_key.objectid, parent_key.type, parent_key.offset,
+			child_key.objectid, child_key.type, child_key.offset);
+	}
+	if (btrfs_header_bytenr(child) != btrfs_node_blockptr(parent, slot)) {
+		ret = -EINVAL;
+		fprintf(stderr, "Wrong block of child node/leaf, wanted: %llu, have: %llu\n",
+			btrfs_node_blockptr(parent, slot),
+			btrfs_header_bytenr(child));
+	}
+	if (btrfs_node_ptr_generation(parent, slot) !=
+	    btrfs_header_generation(child)) {
+		ret = -EINVAL;
+		fprintf(stderr, "Wrong generation of child node/leaf, wanted: %llu, have: %llu\n",
+			btrfs_header_generation(child),
+			btrfs_node_ptr_generation(parent, slot));
+	}
+	return ret;
+}
+
 static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			  struct walk_control *wc, int *level)
 {
@@ -1375,6 +1421,11 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			}
 		}
 
+		ret = check_child_node(root, cur, path->slots[*level], next);
+		if (ret) {
+			err = ret;
+			goto out;
+		}
 		*level = *level - 1;
 		free_extent_buffer(path->nodes[*level]);
 		path->nodes[*level] = next;
-- 
2.1.1

