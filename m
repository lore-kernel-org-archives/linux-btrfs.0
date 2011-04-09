From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: [PATCH] Btrfs: fix memory leaks in btrfs_new_inode()
Date: Sat,  9 Apr 2011 11:30:07 +0900
Message-ID: <1302316207-30806-1-git-send-email-yoshinori.sano@gmail.com>
Cc: chris.mason@oracle.com, Yoshinori Sano <yoshinori.sano@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes memory leaks in btrfs_new_inode().

Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
---
 fs/btrfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index aa116dc..d8c93c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4536,14 +4536,17 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		return ERR_PTR(-ENOMEM);
 
 	inode = new_inode(root->fs_info->sb);
-	if (!inode)
+	if (!inode) {
+		btrfs_free_path(path);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	if (dir) {
 		trace_btrfs_inode_request(dir);
 
 		ret = btrfs_set_inode_index(dir, index);
 		if (ret) {
+			btrfs_free_path(path);
 			iput(inode);
 			return ERR_PTR(ret);
 		}
-- 
1.7.1

