From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix path leakage on subvol deletion
Date: Tue, 14 Jun 2011 14:25:41 -0400
Message-ID: <1308075941-17234-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The delayed ref patch accidently removed the btrfs_free_path in
btrfs_unlink_subvol, this puts it back and means we don't leak a path.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 30a1d24..1483372 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3074,6 +3074,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
+	btrfs_free_path(path);
 	return 0;
 }
 
-- 
1.7.5.2

