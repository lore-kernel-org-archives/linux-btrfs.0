Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9373 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab2KZIkU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:40:20 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ8eJIo006479
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 16:40:19 +0800
Message-ID: <50B32B0B.7040007@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:40:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/9] Btrfs: pass root object into btrfs_ioctl_{start, wait}_sync()
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have gotten the root in the caller, just pass it into
btrfs_ioctl_{start, wait}_sync() directly.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 84bb4de..fd3fff5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3038,9 +3038,9 @@ long btrfs_ioctl_trans_end(struct file *file)
 	return 0;
 }
 
-static noinline long btrfs_ioctl_start_sync(struct file *file, void __user *argp)
+static noinline long btrfs_ioctl_start_sync(struct btrfs_root *root,
+					    void __user *argp)
 {
-	struct btrfs_root *root = BTRFS_I(file->f_dentry->d_inode)->root;
 	struct btrfs_trans_handle *trans;
 	u64 transid;
 	int ret;
@@ -3061,9 +3061,9 @@ static noinline long btrfs_ioctl_start_sync(struct file *file, void __user *argp
 	return 0;
 }
 
-static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
+static noinline long btrfs_ioctl_wait_sync(struct btrfs_root *root,
+					   void __user *argp)
 {
-	struct btrfs_root *root = BTRFS_I(file->f_dentry->d_inode)->root;
 	u64 transid;
 
 	if (argp) {
@@ -3770,9 +3770,9 @@ long btrfs_ioctl(struct file *file, unsigned int
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
 	case BTRFS_IOC_START_SYNC:
-		return btrfs_ioctl_start_sync(file, argp);
+		return btrfs_ioctl_start_sync(root, argp);
 	case BTRFS_IOC_WAIT_SYNC:
-		return btrfs_ioctl_wait_sync(file, argp);
+		return btrfs_ioctl_wait_sync(root, argp);
 	case BTRFS_IOC_SCRUB:
 		return btrfs_ioctl_scrub(root, argp);
 	case BTRFS_IOC_SCRUB_CANCEL:
-- 
1.7.11.7

