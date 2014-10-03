Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63493 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbaJCOuS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 10:50:18 -0400
Received: from pps.filterd (m0004346 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s93EmchU005776
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Oct 2014 07:50:18 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1prpa2uq1t-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Oct 2014 07:50:18 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: check blocks when checking fs roots V2
Date: Fri, 3 Oct 2014 10:50:15 -0400
Message-ID: <1412347815-5304-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Usually if we find a bad block during the extent tree stuff we will error out,
but if the bad block is in an fs tree and doens't have extents in it then fsck
may still pass even though the block was complete garbage.  So add the check
block logic to the fs root checking so we actually error out of fsck if there is
a bad block.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: do it on all blocks, not just ones that aren't in cache.

 cmds-check.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index b2c698f..cd3713b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1316,6 +1316,7 @@ static void reada_walk_down(struct btrfs_root *root,
 static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			  struct walk_control *wc, int *level)
 {
+	enum btrfs_tree_block_status status;
 	u64 bytenr;
 	u64 ptr_gen;
 	struct extent_buffer *next;
@@ -1376,6 +1377,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 
 		next = btrfs_find_tree_block(root, bytenr, blocksize);
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
+
 			free_extent_buffer(next);
 			reada_walk_down(root, cur, path->slots[*level]);
 			next = read_tree_block(root, bytenr, blocksize,
@@ -1386,6 +1388,16 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			}
 		}
 
+		if (btrfs_is_leaf(next))
+			status = btrfs_check_leaf(root, NULL, next);
+		else
+			status = btrfs_check_node(root, NULL, next);
+		if (status != BTRFS_TREE_BLOCK_CLEAN) {
+			free_extent_buffer(next);
+			err = -EIO;
+			goto out;
+		}
+
 		*level = *level - 1;
 		free_extent_buffer(path->nodes[*level]);
 		path->nodes[*level] = next;
@@ -2078,6 +2090,7 @@ static int check_fs_root(struct btrfs_root *root,
 	struct shared_node root_node;
 	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
+	enum btrfs_tree_block_status status;
 
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
 		rec = get_root_rec(root_cache, root->root_key.objectid);
@@ -2096,6 +2109,14 @@ static int check_fs_root(struct btrfs_root *root,
 	wc->active_node = level;
 	wc->root_level = level;
 
+	/* We may not have checked the root block, lets do that now */
+	if (btrfs_is_leaf(root->node))
+		status = btrfs_check_leaf(root, NULL, root->node);
+	else
+		status = btrfs_check_node(root, NULL, root->node);
+	if (status != BTRFS_TREE_BLOCK_CLEAN)
+		return -EIO;
+
 	if (btrfs_root_refs(root_item) > 0 ||
 	    btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		path.nodes[level] = root->node;
-- 
1.8.3.1

