Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21058 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755827AbbIUCMs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 22:12:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8L2CTNo003275
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 10:12:29 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] btrfs: Do per-chunk check for mount time check
Date: Mon, 21 Sep 2015 10:10:40 +0800
Message-ID: <1442801443-5132-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now use the btrfs_check_degraded() to do mount time degraded check.

With this patch, now we can mount with the following case:
 # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
 # wipefs -a /dev/sdc
 # mount /dev/sdb /mnt/btrfs -o degraded
 As the single data chunk is only in sdb, so it's OK to mount as
 degraded, as missing one device is OK for RAID1.

But still fail with the following case as expected:
 # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
 # wipefs -a /dev/sdb
 # mount /dev/sdc /mnt/btrfs -o degraded
 As the data chunk is only in sdb, so it's not OK to mount it as
 degraded.

Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reported-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0b658d0..d64299f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2858,6 +2858,16 @@ int open_ctree(struct super_block *sb,
 		goto fail_tree_roots;
 	}
 
+	ret = btrfs_check_degradable(fs_info, fs_info->sb->s_flags);
+	if (ret < 0) {
+		btrfs_error(fs_info, ret, "degraded writable mount failed");
+		goto fail_tree_roots;
+	} else if (ret > 0 && !btrfs_test_opt(chunk_root, DEGRADED)) {
+		btrfs_warn(fs_info,
+			"Some device missing, but still degraded mountable, please mount with -o degraded option");
+		ret = -EACCES;
+		goto fail_tree_roots;
+	}
 	/*
 	 * keep the device that is marked to be the target device for the
 	 * dev_replace procedure
@@ -2947,14 +2957,6 @@ retry_root_backup:
 	}
 	fs_info->num_tolerated_disk_barrier_failures =
 		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
-	if (fs_info->fs_devices->missing_devices >
-	     fs_info->num_tolerated_disk_barrier_failures &&
-	    !(sb->s_flags & MS_RDONLY)) {
-		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
-			fs_info->fs_devices->missing_devices,
-			fs_info->num_tolerated_disk_barrier_failures);
-		goto fail_sysfs;
-	}
 
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
-- 
2.5.2

