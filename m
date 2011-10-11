From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix the amount of space reserved for unlink
Date: Tue, 11 Oct 2011 14:18:29 -0400
Message-ID: <1318357109-16657-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Our unlink reservations were a bit much, we were reserving 10 and I only count 8
possible items we're touching, so comment what we're reserving for and fix the
count value.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1153731..d6ba353 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2758,7 +2758,16 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	u64 ino = btrfs_ino(inode);
 	u64 dir_ino = btrfs_ino(dir);
 
-	trans = btrfs_start_transaction(root, 10);
+	/*
+	 * 1 for the possible orphan item
+	 * 1 for the dir item
+	 * 1 for the dir index
+	 * 1 for the inode ref
+	 * 1 for the inode ref in the tree log
+	 * 2 for the dir entries in the log
+	 * 1 for the inode
+	 */
+	trans = btrfs_start_transaction(root, 8);
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
-- 
1.7.5.2

