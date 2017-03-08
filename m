Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55740 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933399AbdCHCnQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 21:43:16 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>,
        <kilobyte@angband.pl>, <demfloro@demfloro.ru>
Subject: [PATCH v3 7/7] btrfs: Enhance missing device kernel message
Date: Wed, 8 Mar 2017 10:41:24 +0800
Message-ID: <20170308024124.16899-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For missing device, btrfs will just refuse to mount with almost
meaningless kernel message like:

 BTRFS info (device vdb6): disk space caching is enabled
 BTRFS info (device vdb6): has skinny extents
 BTRFS error (device vdb6): failed to read the system array: -5
 BTRFS error (device vdb6): open_ctree failed

This patch will add extra device missing output, making the result to:

 BTRFS info (device vdb6): disk space caching is enabled
 BTRFS info (device vdb6): has skinny extents
 BTRFS warning (device vdb6): devid 2 uuid 80470722-cad2-4b90-b7c3-fee294552f1b is missing
 BTRFS error (device vdb6): failed to read the system array: -5
 BTRFS error (device vdb6): open_ctree failed

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 24 +++++++++++++++++-------
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 765d213ac5ef..f2c878d5f714 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6442,6 +6442,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 		if (!map->stripes[i].dev &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
+			btrfs_report_missing_device(fs_info, devid, uuid);
 			return -EIO;
 		}
 		if (!map->stripes[i].dev) {
@@ -6452,8 +6453,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 				free_extent_map(em);
 				return -EIO;
 			}
-			btrfs_warn(fs_info, "devid %llu uuid %pU is missing",
-				   devid, uuid);
+			btrfs_report_missing_device(fs_info, devid, uuid);
 		}
 		map->stripes[i].dev->in_fs_metadata = 1;
 	}
@@ -6570,17 +6570,21 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 
 	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
 	if (!device) {
-		if (!btrfs_test_opt(fs_info, DEGRADED))
+		if (!btrfs_test_opt(fs_info, DEGRADED)) {
+			btrfs_report_missing_device(fs_info, devid, dev_uuid);
 			return -EIO;
+		}
 
 		device = add_missing_dev(fs_devices, devid, dev_uuid);
 		if (!device)
 			return -ENOMEM;
-		btrfs_warn(fs_info, "devid %llu uuid %pU missing",
-				devid, dev_uuid);
+		btrfs_report_missing_device(fs_info, devid, dev_uuid);
 	} else {
-		if (!device->bdev && !btrfs_test_opt(fs_info, DEGRADED))
-			return -EIO;
+		if (!device->bdev) {
+			btrfs_report_missing_device(fs_info, devid, dev_uuid);
+			if (!btrfs_test_opt(fs_info, DEGRADED))
+				return -EIO;
+		}
 
 		if(!device->bdev && !device->missing) {
 			/*
@@ -6806,6 +6810,12 @@ static bool device_has_rw_degrade_error(struct extra_rw_degrade_errors *errors,
 	return ret;
 }
 
+void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
+				 u8 *uuid)
+{
+	btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing", devid, uuid);
+}
+
 /*
  * Check if all chunks in the fs is OK for read-write degraded mount
  *
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 67d7474e42a3..1f6ab55640da 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -573,4 +573,6 @@ void record_extra_rw_degrade_error(struct extra_rw_degrade_errors *errors,
 
 bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 			       struct extra_rw_degrade_errors *errors);
+void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
+				 u8 *uuid);
 #endif
-- 
2.12.0



