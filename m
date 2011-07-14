From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: move stuff around in btrfs_inode to get better packing
Date: Thu, 14 Jul 2011 14:31:38 -0400
Message-ID: <1310668298-25275-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Moving things around to give us better packing in the btrfs_inode.  This reduces
the size of our inode by 8 bytes.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 52d7eca..120240a 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -112,9 +112,6 @@ struct btrfs_inode {
 	 */
 	u64 disk_i_size;
 
-	/* flags field from the on disk inode */
-	u32 flags;
-
 	/*
 	 * if this is a directory then index_cnt is the counter for the index
 	 * number for new files that are created
@@ -128,6 +125,9 @@ struct btrfs_inode {
 	 */
 	u64 last_unlink_trans;
 
+	/* flags field from the on disk inode */
+	u32 flags;
+
 	/*
 	 * Counters to keep track of the number of extent item's we may use due
 	 * to delalloc and such.  outstanding_extents is the number of extent
-- 
1.7.5.2

