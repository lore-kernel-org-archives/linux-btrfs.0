From: Dan Carpenter <error27@gmail.com>
Subject: [patch 11/11] btrfs: The file argument for fsync() is never null
Date: Sat, 29 May 2010 11:49:07 +0200
Message-ID: <20100529094907.GL5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The "file" argument for fsync is never null so we can remove this check.

What drew my attention here is that 7ea8085910e: "drop unused dentry 
argument to ->fsync" introduced an unconditional dereference at the
start of the function and that generated a smatch warning.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 787b50a..e252d23 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1140,7 +1140,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	/*
 	 * ok we haven't committed the transaction yet, lets do a commit
 	 */
-	if (file && file->private_data)
+	if (file->private_data)
 		btrfs_ioctl_trans_end(file);
 
 	trans = btrfs_start_transaction(root, 0);
