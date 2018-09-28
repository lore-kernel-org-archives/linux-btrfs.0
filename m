Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0559DC004D5
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E1321733
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4E1321733
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbeI1I0W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 04:26:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:58332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728499AbeI1I0W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 04:26:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6F19AD53
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 02:05:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/6] btrfs-progs: print-tree: Use bool for @follow
Date:   Fri, 28 Sep 2018 10:04:46 +0800
Message-Id: <20180928020446.21467-7-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928020446.21467-1-wqu@suse.com>
References: <20180928020446.21467-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just a minor cleanup to make the parameter easier to read.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-inspect-dump-tree.c | 16 ++++++++--------
 print-tree.c             |  2 +-
 print-tree.h             |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index d78fa14356de..08b6de55218f 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -378,20 +378,20 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		} else {
 			if (info->tree_root->node) {
 				printf("root tree\n");
-				btrfs_print_tree(info->tree_root->node, 1,
+				btrfs_print_tree(info->tree_root->node, true,
 						 traverse);
 			}
 
 			if (info->chunk_root->node) {
 				printf("chunk tree\n");
-				btrfs_print_tree(info->chunk_root->node, 1,
+				btrfs_print_tree(info->chunk_root->node, true,
 						 traverse);
 			}
 
 			if (info->log_root_tree) {
 				printf("log root tree\n");
-				btrfs_print_tree(info->log_root_tree->node, 1,
-						 traverse);
+				btrfs_print_tree(info->log_root_tree->node,
+						 true, traverse);
 			}
 		}
 	}
@@ -411,7 +411,7 @@ again:
 			goto close_root;
 		}
 		printf("root tree\n");
-		btrfs_print_tree(info->tree_root->node, 1, traverse);
+		btrfs_print_tree(info->tree_root->node, true, traverse);
 		goto close_root;
 	}
 
@@ -421,7 +421,7 @@ again:
 			goto close_root;
 		}
 		printf("chunk tree\n");
-		btrfs_print_tree(info->chunk_root->node, 1, traverse);
+		btrfs_print_tree(info->chunk_root->node, true, traverse);
 		goto close_root;
 	}
 
@@ -431,7 +431,7 @@ again:
 			goto close_root;
 		}
 		printf("log root tree\n");
-		btrfs_print_tree(info->log_root_tree->node, 1, traverse);
+		btrfs_print_tree(info->log_root_tree->node, true, traverse);
 		goto close_root;
 	}
 
@@ -577,7 +577,7 @@ again:
 					       btrfs_header_level(buf));
 				} else {
 					printf(" \n");
-					btrfs_print_tree(buf, 1, traverse);
+					btrfs_print_tree(buf, true, traverse);
 				}
 			}
 			free_extent_buffer(buf);
diff --git a/print-tree.c b/print-tree.c
index 118fe9531d7e..ace8ca240f21 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1488,7 +1488,7 @@ static void dfs_print_children(struct extent_buffer *root_eb)
 	}
 }
 
-void btrfs_print_tree(struct extent_buffer *eb, int follow, int traverse)
+void btrfs_print_tree(struct extent_buffer *eb, bool follow, int traverse)
 {
 	u32 i;
 	u32 nr;
diff --git a/print-tree.h b/print-tree.h
index 1d8c8b09b0c5..b7061ded062e 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -25,14 +25,14 @@ void btrfs_print_leaf(struct extent_buffer *l);
  * Print a tree block (apply to both node and leaf).
  *
  * @t:		Tree block
- * @follow:	Set non-zero to print all its children.
+ * @follow:	Set true to print all its children.
  * @traverse:	The traverse order. Support DFS and BFS.
  *		Will fallback to DFS for unknown order.
  */
 #define BTRFS_PRINT_TREE_DFS		0
 #define BTRFS_PRINT_TREE_BFS		1
 #define BTRFS_PRINT_TREE_DEFAULT	BTRFS_PRINT_TREE_DFS
-void btrfs_print_tree(struct extent_buffer *t, int follow, int traverse);
+void btrfs_print_tree(struct extent_buffer *t, bool follow, int traverse);
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
 void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
-- 
2.19.0

