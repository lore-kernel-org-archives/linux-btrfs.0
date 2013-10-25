Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38487 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3JYU4g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 16:56:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C32F49A03E9
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 14:56:35 -0600 (MDT)
Received: from CAS1.int.fusionio.com ([10.101.1.40]) by mx2.fusionio.com with ESMTP id jyRVXQC6bIeuAMbo (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 14:56:35 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't abort transaction in run_delalloc_nocow
Date: Fri, 25 Oct 2013 16:56:33 -0400
Message-ID: <1382734593-20353-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is just the write path, the only reason we start a transaction is so we can
check cross references, we don't make any actual changes, so there is no reason
to abort the transaction if we fail.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db6e11f..a239de0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1180,10 +1180,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	while (1) {
 		ret = btrfs_lookup_file_extent(trans, root, path, ino,
 					       cur_offset, 0);
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, root, ret);
+		if (ret < 0)
 			goto error;
-		}
 		if (ret > 0 && path->slots[0] > 0 && check_prev) {
 			leaf = path->nodes[0];
 			btrfs_item_key_to_cpu(leaf, &found_key,
@@ -1197,10 +1195,8 @@ next_slot:
 		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root, path);
-			if (ret < 0) {
-				btrfs_abort_transaction(trans, root, ret);
+			if (ret < 0)
 				goto error;
-			}
 			if (ret > 0)
 				break;
 			leaf = path->nodes[0];
@@ -1291,10 +1287,8 @@ out_check:
 			ret = cow_file_range(inode, locked_page,
 					     cow_start, found_key.offset - 1,
 					     page_started, nr_written, 1);
-			if (ret) {
-				btrfs_abort_transaction(trans, root, ret);
+			if (ret)
 				goto error;
-			}
 			cow_start = (u64)-1;
 		}
 
@@ -1341,10 +1335,8 @@ out_check:
 		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 			ret = btrfs_reloc_clone_csums(inode, cur_offset,
 						      num_bytes);
-			if (ret) {
-				btrfs_abort_transaction(trans, root, ret);
+			if (ret)
 				goto error;
-			}
 		}
 
 		extent_clear_unlock_delalloc(inode, cur_offset,
@@ -1366,10 +1358,8 @@ out_check:
 	if (cow_start != (u64)-1) {
 		ret = cow_file_range(inode, locked_page, cow_start, end,
 				     page_started, nr_written, 1);
-		if (ret) {
-			btrfs_abort_transaction(trans, root, ret);
+		if (ret)
 			goto error;
-		}
 	}
 
 error:
-- 
1.8.3.1

