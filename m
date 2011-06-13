From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: turn to readonly when btrfs_start_ioctl_transaction() fails
Date: Mon, 13 Jun 2011 14:50:34 +0900
Message-ID: <201106130550.AA00025@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_start_ioctl_transaction() fails, we should call
btrfs_std_error() properly for filesystem to readonly.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
This patch needs btrfs_abort_transaction function.

 fs/btrfs/ioctl.c |    4 +++-

 1 files changed, 3 insertions(+), 1 deletions(-)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b793d11..119a126 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2498,8 +2498,10 @@ static long btrfs_ioctl_trans_start(struct file *file)
 
 	ret = -ENOMEM;
 	trans = btrfs_start_ioctl_transaction(root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, ret);
 		goto out_drop;
+	}
 
 	file->private_data = trans;
 	return 0;


