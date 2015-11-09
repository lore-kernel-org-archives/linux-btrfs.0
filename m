Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51895 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbKIK7p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:59:45 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AxjRx016168
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Axjfb013843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:45 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AxiHC015090
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: Introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV SB flags
Date: Mon,  9 Nov 2015 18:58:36 +0800
Message-Id: <1447066719-3880-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066719-3880-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <1447066719-3880-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-show-super.c | 3 ++-
 ctree.h            | 4 +++-
 volumes.c          | 4 ++++
 volumes.h          | 2 ++
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 27414c8..d9626cd 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -300,7 +300,8 @@ struct readable_flag_entry incompat_flags_array[] = {
 	DEF_INCOMPAT_FLAG_ENTRY(EXTENDED_IREF),
 	DEF_INCOMPAT_FLAG_ENTRY(RAID56),
 	DEF_INCOMPAT_FLAG_ENTRY(SKINNY_METADATA),
-	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES)
+	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES),
+	DEF_INCOMPAT_FLAG_ENTRY(SPARE_DEV)
 };
 static const int incompat_flags_num = sizeof(incompat_flags_array) /
 				      sizeof(struct readable_flag_entry);
diff --git a/ctree.h b/ctree.h
index c57f9ca..2c3aea6 100644
--- a/ctree.h
+++ b/ctree.h
@@ -475,6 +475,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_SPARE_DEV	(1ULL << 10)
 
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
@@ -488,7 +489,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_SPARE_DEV)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
diff --git a/volumes.c b/volumes.c
index ca50f1c..beaeecf 100644
--- a/volumes.c
+++ b/volumes.c
@@ -101,6 +101,10 @@ static int device_list_add(const char *path,
 		fs_devices->latest_devid = devid;
 		fs_devices->latest_trans = found_transid;
 		fs_devices->lowest_devid = (u64)-1;
+		if (btrfs_super_incompat_flags(disk_super) &
+				BTRFS_FEATURE_INCOMPAT_SPARE_DEV)
+			fs_devices->spare = 1;
+
 		device = NULL;
 	} else {
 		device = __find_device(&fs_devices->devices, devid,
diff --git a/volumes.h b/volumes.h
index 4ecb993..3b56c1f 100644
--- a/volumes.h
+++ b/volumes.h
@@ -83,6 +83,8 @@ struct btrfs_fs_devices {
 
 	int seeding;
 	struct btrfs_fs_devices *seed;
+
+	int spare;
 };
 
 struct btrfs_bio_stripe {
-- 
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
