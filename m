Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39113 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaA3Ip2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 03:45:28 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0U8jQLt009255
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 16:45:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix unprotected alloc list insertion during the finishing procedure of replace
Date: Thu, 30 Jan 2014 16:46:54 +0800
Message-Id: <1391071615-6729-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the alloc list of the filesystem is protected by ->chunk_mutex, we need
get that mutex when we insert the new device into the list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 564c926..b20d59e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -484,6 +484,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	WARN_ON(ret);
 
 	/* keep away write_all_supers() during the finishing procedure */
+	mutex_lock(&root->fs_info->chunk_mutex);
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	btrfs_dev_replace_lock(dev_replace);
 	dev_replace->replace_state =
@@ -503,6 +504,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 			      rcu_str_deref(tgt_device->name), scrub_ret);
 		btrfs_dev_replace_unlock(dev_replace);
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&root->fs_info->chunk_mutex);
 		if (tgt_device)
 			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
@@ -543,6 +545,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 */
 	btrfs_dev_replace_unlock(dev_replace);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 	/* write back the superblocks */
 	trans = btrfs_start_transaction(root, 0);
-- 
1.8.5.3

