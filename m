Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:42083 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754055AbeASFiB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:38:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 13/16] btrfs-progs: check: Move check_child_node to check/common.c
Date: Fri, 19 Jan 2018 13:37:28 +0800
Message-Id: <20180119053731.10795-14-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 check/common.h |  2 ++
 check/main.c   | 49 -------------------------------------------------
 3 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/check/common.c b/check/common.c
index 1ea9f506713a..4cdc46b0ba7c 100644
--- a/check/common.c
+++ b/check/common.c
@@ -275,3 +275,52 @@ void reada_walk_down(struct btrfs_root *root, struct extent_buffer *node,
 		readahead_tree_block(fs_info, bytenr, ptr_gen);
 	}
 }
+
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
+int check_child_node(struct extent_buffer *parent, int slot,
+		     struct extent_buffer *child)
+{
+	struct btrfs_key parent_key;
+	struct btrfs_key child_key;
+	int ret = 0;
+
+	btrfs_node_key_to_cpu(parent, &parent_key, slot);
+	if (btrfs_header_level(child) == 0)
+		btrfs_item_key_to_cpu(child, &child_key, 0);
+	else
+		btrfs_node_key_to_cpu(child, &child_key, 0);
+
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
diff --git a/check/common.h b/check/common.h
index 34b2f8a9cd87..d200a0c90e38 100644
--- a/check/common.h
+++ b/check/common.h
@@ -93,5 +93,7 @@ int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
 void check_dev_size_alignment(u64 devid, u64 total_bytes, u32 sectorsize);
 void reada_walk_down(struct btrfs_root *root, struct extent_buffer *node,
 		     int slot);
+int check_child_node(struct extent_buffer *parent, int slot,
+		     struct extent_buffer *child);
 
 #endif
diff --git a/check/main.c b/check/main.c
index aa7098a0be96..af4e54857fbf 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1667,55 +1667,6 @@ out:
 	return ret;
 }
 
-/*
- * Check the child node/leaf by the following condition:
- * 1. the first item key of the node/leaf should be the same with the one
- *    in parent.
- * 2. block in parent node should match the child node/leaf.
- * 3. generation of parent node and child's header should be consistent.
- *
- * Or the child node/leaf pointed by the key in parent is not valid.
- *
- * We hope to check leaf owner too, but since subvol may share leaves,
- * which makes leaf owner check not so strong, key check should be
- * sufficient enough for that case.
- */
-static int check_child_node(struct extent_buffer *parent, int slot,
-			    struct extent_buffer *child)
-{
-	struct btrfs_key parent_key;
-	struct btrfs_key child_key;
-	int ret = 0;
-
-	btrfs_node_key_to_cpu(parent, &parent_key, slot);
-	if (btrfs_header_level(child) == 0)
-		btrfs_item_key_to_cpu(child, &child_key, 0);
-	else
-		btrfs_node_key_to_cpu(child, &child_key, 0);
-
-	if (memcmp(&parent_key, &child_key, sizeof(parent_key))) {
-		ret = -EINVAL;
-		fprintf(stderr,
-			"Wrong key of child node/leaf, wanted: (%llu, %u, %llu), have: (%llu, %u, %llu)\n",
-			parent_key.objectid, parent_key.type, parent_key.offset,
-			child_key.objectid, child_key.type, child_key.offset);
-	}
-	if (btrfs_header_bytenr(child) != btrfs_node_blockptr(parent, slot)) {
-		ret = -EINVAL;
-		fprintf(stderr, "Wrong block of child node/leaf, wanted: %llu, have: %llu\n",
-			btrfs_node_blockptr(parent, slot),
-			btrfs_header_bytenr(child));
-	}
-	if (btrfs_node_ptr_generation(parent, slot) !=
-	    btrfs_header_generation(child)) {
-		ret = -EINVAL;
-		fprintf(stderr, "Wrong generation of child node/leaf, wanted: %llu, have: %llu\n",
-			btrfs_header_generation(child),
-			btrfs_node_ptr_generation(parent, slot));
-	}
-	return ret;
-}
-
 /*
  * for a tree node or leaf, if it's shared, indeed we don't need to iterate it
  * in every fs or file tree check. Here we find its all root ids, and only check
-- 
2.15.1

