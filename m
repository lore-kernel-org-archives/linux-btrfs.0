Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19150 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751561AbbEKAr7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 20:47:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B0kUZe031699
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 08:46:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Cleanup logic of btrfs_read_tree_block().
Date: Mon, 11 May 2015 08:45:48 +0800
Message-ID: <1431305148-18953-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431305148-18953-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431305148-18953-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make the logic of btrfs_read_tree_block() more clean.
Now it will do as the following flow:
1) Iterate all copies of the tree block
   If one can pass all tests(csum, check tree block, transid), then
   return it.
2) If all above failed, use the copy with highest transid
   If that copy can pass checksum and tree block check, then ignore its
   transid error
3) If none passed above, print out error.

This provides the basis for later all tree block copies check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 73 +++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index c1cf146..c8302a8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -280,9 +280,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	struct extent_buffer *eb;
 	u64 best_transid = 0;
 	int mirror_num = 0;
-	int good_mirror = 0;
+	int best_mirror = -1;
 	int num_copies;
-	int ignore = 0;
 
 	eb = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!eb)
@@ -291,50 +290,54 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	if (btrfs_buffer_uptodate(eb, parent_transid))
 		return eb;
 
-	while (1) {
+	num_copies = btrfs_num_copies(&root->fs_info->mapping_tree, eb->start,
+				      eb->len);
+
+	/* Iterate all copies with restrict check */
+	for (mirror_num = 0; mirror_num < num_copies; mirror_num++) {
 		ret = read_whole_eb(root->fs_info, eb, mirror_num);
 		if (ret == 0 && csum_tree_block(root, eb, 1) == 0 &&
 		    check_tree_block(root, eb) == 0 &&
-		    verify_parent_transid(eb->tree, eb, parent_transid, ignore)
+		    verify_parent_transid(eb->tree, eb, parent_transid, 0)
 		    == 0) {
-			if (eb->flags & EXTENT_BAD_TRANSID &&
-			    list_empty(&eb->recow)) {
-				list_add_tail(&eb->recow,
-					      &root->fs_info->recow_ebs);
-				eb->refs++;
-			}
 			btrfs_set_buffer_uptodate(eb);
 			return eb;
 		}
-		if (ignore) {
-			if (check_tree_block(root, eb)) {
-				if (!root->fs_info->suppress_check_block_errors)
-					print_tree_block_error(root, eb,
-						check_tree_block(root, eb));
-			} else {
-				if (!root->fs_info->suppress_check_block_errors)
-					fprintf(stderr, "Csum didn't match\n");
-			}
-			ret = -EIO;
-			break;
-		}
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
-					      eb->start, eb->len);
-		if (num_copies == 1) {
-			ignore = 1;
-			continue;
-		}
-		if (btrfs_header_generation(eb) > best_transid && mirror_num) {
+		if (btrfs_header_generation(eb) > best_transid) {
 			best_transid = btrfs_header_generation(eb);
-			good_mirror = mirror_num;
+			best_mirror = mirror_num;
 		}
-		mirror_num++;
-		if (mirror_num > num_copies) {
-			mirror_num = good_mirror;
-			ignore = 1;
-			continue;
+	}
+	/* No valid eb found, use one with best transid or the last mirror */
+	if (best_mirror != -1)
+		mirror_num = best_mirror;
+	ret = read_whole_eb(root->fs_info, eb, mirror_num);
+	if (ret < 0)
+		goto out;
+
+	/* ignore transid error */
+	if (csum_tree_block(root, eb, 1) == 0 &&
+	    check_tree_block(root, eb) ==0 &&
+	    verify_parent_transid(eb->tree, eb, parent_transid, 1) == 0) {
+		if (eb->flags & EXTENT_BAD_TRANSID && list_empty(&eb->recow)) {
+			list_add_tail(&eb->recow, &root->fs_info->recow_ebs);
+			eb->refs++;
 		}
+		btrfs_set_buffer_uptodate(eb);
+		return eb;
+	}
+
+	/* print other errors */
+	if (check_tree_block(root, eb)) {
+		if (!root->fs_info->suppress_check_block_errors)
+			print_tree_block_error(root, eb,
+					check_tree_block(root, eb));
+	} else {
+		if (!root->fs_info->suppress_check_block_errors)
+			fprintf(stderr, "Csum didn't match\n");
 	}
+	ret = -EIO;
+out:
 	free_extent_buffer(eb);
 	return ERR_PTR(ret);
 }
-- 
2.4.0

