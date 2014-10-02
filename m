Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36083 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbaJBTLW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 15:11:22 -0400
Received: from pps.filterd (m0004348 [127.0.0.1])
	by m0004348.ppops.net (8.14.5/8.14.5) with SMTP id s92JAEiX027695
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Oct 2014 12:11:21 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by m0004348.ppops.net with ESMTP id 1ps7mtgkbt-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 12:11:21 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: check blocks when checking fs roots
Date: Thu, 2 Oct 2014 15:11:13 -0400
Message-ID: <1412277073-9559-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If check block fails during the extent tree checks we could evict the extent
buffer from cache, so the next time we go to read it for the fs_tree checks we
could miss the fact that its bogus and blow up in strange and interesting ways.
Fix this by running the leaf/node checks on all blocks in the fs root so we know
we're looking at valid blocks.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 5b8417c..db779ae 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1376,6 +1376,8 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 
 		next = btrfs_find_tree_block(root, bytenr, blocksize);
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
+			enum btrfs_tree_block_status status;
+
 			free_extent_buffer(next);
 			reada_walk_down(root, cur, path->slots[*level]);
 			next = read_tree_block(root, bytenr, blocksize,
@@ -1384,6 +1386,16 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 				err = -EIO;
 				goto out;
 			}
+
+			if (btrfs_is_leaf(next))
+				status = btrfs_check_leaf(root, NULL, next);
+			else
+				status = btrfs_check_node(root, NULL, next);
+			if (status != BTRFS_TREE_BLOCK_CLEAN) {
+				free_extent_buffer(next);
+				err = -EIO;
+				goto out;
+			}
 		}
 
 		*level = *level - 1;
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

