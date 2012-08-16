Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52662 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298Ab2HPUah (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 16:30:37 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id urrQjQKjGn5VDJMH (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 14:30:36 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix possible corruption when fsyncing written prealloced extents
Date: Thu, 16 Aug 2012 16:35:46 -0400
Message-ID: <1345149346-1456-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While working on my fsync patch my fsync tester kept hitting mismatching
md5sums when I would randomly write to a prealloc'ed region, syncfs() and
then write to the prealloced region some more and then fsync() and then
immediately reboot.  This is because the tree logging code will skip writing
csums for file extents who's generation is less than the current running
transaction.  When we mark extents as written we haven't been updating their
generation so they were always being skipped.  This wouldn't happen if you
were to preallocate and then write in the same transaction, but if you for
example prealloced a VM you could definitely run into this problem.  This
patch makes my fsync tester happy again.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5caf285..b7c885c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -935,12 +935,16 @@ again:
 			btrfs_set_item_key_safe(trans, root, path, &new_key);
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_generation(leaf, fi,
+							 trans->transid);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							extent_end - end);
 			btrfs_set_file_extent_offset(leaf, fi,
 						     end - orig_offset);
 			fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
 					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_generation(leaf, fi,
+							 trans->transid);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							end - other_start);
 			btrfs_mark_buffer_dirty(leaf);
@@ -958,12 +962,16 @@ again:
 					    struct btrfs_file_extent_item);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							start - key.offset);
+			btrfs_set_file_extent_generation(leaf, fi,
+							 trans->transid);
 			path->slots[0]++;
 			new_key.offset = start;
 			btrfs_set_item_key_safe(trans, root, path, &new_key);
 
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_generation(leaf, fi,
+							 trans->transid);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							other_end - start);
 			btrfs_set_file_extent_offset(leaf, fi,
@@ -991,12 +999,14 @@ again:
 		leaf = path->nodes[0];
 		fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
 				    struct btrfs_file_extent_item);
+		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 		btrfs_set_file_extent_num_bytes(leaf, fi,
 						split - key.offset);
 
 		fi = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_file_extent_item);
 
+		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 		btrfs_set_file_extent_offset(leaf, fi, split - orig_offset);
 		btrfs_set_file_extent_num_bytes(leaf, fi,
 						extent_end - split);
@@ -1056,12 +1066,14 @@ again:
 			   struct btrfs_file_extent_item);
 		btrfs_set_file_extent_type(leaf, fi,
 					   BTRFS_FILE_EXTENT_REG);
+		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 		btrfs_mark_buffer_dirty(leaf);
 	} else {
 		fi = btrfs_item_ptr(leaf, del_slot - 1,
 			   struct btrfs_file_extent_item);
 		btrfs_set_file_extent_type(leaf, fi,
 					   BTRFS_FILE_EXTENT_REG);
+		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 		btrfs_set_file_extent_num_bytes(leaf, fi,
 						extent_end - key.offset);
 		btrfs_mark_buffer_dirty(leaf);
-- 
1.7.7.6

