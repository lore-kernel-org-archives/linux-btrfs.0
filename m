From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 04/10] btrfs: btrfs_sync_file should return -EIO not EIO
Date: Wed, 04 Nov 2009 14:03:50 -0500
Message-ID: <20091104190433.036021313@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch fixes a typo in the return path of btrfs_sync_file, which
 currently returns EIO instead of -EIO.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1223,7 +1223,7 @@ int btrfs_sync_file(struct file *file, s
 	}
 	mutex_lock(&dentry->d_inode->i_mutex);
 out:
-	return ret > 0 ? EIO : ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 static struct vm_operations_struct btrfs_file_vm_ops = {

