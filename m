Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60821 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750783AbdCNFf2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 01:35:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 1/2] btrfs-progs: dump-tree: Fix duplicated output when using -t option
Date: Tue, 14 Mar 2017 13:35:17 +0800
Message-ID: <20170314053518.28812-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using -t option to output trees not in root tree (chunk/root/log
root), then we output the tree twice.

Fix it

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 cmds-inspect-dump-tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 6c6c0e5c..2c6bec7f 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -371,21 +371,21 @@ again:
 	if (tree_id && tree_id == BTRFS_ROOT_TREE_OBJECTID) {
 		if (!info->tree_root->node) {
 			error("cannot print root tree, invalid pointer");
-			goto no_node;
+			goto close_root;
 		}
 		printf("root tree\n");
 		btrfs_print_tree(info->tree_root, info->tree_root->node, 1);
-		goto no_node;
+		goto close_root;
 	}
 
 	if (tree_id && tree_id == BTRFS_CHUNK_TREE_OBJECTID) {
 		if (!info->chunk_root->node) {
 			error("cannot print chunk tree, invalid pointer");
-			goto no_node;
+			goto close_root;
 		}
 		printf("chunk tree\n");
 		btrfs_print_tree(info->chunk_root, info->chunk_root->node, 1);
-		goto no_node;
+		goto close_root;
 	}
 
 	key.offset = 0;
-- 
2.12.0



