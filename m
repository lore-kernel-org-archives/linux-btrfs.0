Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13195 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932488AbaICNeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:15 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYBAq006674
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/18] Btrfs: fix unprotected device list access when getting the fs information
Date: Wed, 3 Sep 2014 21:35:40 +0800
Message-ID: <1409751347-5296-11-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we get the fs information, we forgot to acquire the mutex of device list,
it might cause the problem we might access a device that was removed. Fix
it by acquiring the device list mutex.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 089991d..6b98358 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1703,7 +1703,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 
-	/* holding chunk_muext to avoid allocating new chunks */
+	/*
+	 * holding chunk_muext to avoid allocating new chunks, holding
+	 * device_list_mutex to avoid the device being removed
+	 */
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
@@ -1744,11 +1748,13 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
 	if (ret) {
 		mutex_unlock(&fs_info->chunk_mutex);
+		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return ret;
 	}
 	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 	mutex_unlock(&fs_info->chunk_mutex);
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	buf->f_type = BTRFS_SUPER_MAGIC;
 	buf->f_bsize = dentry->d_sb->s_blocksize;
-- 
1.9.3

