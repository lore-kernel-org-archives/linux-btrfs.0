Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35241 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934391AbdBQOoB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:01 -0500
Received: by mail-wm0-f66.google.com with SMTP id u63so2925230wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:56 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/38] btrfs: Make drop_outstanding_extent take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:59 +0200
Message-Id: <1487342609-20652-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 293ca5d34d44..74bfaf222973 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5846,7 +5846,7 @@ void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
  * reserved extents that need to be freed.  This must be called with
  * BTRFS_I(inode)->lock held.
  */
-static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes)
+static unsigned drop_outstanding_extent(struct btrfs_inode *inode, u64 num_bytes)
 {
 	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
@@ -5854,25 +5854,24 @@ static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes)
 
 	num_extents = count_max_extents(num_bytes);
 	ASSERT(num_extents);
-	ASSERT(BTRFS_I(inode)->outstanding_extents >= num_extents);
-	BTRFS_I(inode)->outstanding_extents -= num_extents;
+	ASSERT(inode->outstanding_extents >= num_extents);
+	inode->outstanding_extents -= num_extents;
 
-	if (BTRFS_I(inode)->outstanding_extents == 0 &&
+	if (inode->outstanding_extents == 0 &&
 	    test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-			       &BTRFS_I(inode)->runtime_flags))
+			       &inode->runtime_flags))
 		drop_inode_space = 1;
 
 	/*
 	 * If we have more or the same amount of outstanding extents than we have
 	 * reserved then we need to leave the reserved extents count alone.
 	 */
-	if (BTRFS_I(inode)->outstanding_extents >=
-	    BTRFS_I(inode)->reserved_extents)
+	if (inode->outstanding_extents >= inode->reserved_extents)
 		return drop_inode_space;
 
-	dropped_extents = BTRFS_I(inode)->reserved_extents -
-		BTRFS_I(inode)->outstanding_extents;
-	BTRFS_I(inode)->reserved_extents -= dropped_extents;
+	dropped_extents = inode->reserved_extents -
+		inode->outstanding_extents;
+	inode->reserved_extents -= dropped_extents;
 	return dropped_extents + drop_inode_space;
 }
 
@@ -6015,7 +6014,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 out_fail:
 	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(BTRFS_I(inode), num_bytes);
 	/*
 	 * If the inodes csum_bytes is the same as the original
 	 * csum_bytes then we know we haven't raced with any free()ers
@@ -6094,7 +6093,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(BTRFS_I(inode), num_bytes);
 
 	if (num_bytes)
 		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
-- 
2.7.4

