From: Sage Weil <sage@newdream.net>
Subject: [PATCH 1/2] Btrfs: remove bad fsync transaction check
Date: Mon, 15 Mar 2010 10:26:31 -0700
Message-ID: <1268673992-5250-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This check for a user transaction is a bogus: fsync() with an open user
transaction is verboten.  If the caller is the same process who started
a user transaction, and this is a different file, we will deadlock.  If
it's the same file, this check means we won't deadlock, but the
transaction will be prematurely closed out.

Any user transaction ioctl users should be careful to avoid fsync() and
close out the transaction explicitly.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/file.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d146dde..2e6404f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1097,12 +1097,6 @@ int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	}
 	mutex_unlock(&root->fs_info->trans_mutex);
 
-	/*
-	 * ok we haven't committed the transaction yet, lets do a commit
-	 */
-	if (file && file->private_data)
-		btrfs_ioctl_trans_end(file);
-
 	trans = btrfs_start_transaction(root, 1);
 	if (!trans) {
 		ret = -ENOMEM;
-- 
1.7.0

