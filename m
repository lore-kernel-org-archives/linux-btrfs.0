From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] Btrfs: make error return negative in btrfs_sync_file()
Date: Fri, 29 Jan 2010 11:42:11 +0100
Message-ID: <4B62BB83.7030907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754894Ab0A2Kg2@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It appears the error return should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
But I fail to see how ret can be positive, unless maybe when we already
did a BUG()?

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c020335..9d08096 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1133,7 +1133,7 @@ int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	}
 	mutex_lock(&dentry->d_inode->i_mutex);
 out:
-	return ret > 0 ? EIO : ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 static const struct vm_operations_struct btrfs_file_vm_ops = {
