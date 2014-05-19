Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30743 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaESRAw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:00:52 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4JH0pWu018694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:00:52 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4JH0oaE013342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:00:51 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4JH0ovs013335
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:00:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4 RESEND] btrfs: btrfs_rm_device() should zero mirror SB as well
Date: Tue, 20 May 2014 01:03:40 +0800
Message-Id: <1400519022-5540-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1400519022-5540-1-git-send-email-anand.jain@oracle.com>
References: <1400519022-5540-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fix will ensure all SB copies on the disk is zeroed
when the disk is intentionally removed. This helps to
better manage disks in the user land.

This version of patch also merges the Zach patch as below.

 btrfs: don't double brelse on device rm

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/volumes.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19e68f7..1567439 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1681,12 +1681,43 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * remove it from the devices list and zero out the old super
 	 */
 	if (clear_super && disk_super) {
+		u64 bytenr;
+		int i;
+
 		/* make sure this device isn't detected as part of
 		 * the FS anymore
 		 */
 		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
 		set_buffer_dirty(bh);
 		sync_dirty_buffer(bh);
+
+		/* clear the mirror copies of super block on the disk
+		 * being removed, 0th copy is been taken care above and
+		 * the below would take of the rest
+		 */
+		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+			bytenr = btrfs_sb_offset(i);
+			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
+					i_size_read(bdev->bd_inode))
+				break;
+
+			brelse(bh);
+			bh = __bread(bdev, bytenr / 4096,
+					BTRFS_SUPER_INFO_SIZE);
+			if (!bh)
+				continue;
+
+			disk_super = (struct btrfs_super_block *)bh->b_data;
+
+			if (btrfs_super_bytenr(disk_super) != bytenr ||
+				btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
+				continue;
+			}
+			memset(&disk_super->magic, 0,
+						sizeof(disk_super->magic));
+			set_buffer_dirty(bh);
+			sync_dirty_buffer(bh);
+		}
 	}
 
 	ret = 0;
-- 
1.8.5.3

