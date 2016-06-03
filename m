Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16522 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbcFCTET (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 15:04:19 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2 1/2] Btrfs: add more valid checks for superblock
Date: Fri,  3 Jun 2016 12:05:14 -0700
Message-Id: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds valid checks for super_total_bytes, super_bytes_used and
super_stripesize, super_num_devices.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2:
 - Check super_num_devices and super_total_bytes after loading chunk
   tree.
 - Check super_bytes_used against the minimum space usage of a fresh
   mkfs.btrfs.
 - Fix super_stripesize to be sectorsize instead of 4096

 fs/btrfs/disk-io.c | 11 +++++++++++
 fs/btrfs/volumes.c | 24 ++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6628fca..ea78d77 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4130,6 +4130,17 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
 	 * done later
 	 */
+	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
+		printk(KERN_ERR "BTRFS: bytes_used is too small %llu\n",
+		       btrfs_super_bytes_used(sb));
+		ret = -EINVAL;
+	}
+	if (!is_power_of_2(btrfs_super_stripesize(sb)) ||
+	    btrfs_super_stripesize(sb) != sectorsize) {
+		printk(KERN_ERR "BTRFS: invalid stripesize %u\n",
+		       btrfs_super_stripesize(sb));
+		ret = -EINVAL;
+	}
 	if (btrfs_super_num_devices(sb) > (1UL << 31))
 		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
 				btrfs_super_num_devices(sb));
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bdc6256..d403ab6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6648,6 +6648,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	struct btrfs_key found_key;
 	int ret;
 	int slot;
+	u64 total_dev = 0;
 
 	root = root->fs_info->chunk_root;
 
@@ -6689,6 +6690,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 			ret = read_one_dev(root, leaf, dev_item);
 			if (ret)
 				goto error;
+			total_dev++;
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
@@ -6698,6 +6700,28 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 		}
 		path->slots[0]++;
 	}
+
+	/*
+	 * After loading chunk tree, we've got all device information,
+	 * do another round of validation check.
+	 */
+	if (total_dev != root->fs_info->fs_devices->total_devices) {
+		btrfs_err(root->fs_info,
+	   "super_num_devices(%llu) mismatch with num_devices(%llu) found here",
+			  btrfs_super_num_devices(root->fs_info->super_copy),
+			  total_dev);
+		ret = -EINVAL;
+		goto error;
+	}
+	if (btrfs_super_total_bytes(root->fs_info->super_copy) <
+	    root->fs_info->fs_devices->total_rw_bytes) {
+		btrfs_err(root->fs_info,
+	"super_total_bytes(%llu) mismatch with fs_devices total_rw_bytes(%llu)",
+			  btrfs_super_total_bytes(root->fs_info->super_copy),
+			  root->fs_info->fs_devices->total_rw_bytes);
+		ret = -EINVAL;
+		goto error;
+	}
 	ret = 0;
 error:
 	unlock_chunks(root);
-- 
2.5.5

