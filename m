Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57071 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239AbbBDHTt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:19:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147IEb6020227
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/7] btrfs-progs: Allow btrfs_read_fs_root() to re-read the tree node.
Date: Wed, 4 Feb 2015 15:16:47 +0800
Message-ID: <1423034213-14018-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this patch, btrfs_read_fs_root() will try to re-read the tree node
if it's not up to date.

This will help for the tree block csum resetting function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 51 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index cb18002..747ef15 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -713,20 +713,47 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *root;
 	struct rb_node *node;
 	int ret;
+	int found = 0;
 	u64 objectid = location->objectid;
 
-	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
-		return fs_info->tree_root;
-	if (location->objectid == BTRFS_EXTENT_TREE_OBJECTID)
-		return fs_info->extent_root;
-	if (location->objectid == BTRFS_CHUNK_TREE_OBJECTID)
-		return fs_info->chunk_root;
-	if (location->objectid == BTRFS_DEV_TREE_OBJECTID)
-		return fs_info->dev_root;
-	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
-		return fs_info->csum_root;
-	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
-		return fs_info->quota_root;
+	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID) {
+		root = fs_info->tree_root;
+		found = 1;
+	}
+	if (location->objectid == BTRFS_EXTENT_TREE_OBJECTID) {
+		root = fs_info->extent_root;
+		found = 1;
+	}
+	if (location->objectid == BTRFS_CHUNK_TREE_OBJECTID) {
+		root = fs_info->chunk_root;
+		found = 1;
+	}
+	if (location->objectid == BTRFS_DEV_TREE_OBJECTID) {
+		root = fs_info->dev_root;
+		found = 1;
+	}
+	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID) {
+		root = fs_info->csum_root;
+		found = 1;
+	}
+	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID) {
+		root = fs_info->quota_root;
+		found = 1;
+	}
+	/*
+	 * The specified root has corruption. We should try to reread
+	 * it since its treeblock csum may be reseted.
+	 */
+	if (found && !extent_buffer_uptodate(root->node)) {
+		u64 bytenr = btrfs_root_bytenr(&root->root_item);
+
+		root->node = read_tree_block(root, bytenr, root->nodesize, 0);
+		if (!extent_buffer_uptodate(root->node)) {
+			if (IS_ERR(root->node))
+				return ERR_PTR(PTR_ERR(root->node));
+			return ERR_PTR(-EIO);
+		}
+	}
 
 	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	       location->offset != (u64)-1);
-- 
2.2.2

