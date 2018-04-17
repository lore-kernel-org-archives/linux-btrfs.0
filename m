Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42721 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeDQIwu (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Apr 2018 04:52:50 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: delayed-inode: Remove wrong qgroup meta reservation calls
Date: Tue, 17 Apr 2018 16:52:45 +0800
Message-Id: <20180417085245.6303-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for
delayed inode and item") merged into mainline is not the updated version
submitted to the mail list in Dec 2017.

Which lacks the following fixes:

1) Remove btrfs_qgroup_convert_reserved_meta() call in
   btrfs_delayed_item_release_metadata()
2) Remove btrfs_qgroup_reserve_meta_prealloc() call in
   btrfs_delayed_inode_reserve_metadata()

Those fixes will resolve unexpected EDQUOT problems.

Fixes: 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-inode.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 86ec2edc05e8..ac4fa7218c57 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -569,6 +569,12 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 	dst_rsv = &fs_info->delayed_block_rsv;
 
 	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
+
+	/*
+	 * Here we migrate space rsv from transaction rsv, since have
+	 * already reserved space when starting a transaction.
+	 * So no need to reserve qgroup space here.
+	 */
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 	if (!ret) {
 		trace_btrfs_space_reservation(fs_info, "delayed_item",
@@ -590,7 +596,10 @@ static void btrfs_delayed_item_release_metadata(struct btrfs_root *root,
 		return;
 
 	rsv = &fs_info->delayed_block_rsv;
-	btrfs_qgroup_convert_reserved_meta(root, item->bytes_reserved);
+	/*
+	 * Check btrfs_delayed_item_reserve_metadata() to see why we don't need
+	 * to release/reserve qgroup space.
+	 */
 	trace_btrfs_space_reservation(fs_info, "delayed_item",
 				      item->key.objectid, item->bytes_reserved,
 				      0);
@@ -615,9 +624,6 @@ static int btrfs_delayed_inode_reserve_metadata(
 
 	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
-	ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
-	if (ret < 0)
-		return ret;
 	/*
 	 * btrfs_dirty_inode will update the inode under btrfs_join_transaction
 	 * which doesn't reserve space for speed.  This is a problem since we
@@ -629,6 +635,10 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
+		ret = btrfs_qgroup_reserve_meta_prealloc(root,
+				fs_info->nodesize, true);
+		if (ret < 0)
+			return ret;
 		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
 					  BTRFS_RESERVE_NO_FLUSH);
 		/*
@@ -647,7 +657,9 @@ static int btrfs_delayed_inode_reserve_metadata(
 						      "delayed_inode",
 						      btrfs_ino(inode),
 						      num_bytes, 1);
-		}
+		} else
+			btrfs_qgroup_free_meta_prealloc(root,
+							fs_info->nodesize);
 		return ret;
 	}
 
-- 
2.17.0

