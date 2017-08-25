Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35238 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932414AbdHYPLt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 11:11:49 -0400
Received: by mail-qt0-f194.google.com with SMTP id u11so84397qtu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 08:11:48 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH][v2] btrfs-progs: print the csum length in debug-tree
Date: Fri, 25 Aug 2017 11:11:46 -0400
Message-Id: <1503673906-14342-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

While looking at a log of a corrupted fs I needed to verify we were
missing csums for a given range.  Make this easier by printing out the
range of bytes a csum item covers.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
v1->v2:
- print the byte range instead of just the length

 print-tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 5927ed3..2aead6a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1103,9 +1103,16 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
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
+			printf("\t\textent csum item range %llu-%llu\n",
+			       (unsigned long long)disk_key.offset,
+			       (unsigned long long)disk_key.offset + size);
 			break;
+			}
 		case BTRFS_EXTENT_DATA_KEY:
 			print_file_extent_item(eb, item, i, ptr);
 			break;
-- 
2.7.4

