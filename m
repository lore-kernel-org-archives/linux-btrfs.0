Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40570 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbcCXKsa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 06:48:30 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/3] btrfs: use fs_info directly
Date: Thu, 24 Mar 2016 18:48:12 +0800
Message-Id: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Local variable fs_info, contains root->fs_info, use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index a1d6652e0c47..d38cad37ba27 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -375,7 +375,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	WARN_ON(!tgt_device);
 	dev_replace->tgtdev = tgt_device;
 
-	btrfs_info_in_rcu(root->fs_info,
+	btrfs_info_in_rcu(fs_info,
 		      "dev_replace from %s (devid %llu) to %s started",
 		      src_device->missing ? "<missing disk>" :
 		        rcu_str_deref(src_device->name),
@@ -399,9 +399,9 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 
 	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
 	if (ret)
-		btrfs_err(root->fs_info, "kobj add dev failed %d\n", ret);
+		btrfs_err(fs_info, "kobj add dev failed %d\n", ret);
 
-	btrfs_wait_ordered_roots(root->fs_info, -1);
+	btrfs_wait_ordered_roots(fs_info, -1);
 
 	/* force writing the updated state information to disk */
 	trans = btrfs_start_transaction(root, 0);
@@ -419,7 +419,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 			      btrfs_device_get_total_bytes(src_device),
 			      &dev_replace->scrub_progress, 0, 1);
 
-	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
+	ret = btrfs_dev_replace_finishing(fs_info, ret);
 	/* don't warn if EINPROGRESS, someone else might be running scrub */
 	if (ret == -EINPROGRESS) {
 		args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
-- 
2.7.0

