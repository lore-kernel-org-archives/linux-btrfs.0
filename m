Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3B1KEr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 05:04:47 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r1SA4j1N006146
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 18:04:45 +0800
Message-ID: <512F2BF0.3060201@cn.fujitsu.com>
Date: Thu, 28 Feb 2013 18:05:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: fix wrong reserved space when deleting a snapshot/subvolume
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When deleting a snapshot/subvolume, we need remove root ref/backref,
dir entries and update the dir inode, so we must reserve free space
for those operations.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8046cfc..0b46081 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2064,6 +2064,8 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	struct btrfs_root *dest = NULL;
 	struct btrfs_ioctl_vol_args *vol_args;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_block_rsv block_rsv;
+	u64 qgroup_reserved;
 	int namelen;
 	int ret;
 	int err = 0;
@@ -2153,12 +2155,23 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	if (err)
 		goto out_up_write;
 
+	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
+	/*
+	 * One for dir inode, two for dir entries, two for root
+	 * ref/backref.
+	 */
+	err = btrfs_subvolume_reserve_metadata(root, &block_rsv,
+					       5, &qgroup_reserved);
+	if (err)
+		goto out_up_write;
+
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto out_up_write;
+		goto out_release;
 	}
-	trans->block_rsv = &root->fs_info->global_block_rsv;
+	trans->block_rsv = &block_rsv;
+	trans->bytes_reserved = block_rsv.size;
 
 	ret = btrfs_unlink_subvol(trans, root, dir,
 				dest->root_key.objectid,
@@ -2188,10 +2201,14 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		}
 	}
 out_end_trans:
+	trans->block_rsv = NULL;
+	trans->bytes_reserved = 0;
 	ret = btrfs_end_transaction(trans, root);
 	if (ret && !err)
 		err = ret;
 	inode->i_flags |= S_DEAD;
+out_release:
+	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
 out_up_write:
 	up_write(&root->fs_info->subvol_sem);
 out_unlock:
-- 
1.6.5.2
