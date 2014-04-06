Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46764 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaDFE7Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 00:59:24 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3] btrfs: btrfs_rm_device() should zero mirror SB as well
Date: Sun,  6 Apr 2014 12:59:07 +0800
Message-Id: <1396760347-3675-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1396275237-8306-1-git-send-email-Anand.Jain@oracle.com>
References: <1396275237-8306-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This fix will ensure all SB copies on the disk is zeroed
when the disk is intentionally removed. This helps to
better manage disks in the user land.

This version of patch also merges the Zach patch as below.

 btrfs: don't double brelse on device rm

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Zach Brown <zab@redhat.com>
---

 v2->v3: commit rework, continues to have Zach patch merged
 v1->v2: merge with Zach fix, commit update

 fs/btrfs/volumes.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b4660c4..7243196 100644
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

