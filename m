Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41816 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaCJK4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 06:56:20 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH] Btrfs: fix a crash of clone with inline extents's split
Date: Mon, 10 Mar 2014 18:56:07 +0800
Message-Id: <1394448967-14128-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

xfstests's btrfs/035 triggers a BUG_ON, which we use to detect the split
of inline extents in __btrfs_drop_extents().

For inline extents, we cannot duplicate another EXTENT_DATA item, because
it breaks the rule of inline extents, that is, 'start offset' needs to be 0.

We have set limitations for the source inode's compressed inline extents,
because it needs to decompress and recompress.  Now the destination inode's
inline extents also need similar limitations.

With this, xfstests btrfs/035 doesn't run into panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c  | 15 ++++++++++++---
 fs/btrfs/ioctl.c | 10 ++++++----
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0165b86..2c34a04 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -798,7 +798,10 @@ next_slot:
 		 */
 		if (start > key.offset && end < extent_end) {
 			BUG_ON(del_nr > 0);
-			BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
+			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+				ret = -EINVAL;
+				break;
+			}
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.offset = start;
@@ -841,7 +844,10 @@ next_slot:
 		 *      | -------- extent -------- |
 		 */
 		if (start <= key.offset && end < extent_end) {
-			BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
+			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+				ret = -EINVAL;
+				break;
+			}
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.offset = end;
@@ -864,7 +870,10 @@ next_slot:
 		 */
 		if (start > key.offset && end >= extent_end) {
 			BUG_ON(del_nr > 0);
-			BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
+			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+				ret = -EINVAL;
+				break;
+			}
 
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							start - key.offset);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9a90445..49f03ab 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3090,8 +3090,9 @@ process_slot:
 							 new_key.offset + datal,
 							 1);
 				if (ret) {
-					btrfs_abort_transaction(trans, root,
-								ret);
+					if (ret != -EINVAL)
+						btrfs_abort_transaction(trans,
+								root, ret);
 					btrfs_end_transaction(trans, root);
 					goto out;
 				}
@@ -3175,8 +3176,9 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	 *   decompress into destination's address_space (the file offset
 	 *   may change, so source mapping won't do), then recompress (or
 	 *   otherwise reinsert) a subrange.
-	 * - allow ranges within the same file to be cloned (provided
-	 *   they don't overlap)?
+	 *
+	 * - split destination inode's inline extents.  The inline extents can
+	 *   be either compressed or non-compressed.
 	 */
 
 	/* the destination must be opened for writing */
-- 
1.8.2.1

