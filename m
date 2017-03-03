Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21999 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751907AbdCCHKx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 02:10:53 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs-progs: dump-tree: Also output log root tree
Date: Fri, 3 Mar 2017 12:13:45 +0800
Message-ID: <20170303041345.11760-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170303041345.11760-1-quwenruo@cn.fujitsu.com>
References: <20170303041345.11760-1-quwenruo@cn.fujitsu.com>
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
 cmds-inspect-dump-tree.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 2c6bec7f..eca91b5e 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -344,6 +344,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			printf("chunk tree: %llu level %d\n",
 			     (unsigned long long)info->chunk_root->node->start,
 			     btrfs_header_level(info->chunk_root->node));
+			printf("log root tree: %llu level %d\n",
+			     (unsigned long long)info->log_root_tree->node->start,
+			     btrfs_header_level(info->log_root_tree->node));
 		} else {
 			if (info->tree_root->node) {
 				printf("root tree\n");
@@ -356,6 +359,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
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
@@ -388,6 +397,17 @@ again:
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



