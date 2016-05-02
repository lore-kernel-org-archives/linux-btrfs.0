Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33901 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbcEBSPW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 14:15:22 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: vegard.nossum@oracle.com, sterba@suse.com
Subject: [PATCH 1/2] Btrfs: add more valid checks for superblock
Date: Mon,  2 May 2016 11:15:50 -0700
Message-Id: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds valid checks for super_total_bytes, super_bytes_used and
super_stripesize.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4e47849..988d03f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4120,6 +4120,20 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
 	 * done later
 	 */
+	if (btrfs_super_total_bytes(sb) == 0) {
+		printk(KERN_ERR "BTRFS: total bytes is zero\n");
+		ret = -EINVAL;
+	}
+	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
+		printk(KERN_ERR "BTRFS: bytes_used is too small %llu\n",
+		       btrfs_super_bytes_used(sb));
+		ret = -EINVAL;
+	}
+	if (btrfs_super_stripesize(sb) != 4096) {
+		printk(KERN_ERR "BTRFS: invalid stripesize %u\n",
+		       btrfs_super_stripesize(sb));
+		ret = -EINVAL;
+	}
 	if (btrfs_super_num_devices(sb) > (1UL << 31))
 		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
 				btrfs_super_num_devices(sb));
-- 
2.5.5

