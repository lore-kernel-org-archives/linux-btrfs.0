Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60821 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750760AbdCNFfY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 01:35:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 2/2] btrfs-progs: dump-tree: Also output log root tree
Date: Tue, 14 Mar 2017 13:35:18 +0800
Message-ID: <20170314053518.28812-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170314053518.28812-1-quwenruo@cn.fujitsu.com>
References: <20170314053518.28812-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs-dump-tree, we output any existing log tree, however we don't
output the log root tree, which records all root items for log trees.

This makes it confusing for any one who want to know where the log tree
comes from.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Check if log_root_tree exists before printing it in root_only mode
---
 cmds-inspect-dump-tree.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 2c6bec7f..5a5ca536 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -344,6 +344,11 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			printf("chunk tree: %llu level %d\n",
 			     (unsigned long long)info->chunk_root->node->start,
 			     btrfs_header_level(info->chunk_root->node));
+			if (info->log_root_tree)
+				printf("log root tree: %llu level %d\n",
+				       info->log_root_tree->node->start,
+					btrfs_header_level(
+						info->log_root_tree->node));
 		} else {
 			if (info->tree_root->node) {
 				printf("root tree\n");
@@ -356,6 +361,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 				btrfs_print_tree(info->chunk_root,
 						 info->chunk_root->node, 1);
 			}
+
+			if (info->log_root_tree) {
+				printf("log root tree\n");
+				btrfs_print_tree(info->log_root_tree,
+						info->log_root_tree->node, 1);
+			}
 		}
 	}
 	tree_root_scan = info->tree_root;
@@ -388,6 +399,17 @@ again:
 		goto close_root;
 	}
 
+	if (tree_id && tree_id == BTRFS_TREE_LOG_OBJECTID) {
+		if (!info->log_root_tree) {
+			error("cannot print log root tree, invalid pointer");
+			goto close_root;
+		}
+		printf("log root tree\n");
+		btrfs_print_tree(info->log_root_tree, info->log_root_tree->node,
+				 1);
+		goto close_root;
+	}
+
 	key.offset = 0;
 	key.objectid = 0;
 	key.type = BTRFS_ROOT_ITEM_KEY;
-- 
2.12.0



