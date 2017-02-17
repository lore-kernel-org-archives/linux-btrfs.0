Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35249 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934237AbdBQOn6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:58 -0500
Received: by mail-wm0-f67.google.com with SMTP id u63so2925322wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:57 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/38] btrfs: Make calc_csum_metadata_size take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:00 +0200
Message-Id: <1487342609-20652-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 74bfaf222973..781dfdf5556e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5893,24 +5893,21 @@ static unsigned drop_outstanding_extent(struct btrfs_inode *inode, u64 num_bytes
  *
  * This must be called with BTRFS_I(inode)->lock held.
  */
-static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
+static u64 calc_csum_metadata_size(struct btrfs_inode *inode, u64 num_bytes,
 				   int reserve)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	u64 old_csums, num_csums;
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM &&
-	    BTRFS_I(inode)->csum_bytes == 0)
+	if (inode->flags & BTRFS_INODE_NODATASUM && inode->csum_bytes == 0)
 		return 0;
 
-	old_csums = btrfs_csum_bytes_to_leaves(fs_info,
-					       BTRFS_I(inode)->csum_bytes);
+	old_csums = btrfs_csum_bytes_to_leaves(fs_info, inode->csum_bytes);
 	if (reserve)
-		BTRFS_I(inode)->csum_bytes += num_bytes;
+		inode->csum_bytes += num_bytes;
 	else
-		BTRFS_I(inode)->csum_bytes -= num_bytes;
-	num_csums = btrfs_csum_bytes_to_leaves(fs_info,
-					       BTRFS_I(inode)->csum_bytes);
+		inode->csum_bytes -= num_bytes;
+	num_csums = btrfs_csum_bytes_to_leaves(fs_info, inode->csum_bytes);
 
 	/* No change, no need to reserve more */
 	if (old_csums == num_csums)
@@ -5974,7 +5971,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	/* We always want to reserve a slot for updating the inode. */
 	to_reserve = btrfs_calc_trans_metadata_size(fs_info, nr_extents + 1);
-	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
+	to_reserve += calc_csum_metadata_size(BTRFS_I(inode), num_bytes, 1);
 	csum_bytes = BTRFS_I(inode)->csum_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
 
@@ -6021,7 +6018,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	 * so we can just reduce our inodes csum bytes and carry on.
 	 */
 	if (BTRFS_I(inode)->csum_bytes == csum_bytes) {
-		calc_csum_metadata_size(inode, num_bytes, 0);
+		calc_csum_metadata_size(BTRFS_I(inode), num_bytes, 0);
 	} else {
 		u64 orig_csum_bytes = BTRFS_I(inode)->csum_bytes;
 		u64 bytes;
@@ -6036,7 +6033,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		 */
 		bytes = csum_bytes - BTRFS_I(inode)->csum_bytes;
 		BTRFS_I(inode)->csum_bytes = csum_bytes;
-		to_free = calc_csum_metadata_size(inode, bytes, 0);
+		to_free = calc_csum_metadata_size(BTRFS_I(inode), bytes, 0);
 
 
 		/*
@@ -6046,7 +6043,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		 */
 		BTRFS_I(inode)->csum_bytes = csum_bytes - num_bytes;
 		bytes = csum_bytes - orig_csum_bytes;
-		bytes = calc_csum_metadata_size(inode, bytes, 0);
+		bytes = calc_csum_metadata_size(BTRFS_I(inode), bytes, 0);
 
 		/*
 		 * Now reset ->csum_bytes to what it should be.  If bytes is
@@ -6096,7 +6093,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	dropped = drop_outstanding_extent(BTRFS_I(inode), num_bytes);
 
 	if (num_bytes)
-		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+		to_free = calc_csum_metadata_size(BTRFS_I(inode), num_bytes, 0);
 	spin_unlock(&BTRFS_I(inode)->lock);
 	if (dropped > 0)
 		to_free += btrfs_calc_trans_metadata_size(fs_info, dropped);
-- 
2.7.4

