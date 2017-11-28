Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21200 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932165AbdK1Cmx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 21:42:53 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAS2gpA7010853
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 02:42:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAS2gp5P009961
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 02:42:51 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAS2gpn4000822
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 02:42:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add helper for device path or missing
Date: Tue, 28 Nov 2017 10:43:10 +0800
Message-Id: <20171128024310.31095-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch creates a helper function to get either the rcu device path
or missing.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7c655f9a7a50..4b6ceb38cb5f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -304,6 +304,11 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
 		dev_replace->cursor_left_last_write_of_item;
 }
 
+static inline char *dev_missing_or_rcu_str(struct btrfs_device *device)
+{
+	return device->missing ? "<missing disk>" : rcu_str_deref(device->name);
+}
+
 int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
 		int read_src)
@@ -363,8 +368,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 
 	btrfs_info_in_rcu(fs_info,
 		      "dev_replace from %s (devid %llu) to %s started",
-		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
+		      dev_missing_or_rcu_str(src_device),
 		      src_device->devid,
 		      rcu_str_deref(tgt_device->name));
 
@@ -538,8 +542,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	} else {
 		btrfs_err_in_rcu(fs_info,
 				 "btrfs_scrub_dev(%s, %llu, %s) failed %d",
-				 src_device->missing ? "<missing disk>" :
-				 rcu_str_deref(src_device->name),
+				 dev_missing_or_rcu_str(src_device),
 				 src_device->devid,
 				 rcu_str_deref(tgt_device->name), scrub_ret);
 		btrfs_dev_replace_unlock(dev_replace, 1);
@@ -557,8 +560,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	btrfs_info_in_rcu(fs_info,
 			  "dev_replace from %s (devid %llu) to %s finished",
-			  src_device->missing ? "<missing disk>" :
-			  rcu_str_deref(src_device->name),
+			  dev_missing_or_rcu_str(src_device),
 			  src_device->devid,
 			  rcu_str_deref(tgt_device->name));
 	tgt_device->is_tgtdev_for_dev_replace = 0;
@@ -814,12 +816,10 @@ static int btrfs_dev_replace_kthread(void *data)
 	progress = btrfs_dev_replace_progress(fs_info);
 	progress = div_u64(progress, 10);
 	btrfs_info_in_rcu(fs_info,
-		"continuing dev_replace from %s (devid %llu) to %s @%u%%",
-		dev_replace->srcdev->missing ? "<missing disk>"
-			: rcu_str_deref(dev_replace->srcdev->name),
+		"continuing dev_replace from %s (devid %llu) to target %s @%u%%",
+		dev_missing_or_rcu_str(dev_replace->srcdev),
 		dev_replace->srcdev->devid,
-		dev_replace->tgtdev ? rcu_str_deref(dev_replace->tgtdev->name)
-			: "<missing target disk>",
+		dev_missing_or_rcu_str(dev_replace->tgtdev),
 		(unsigned int)progress);
 
 	btrfs_dev_replace_continue_on_mount(fs_info);
-- 
2.15.0

