Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55718 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751308AbdJIBvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Oct 2017 21:51:22 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v4 2/5] btrfs: tree-checker: Enhance btrfs_check_node output
Date: Mon,  9 Oct 2017 01:51:03 +0000
Message-Id: <20171009015106.9711-3-quwenruo.btrfs@gmx.com>
In-Reply-To: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
References: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use inline function to replace macro since we don't need
stringification.
(Macro still exist until all caller get updated)

And add more info about the error, and replace EIO with EUCLEAN.

For nr_items error, report if it's too large or too small, and output
valid value range.

For node block pointer, added a new alignment checker.

For key order, also output the next key to make the problem more
obvious.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/tree-checker.c | 70 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 63307e8426a6..b4ced8d3ce2a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -38,6 +38,48 @@
 		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
 		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
 
+/*
+ * Error message should follow the format below:
+ * corrupt <type>: <identifier>, <reason>[, <bad_value>]
+ *
+ * @type:	Either leaf or node
+ * @identifier:	The necessary info to locate the leaf/node.
+ * 		It's recommened to decode key.objecitd/offset if it's
+ * 		meaningful.
+ * @reason:	What's wrong
+ * @bad_value:	Optional, it's recommened to output bad value and its
+ *		expected value (range).
+ *
+ * Since comma is used to separate the components, only SPACE is allowed
+ * inside each component.
+ */
+
+/*
+ * Append the generic "corrupt leaf/node root=%llu block=%llu slot=%d: " to
+ * @fmt.
+ * Allowing user to customize their output.
+ */
+__printf(4, 5)
+static void generic_err(const struct btrfs_root *root,
+			const struct extent_buffer *eb,
+			int slot, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	btrfs_crit(root->fs_info,
+		"corrupt %s: root=%llu block=%llu slot=%d, %pV",
+		btrfs_header_level(eb) == 0 ? "leaf" : "node",
+		root->objectid, btrfs_header_bytenr(eb), slot,
+		&vaf);
+	va_end(args);
+}
+
 static int check_extent_data_item(struct btrfs_root *root,
 				  struct extent_buffer *leaf,
 				  struct btrfs_key *key, int slot)
@@ -283,9 +325,11 @@ int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
 
 	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root->fs_info)) {
 		btrfs_crit(root->fs_info,
-			   "corrupt node: block %llu root %llu nritems %lu",
-			   node->start, root->objectid, nr);
-		return -EIO;
+			   "corrupt node: root=%llu block=%llu, nritems too %s, have %lu expect range [1,%u]",
+			   root->objectid, node->start,
+			   nr == 0 ? "small" : "large", nr,
+			   BTRFS_NODEPTRS_PER_BLOCK(root->fs_info));
+		return -EUCLEAN;
 	}
 
 	for (slot = 0; slot < nr - 1; slot++) {
@@ -294,14 +338,26 @@ int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
 		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
 
 		if (!bytenr) {
-			CORRUPT("invalid item slot", node, root, slot);
-			ret = -EIO;
+			generic_err(root, node, slot,
+				"invalid NULL node pointer");
+			ret = -EUCLEAN;
+			goto out;
+		}
+		if (!IS_ALIGNED(bytenr, root->fs_info->sectorsize)) {
+			generic_err(root, node, slot,
+				"unaligned pointer, have %llu should be aligned to %u",
+				bytenr, root->fs_info->sectorsize);
+			ret = -EUCLEAN;
 			goto out;
 		}
 
 		if (btrfs_comp_cpu_keys(&key, &next_key) >= 0) {
-			CORRUPT("bad key order", node, root, slot);
-			ret = -EIO;
+			generic_err(root, node, slot,
+				"bad key order, current key (%llu %u %llu) next key (%llu %u %llu)",
+				key.objectid, key.type, key.offset,
+				next_key.objectid, next_key.type,
+				next_key.offset);
+			ret = -EUCLEAN;
 			goto out;
 		}
 	}
-- 
2.14.2

