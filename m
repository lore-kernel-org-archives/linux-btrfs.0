Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57366 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab2F2Jz1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:55:27 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9oU0I012674
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:50:54 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: use helper function to simplify code
Date: Fri, 29 Jun 2012 17:59:55 +0800
Message-Id: <1340963995-32549-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340963995-32549-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1340963995-32549-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've made a helper function for reading root, so just apply it.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f9c2180..9b93fda 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2844,7 +2844,6 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	struct btrfs_dir_item *di;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
-	struct btrfs_key location;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_super_block *disk_super;
 	u64 features;
@@ -2857,20 +2856,10 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	if (copy_from_user(&objectid, argp, sizeof(objectid)))
 		return -EFAULT;
 
-	if (!objectid)
-		objectid = root->root_key.objectid;
-
-	location.objectid = objectid;
-	location.type = BTRFS_ROOT_ITEM_KEY;
-	location.offset = (u64)-1;
-
-	new_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
+	new_root = __btrfs_subvol_get_root(root, objectid);
 	if (IS_ERR(new_root))
 		return PTR_ERR(new_root);
 
-	if (btrfs_root_refs(&new_root->root_item) == 0)
-		return -ENOENT;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.6.5.2

