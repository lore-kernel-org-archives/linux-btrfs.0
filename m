From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix infinite loop in btrfs_extent_post_op
Date: Wed, 21 Jan 2009 19:51:58 +0800
Message-ID: <49770C5E.6030308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

btrfs_extent_post_op calls finish_current_insert and
del_pending_extents. They both may enter infinite loop.
finish_current_insert enters infinite loop if it only
finds some backrefs to update. The infinite loop in
del_pending_extents is due to a variable not properly
set. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-01-07 07:16:42.762364700 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-01-20 13:36:07.000000000 +0800
@@ -2159,7 +2159,8 @@ again:
 		ret = find_first_extent_bit(&info->extent_ins, search, &start,
 					    &end, EXTENT_WRITEBACK);
 		if (ret) {
-			if (skipped && all && !num_inserts) {
+			if (skipped && all && !num_inserts &&
+			    list_empty(&update_list)) {
 				skipped = 0;
 				search = 0;
 				continue;
@@ -2547,6 +2548,7 @@ again:
 		if (ret) {
 			if (all && skipped && !nr) {
 				search = 0;
+				skipped = 0;
 				continue;
 			}
 			mutex_unlock(&info->extent_ins_mutex);


