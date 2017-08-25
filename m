Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38016 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752938AbdHYNNK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 09:13:10 -0400
Received: by mail-qt0-f195.google.com with SMTP id p13so1932085qtp.5
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 06:13:10 -0700 (PDT)
From: josef@toxicpanda.com
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] btrfs-progs: print the csum length in debug-tree
Date: Fri, 25 Aug 2017 09:13:08 -0400
Message-Id: <1503666788-13122-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

While looking at a log of a corrupted fs I needed to verify we were
missing csums for a given range.  Make this easier by printing out how
many bytes a csum extent item represents when using btrfs_debug_tree.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 print-tree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 5927ed3..a124c96 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1103,9 +1103,15 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 		case BTRFS_CSUM_ITEM_KEY:
 			printf("\t\tcsum item\n");
 			break;
-		case BTRFS_EXTENT_CSUM_KEY:
-			printf("\t\textent csum item\n");
+		case BTRFS_EXTENT_CSUM_KEY: {
+			u16 csum_size =
+				btrfs_super_csum_size(root->fs_info->super_copy);
+			u32 size = (item_size / csum_size) *
+				root->fs_info->sectorsize;
+			printf("\t\textent csum item bytes %lu\n",
+			       (unsigned long)size);
 			break;
+			}
 		case BTRFS_EXTENT_DATA_KEY:
 			print_file_extent_item(eb, item, i, ptr);
 			break;
-- 
2.7.4

