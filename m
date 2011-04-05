From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not call btrfs_update_inode in endio if nothing changed
Date: Tue,  5 Apr 2011 19:25:36 -0400
Message-ID: <1302045936-1696-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In the DIO code we often don't update the i_disk_size because the i_size isn't
updated until after the DIO is completed, so basically we are allocating a path,
doing a search, and updating the inode item for no reason since nothing changed.
btrfs_ordered_update_i_size will return 1 if it didn't update i_disk_size, so
only run btrfs_update_inode if btrfs_ordered_update_i_size returns 0.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c5e1c4..3476760 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1763,9 +1763,12 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
 
-	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
-	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
+	ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
+	if (!ret) {
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+	}
+	ret = 0;
 out:
 	if (nolock) {
 		if (trans)
@@ -5827,8 +5830,10 @@ again:
 	}
 
 	add_pending_csums(trans, inode, ordered->file_offset, &ordered->list);
-	btrfs_ordered_update_i_size(inode, 0, ordered);
-	btrfs_update_inode(trans, root, inode);
+	ret = btrfs_ordered_update_i_size(inode, 0, ordered);
+	if (!ret)
+		btrfs_update_inode(trans, root, inode);
+	ret = 0;
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, ordered->file_offset,
 			     ordered->file_offset + ordered->len - 1,
-- 
1.7.2.3

