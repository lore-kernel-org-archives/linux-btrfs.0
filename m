Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50988 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbbKIK5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:38 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9Avaf2014019
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvaYA011754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:36 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvaPg020324
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/15] btrfs: Do per-chunk check for mount time check
Date: Mon,  9 Nov 2015 18:56:16 +0800
Message-Id: <1447066589-3835-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
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
index 1776bcd..d54cdcc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2866,6 +2866,16 @@ int open_ctree(struct super_block *sb,
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
@@ -2957,14 +2967,6 @@ retry_root_backup:
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
2.4.1

