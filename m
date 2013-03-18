Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52256 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3CRT41 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 15:56:27 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 11C5D9A03DD
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 13:56:27 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id dSTqLmSmGmAbIEYw (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 13:56:26 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make btrfs-image copy the tree logs if they exist
Date: Mon, 18 Mar 2013 16:03:44 -0400
Message-ID: <1363637024-6512-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs-image doesn't copy the tree logs, which doesn't help me when
we're trying to debug log replay bugs.  Since we don't have entries in the
extent root for the blocks we have to walk down all of the trees in order to
copy them.  With this patch I can image a file system with a tree log and it
works fine.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index ee9ab56..ad028de 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -532,6 +532,84 @@ static int is_tree_block(struct btrfs_root *extent_root,
 }
 #endif
 
+static int copy_log_blocks(struct btrfs_root *root, struct extent_buffer *eb,
+			   struct metadump_struct *metadump,
+			   int log_root_tree)
+{
+	struct extent_buffer *tmp;
+	struct btrfs_root_item *ri;
+	struct btrfs_key key;
+	u64 bytenr;
+	int level;
+	int nritems = 0;
+	int i = 0;
+	int ret;
+
+	ret = add_metadata(btrfs_header_bytenr(eb), root->leafsize, metadump);
+	if (ret) {
+		fprintf(stderr, "Error adding metadata block\n");
+		return ret;
+	}
+
+	if (btrfs_header_level(eb) == 0 && !log_root_tree)
+		return 0;
+
+	level = btrfs_header_level(eb);
+	nritems = btrfs_header_nritems(eb);
+	for (i = 0; i < nritems; i++) {
+		if (level == 0) {
+			btrfs_item_key_to_cpu(eb, &key, i);
+			if (key.type != BTRFS_ROOT_ITEM_KEY)
+				continue;
+			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
+			bytenr = btrfs_disk_root_bytenr(eb, ri);
+			tmp = read_tree_block(root, bytenr, root->leafsize, 0);
+			if (!tmp) {
+				fprintf(stderr, "Error reading log root "
+					"block\n");
+				return -EIO;
+			}
+			ret = copy_log_blocks(root, tmp, metadump, 0);
+			free_extent_buffer(tmp);
+			if (ret)
+				return ret;
+		} else {
+			bytenr = btrfs_node_blockptr(eb, i);
+			tmp = read_tree_block(root, bytenr, root->leafsize, 0);
+			if (!tmp) {
+				fprintf(stderr, "Error reading log block\n");
+				return -EIO;
+			}
+			ret = copy_log_blocks(root, tmp, metadump,
+					      log_root_tree);
+			free_extent_buffer(tmp);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int copy_log_trees(struct btrfs_root *root,
+			  struct metadump_struct *metadump,
+			  struct btrfs_path *path)
+{
+	u64 blocknr = btrfs_super_log_root(&root->fs_info->super_copy);
+
+	if (blocknr == 0)
+		return 0;
+
+	if (!root->fs_info->log_root_tree ||
+	    !root->fs_info->log_root_tree->node) {
+		fprintf(stderr, "Error copying tree log, it wasn't setup\n");
+		return -EIO;
+	}
+
+	return copy_log_blocks(root, root->fs_info->log_root_tree->node,
+			       metadump, 1);
+}
+
 static int create_metadump(const char *input, FILE *out, int num_threads,
 			   int compress_level)
 {
@@ -662,6 +740,9 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 		bytenr += num_bytes;
 	}
 
+	ret = copy_log_trees(root, &metadump, path);
+	if (ret)
+		err = ret;
 out:
 	ret = flush_pending(&metadump, 1);
 	if (ret) {
-- 
1.7.7.6

