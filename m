From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: memory leak in btrfs_add_inode_defrag()
Date: Fri, 5 Aug 2011 17:19:00 +0300
Message-ID: <20110805141900.GL7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We don't use the defrag struct on this path.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 658d669..1102059 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -150,6 +150,8 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	spin_lock(&root->fs_info->defrag_inodes_lock);
 	if (!BTRFS_I(inode)->in_defrag)
 		__btrfs_add_inode_defrag(inode, defrag);
+	else
+		kfree(defrag);
 	spin_unlock(&root->fs_info->defrag_inodes_lock);
 	return 0;
 }
