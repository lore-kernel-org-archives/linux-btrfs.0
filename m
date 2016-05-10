Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35812 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbcEJOJi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:09:38 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 02/13] btrfs: Do per-chunk check for mount time check
Date: Tue, 10 May 2016 22:09:21 +0800
Message-Id: <1462889372-5274-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Now use the btrfs_check_degraded() to do mount time degraded check.

With this patch, now we can mount with the following case:
 # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
 # wipefs -a /dev/sdc
 # mount /dev/sdb /mnt/btrfs -o degraded
 As the single data chunk is only in sdb, so it's OK to mount as degraded,
 as missing one device is OK for RAID1.

But still fail with the following case as expected:
 # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
 # wipefs -a /dev/sdb
 # mount /dev/sdc /mnt/btrfs -o degraded
 As the data chunk is only in sdb, so it's not OK to mount it as degraded.

Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reported-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

[Btrfs: use btrfs_error instead of btrfs_err during mount]
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d01f89d130e0..4f91a049fbca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2885,6 +2885,16 @@ int open_ctree(struct super_block *sb,
 		goto fail_tree_roots;
 	}
 
+	ret = btrfs_check_degradable(fs_info, fs_info->sb->s_flags);
+	if (ret < 0) {
+		btrfs_err(fs_info, "degraded writable mount failed %d", ret);
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
@@ -2988,14 +2998,6 @@ retry_root_backup:
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
2.7.0

