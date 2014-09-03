Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46202 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932669AbaICNeR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYDQq006685
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 14/18] Btrfs: fix use-after-free problem of the device during device replace
Date: Wed, 3 Sep 2014 21:35:43 +0800
Message-ID: <1409751347-5296-14-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problem is:
	Task0(device scan task)		Task1(device replace task)
	scan_one_device()
	mutex_lock(&uuid_mutex)
	device = find_device()
					mutex_lock(&device_list_mutex)
					lock_chunk()
					rm_and_free_source_device
					unlock_chunk()
					mutex_unlock(&device_list_mutex)
	check device

Destroying the target device if device replace fails also has the same problem.

We fix this problem by locking uuid_mutex during destroying source device or
target device, just like the device remove operation.

It is a temporary solution, we can fix this problem and make the code more
clear by atomic counter in the future.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 3 +++
 fs/btrfs/volumes.c     | 4 +++-
 fs/btrfs/volumes.h     | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index aa4c828..e9cbbdb 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -509,6 +509,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	ret = btrfs_commit_transaction(trans, root);
 	WARN_ON(ret);
 
+	mutex_lock(&uuid_mutex);
 	/* keep away write_all_supers() during the finishing procedure */
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&root->fs_info->chunk_mutex);
@@ -536,6 +537,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		btrfs_dev_replace_unlock(dev_replace);
 		mutex_unlock(&root->fs_info->chunk_mutex);
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&uuid_mutex);
 		if (tgt_device)
 			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
@@ -591,6 +593,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 */
 	mutex_unlock(&root->fs_info->chunk_mutex);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&uuid_mutex);
 
 	/* write back the superblocks */
 	trans = btrfs_start_transaction(root, 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f0173b1..24d7001 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -50,7 +50,7 @@ static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 
-static DEFINE_MUTEX(uuid_mutex);
+DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
 
 static void lock_chunks(struct btrfs_root *root)
@@ -1867,6 +1867,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_device *next_device;
 
+	mutex_lock(&uuid_mutex);
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	if (tgtdev->bdev) {
@@ -1886,6 +1887,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	call_rcu(&tgtdev->rcu, free_device);
 
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&uuid_mutex);
 }
 
 static int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 76600a3..2b37da3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -24,6 +24,8 @@
 #include <linux/btrfs.h>
 #include "async-thread.h"
 
+extern struct mutex uuid_mutex;
+
 #define BTRFS_STRIPE_LEN	(64 * 1024)
 
 struct buffer_head;
-- 
1.9.3

