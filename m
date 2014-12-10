Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:36437 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933303AbaLJVFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:41 -0500
Received: from mail-in-15-z2.arcor-online.net (mail-in-15-z2.arcor-online.net [151.189.8.32])
	by mx.arcor.de (Postfix) with ESMTP id 3B37B8767
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:40 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 04/18] btrfs-progs: btrfs-debug-tree: handle corruption more gracefully
Date: Wed, 10 Dec 2014 21:51:34 +0100
Message-Id: <1418244708-7087-5-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

This patch fixes the same thing in two different places. First,
the first of the two BUG() tests is just a special case of the
second one and can therefore be omitted. Second, instead of bailing
out with BUG(), just print a reasonable error message and check the
next child.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 btrfs-debug-tree.c |   22 ++++++++++++++++------
 print-tree.c       |   22 ++++++++++++++++------
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 4c1e835..d7c1155 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -73,13 +73,23 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 					     btrfs_node_blockptr(eb, i),
 					     size,
 					     btrfs_node_ptr_generation(eb, i));
-		if (btrfs_is_leaf(next) &&
-		    btrfs_header_level(eb) != 1)
-			BUG();
 		if (btrfs_header_level(next) !=
-			btrfs_header_level(eb) - 1)
-			BUG();
-		print_extents(root, next);
+		    btrfs_header_level(eb) - 1) {
+			fprintf(stderr, "EXTENT TREE CORRUPTION detected at %llu, "
+				"slot %d pointing at %llu.\n"
+				"\tExpected child level: %d, found %d\n"
+				"\tExpected tree/transid: %llu/%llu,"
+				" found %llu/%llu\n",
+				eb->start, i, next->start,
+				btrfs_header_level(eb) - 1,
+				btrfs_header_level(next),
+				(unsigned long long)btrfs_header_owner(eb),
+				(unsigned long long)btrfs_header_generation(eb),
+				(unsigned long long)btrfs_header_owner(next),
+				(unsigned long long)
+				btrfs_header_generation(next));
+		} else
+			print_extents(root, next);
 		free_extent_buffer(next);
 	}
 }
diff --git a/print-tree.c b/print-tree.c
index 70a7acc..6769e20 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1066,13 +1066,23 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 				(unsigned long long)btrfs_header_owner(eb));
 			continue;
 		}
-		if (btrfs_is_leaf(next) &&
-		    btrfs_header_level(eb) != 1)
-			BUG();
 		if (btrfs_header_level(next) !=
-			btrfs_header_level(eb) - 1)
-			BUG();
-		btrfs_print_tree(root, next, 1);
+		    btrfs_header_level(eb) - 1) {
+			fprintf(stderr, "TREE CORRUPTION detected at %llu, "
+				"slot %d pointing at %llu.\n"
+				"\tExpected child level: %d, found %d\n"
+				"\tExpected tree/transid: %llu/%llu,"
+				" found %llu/%llu\n",
+				eb->start, i, next->start,
+				btrfs_header_level(eb) - 1,
+				btrfs_header_level(next),
+				(unsigned long long)btrfs_header_owner(eb),
+				(unsigned long long)btrfs_header_generation(eb),
+				(unsigned long long)btrfs_header_owner(next),
+				(unsigned long long)
+				btrfs_header_generation(next));
+		} else
+			btrfs_print_tree(root, next, 1);
 		free_extent_buffer(next);
 	}
 }
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
