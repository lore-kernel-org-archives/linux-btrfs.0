Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaC0DOw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 23:14:52 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2R3Egka023267
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 11:14:46 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix snapshot vs nocow writting
Date: Thu, 27 Mar 2014 11:12:25 +0800
Message-Id: <1395889945-28120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While running fsstress and snapshots concurrently, we will hit something
like followings:

Thread 1			Thread 2

|->fallocate
  |->write pages
    |->join transaction
       |->add ordered extent
    |->end transaction
				|->flushing data
				  |->creating pending snapshots
|->write data into src root's
   fallocated space

After above work flows finished, we will get a state that source and
snapshot root share same space, but source root have written data into
fallocated space, this will make fsck fail to verify checksums for
snapshot root's preallocating file extent data.Nocow writting also
has this same problem.

Fix this problem by syncing snapshots with nocow writting:

 1.for nocow writting,if there are pending snapshots, we will
 fall into COW way.

 2.if there are pending nocow writes, snapshots for this root
 will be blocked until nocow writting finish.

Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3eccd6..83d4ae5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1280,6 +1280,15 @@ next_slot:
 			disk_bytenr += cur_offset - found_key.offset;
 			num_bytes = min(end + 1, extent_end) - cur_offset;
 			/*
+			 * if there are pending snapshots for this root,
+			 * we fall into common COW way.
+			 */
+			if (!nolock) {
+				err = btrfs_start_nocow_write(root);
+				if (!err)
+					goto out_check;
+			}
+			/*
 			 * force cow if csum exists in the range.
 			 * this ensure that csum for a given extent are
 			 * either valid or do not exist.
@@ -1298,6 +1307,8 @@ next_slot:
 out_check:
 		if (extent_end <= start) {
 			path->slots[0]++;
+			if (!nolock && nocow)
+				btrfs_end_nocow_write(root);
 			goto next_slot;
 		}
 		if (!nocow) {
@@ -1315,8 +1326,11 @@ out_check:
 			ret = cow_file_range(inode, locked_page,
 					     cow_start, found_key.offset - 1,
 					     page_started, nr_written, 1);
-			if (ret)
+			if (ret) {
+				if (!nolock && nocow)
+					btrfs_end_nocow_write(root);
 				goto error;
+			}
 			cow_start = (u64)-1;
 		}
 
@@ -1363,8 +1377,11 @@ out_check:
 		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 			ret = btrfs_reloc_clone_csums(inode, cur_offset,
 						      num_bytes);
-			if (ret)
+			if (ret) {
+				if (!nolock && nocow)
+					btrfs_end_nocow_write(root);
 				goto error;
+			}
 		}
 
 		extent_clear_unlock_delalloc(inode, cur_offset,
@@ -1372,6 +1389,8 @@ out_check:
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC, PAGE_UNLOCK |
 					     PAGE_SET_PRIVATE2);
+		if (!nolock && nocow)
+			btrfs_end_nocow_write(root);
 		cur_offset = extent_end;
 		if (cur_offset > end)
 			break;
-- 
1.9.0

