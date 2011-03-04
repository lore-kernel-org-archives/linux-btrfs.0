From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure to remove the orphan item from the in-memory list
Date: Fri,  4 Mar 2011 14:11:30 -0500
Message-ID: <1299265890-20517-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a problem where if truncate fails the inode will still be on the in
memory orphan list.  This is will make us complain when the inode gets destroyed
because it's still on the orphan list.  So if we fail just remove us from the in
memory list and carry on.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 69df7c8..7a5bb9e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6587,6 +6587,12 @@ static int btrfs_truncate(struct inode *inode)
 		ret = btrfs_orphan_del(trans, inode);
 		if (ret)
 			err = ret;
+	} else if (ret && inode->i_nlink > 0) {
+		/*
+		 * Failed to do the truncate, remove us from the in memory
+		 * orphan list.
+		 */
+		ret = btrfs_orphan_del(NULL, inode);
 	}
 
 	ret = btrfs_update_inode(trans, root, inode);
-- 
1.7.2.3

