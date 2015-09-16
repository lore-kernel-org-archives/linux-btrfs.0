Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11635 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752089AbbIPDn4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 23:43:56 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8G3hcZ1012780
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 11:43:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs: Remove unneeded missing device number check
Date: Wed, 16 Sep 2015 11:43:51 +0800
Message-ID: <1442375031-18212-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we do per-chunk missing device number check at read_one_chunk() time,
it's not needed to do global missing device number check.

Just remove it.

Now btrfs can handle the following case:
 # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc

 Data chunk will be located in sdb, so we should be safe to wipe sdc
 # wipefs -a /dev/sdc

 # mount /dev/sdb /mnt/btrfs -o degraded

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0b658d0..ac640ea 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2947,14 +2947,6 @@ retry_root_backup:
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

