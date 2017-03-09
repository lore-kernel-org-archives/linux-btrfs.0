Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5669 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754641AbdCIBvx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 20:51:53 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>
Subject: [PATCH v3.1 2/7] btrfs: Do chunk level rw degrade check at mount time
Date: Thu, 9 Mar 2017 09:34:37 +0800
Message-ID: <20170309013442.19957-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now use the btrfs_check_rw_degradable() to do mount time degration check.

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
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Adam Borowski <kilobyte@angband.pl>
Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
---
 fs/btrfs/disk-io.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08b74daf35d0..3de89283d400 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3057,15 +3057,10 @@ int open_ctree(struct super_block *sb,
 		btrfs_err(fs_info, "failed to read block groups: %d", ret);
 		goto fail_sysfs;
 	}
-	fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
-	if (fs_info->fs_devices->missing_devices >
-	     fs_info->num_tolerated_disk_barrier_failures &&
-	    !(sb->s_flags & MS_RDONLY)) {
+
+	if (!(sb->s_flags & MS_RDONLY) && !btrfs_check_rw_degradable(fs_info)) {
 		btrfs_warn(fs_info,
-"missing devices (%llu) exceeds the limit (%d), writeable mount is not allowed",
-			fs_info->fs_devices->missing_devices,
-			fs_info->num_tolerated_disk_barrier_failures);
+		"writeable mount is not allowed due to too many missing devices");
 		goto fail_sysfs;
 	}
 
-- 
2.12.0



