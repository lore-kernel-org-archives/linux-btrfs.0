Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2560 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758668AbaGXDfe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:34 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3ZVhd017387
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/10] Btrfs: don't write any data into a readonly device when scrub
Date: Thu, 24 Jul 2014 11:37:07 +0800
Message-ID: <1406173035-29478-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should not write data into a readonly device especially seed device when
doing scrub, skip those devices.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b6d198f..23d3f6e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2904,6 +2904,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	struct scrub_ctx *sctx;
 	int ret;
 	struct btrfs_device *dev;
+	struct rcu_string *name;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
@@ -2965,6 +2966,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -ENODEV;
 	}
 
+	if (!is_dev_replace && !readonly && !dev->writeable) {
+		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		rcu_read_lock();
+		name = rcu_dereference(dev->name);
+		btrfs_err(fs_info, "scrub: device %s is not writable",
+			  name->str);
+		rcu_read_unlock();
+		return -EROFS;
+	}
+
 	mutex_lock(&fs_info->scrub_lock);
 	if (!dev->in_fs_metadata || dev->is_tgtdev_for_dev_replace) {
 		mutex_unlock(&fs_info->scrub_lock);
-- 
1.9.3

