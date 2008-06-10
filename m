From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: BTRFS_IOC_TRANS_START should be privilegued
Date: Tue, 10 Jun 2008 18:20:16 +0200
Message-ID: <20080610162016.GB13610@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As mentioned in the comment next to it btrfs_ioctl_trans_start can
do bad damage to filesystems and thus should be limited to privilegued
users.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/ioctl.c
===================================================================
--- btrfs-unstable.orig/ioctl.c	2008-06-10 18:17:00.000000000 +0200
+++ btrfs-unstable/ioctl.c	2008-06-10 18:17:57.000000000 +0200
@@ -706,6 +706,9 @@ long btrfs_ioctl_trans_start(struct file
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	mutex_lock(&root->fs_info->fs_mutex);
 	if (file->private_data) {
 		ret = -EINPROGRESS;
