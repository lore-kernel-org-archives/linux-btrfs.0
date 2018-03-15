Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:43062 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbeCOEs0 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 15 Mar 2018 00:48:26 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: print-tree: Enhance warning on tree block level mismatch and error handling
Date: Thu, 15 Mar 2018 12:48:15 +0800
Message-Id: <20180315044815.18816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch enhance the tree block level mismatch by the following
methods:

1) Merge same warning branches into one
   We had two branches showing the same message, and their condition
   is also the same. Merge them

2) Only skip bad slot
   The old code skipped all the remaining slots, here we just skip one
   slot to output as many correct tree blocks as possible.

3) Enhance warning message
   Ouput the parent bytenr and expected and wrong level, so we don't
   need refer to the stdout to get which tree block is corrupted.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 45350fea0963..c1e7af65ce4b 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1389,19 +1389,16 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 				(unsigned long long)btrfs_header_owner(eb));
 			continue;
 		}
-		if (btrfs_is_leaf(next) && btrfs_header_level(eb) != 1) {
-			warning(
-	"eb corrupted: item %d eb level %d next level %d, skipping the rest",
-				i, btrfs_header_level(next),
-				btrfs_header_level(eb));
-			goto out;
-		}
 		if (btrfs_header_level(next) != btrfs_header_level(eb) - 1) {
 			warning(
-	"eb corrupted: item %d eb level %d next level %d, skipping the rest",
-				i, btrfs_header_level(next),
-				btrfs_header_level(eb));
-			goto out;
+	"eb corrupted: parent bytenr %llu slot %d level %d child bytenr %llu level has %d expect %d, skipping the slot",
+				btrfs_header_bytenr(eb), i,
+				btrfs_header_level(eb),
+				btrfs_header_bytenr(next),
+				btrfs_header_level(next),
+				btrfs_header_level(eb) - 1);
+			free_extent_buffer(next);
+			continue;
 		}
 		btrfs_print_tree(root, next, 1);
 		free_extent_buffer(next);
@@ -1409,6 +1406,5 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 
 	return;
 
-out:
 	free_extent_buffer(next);
 }
-- 
2.16.2

