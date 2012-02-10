From: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
Subject: [PATCH] btrfs: honor umask when creating subvol root
Date: Fri, 10 Feb 2012 22:15:54 +0100
Message-ID: <1328908554-10971-1-git-send-email-falbrechtskirchinger@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Set the subvol root inode permissions based on the current umask.
---
 fs/btrfs/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32214fe..b88e71a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6696,8 +6696,10 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	int err;
 	u64 index = 0;
 
-	inode = btrfs_new_inode(trans, new_root, NULL, "..", 2, new_dirid,
-				new_dirid, S_IFDIR | 0700, &index);
+	inode = btrfs_new_inode(trans, new_root, NULL, "..", 2,
+				new_dirid, new_dirid,
+				S_IFDIR | (~current_umask() & S_IRWXUGO),
+				&index);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 	inode->i_op = &btrfs_dir_inode_operations;
-- 
1.7.8.4

