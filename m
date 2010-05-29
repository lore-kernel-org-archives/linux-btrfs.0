From: Dan Carpenter <error27@gmail.com>
Subject: [patch 7/11] btrfs: unwind after btrfs_start_transaction() errors
Date: Sat, 29 May 2010 11:46:47 +0200
Message-ID: <20100529094647.GH5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Sage Weil <sage@newdream.net>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This was added by a22285a6a3: "Btrfs: Integrate metadata reservation
with start_transaction".  If we goto out here then we skip all the
unwinding and there are locks still held etc.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4cdb98c..9f9a1d9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1280,7 +1280,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto out;
+		goto out_up_write;
 	}
 	trans->block_rsv = &root->fs_info->global_block_rsv;
 
