Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50853 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbcC2O1h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:27:37 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 1/4] btrfs-progs: Introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV SB flags
Date: Tue, 29 Mar 2016 22:27:18 +0800
Message-Id: <1459261641-32254-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 ctree.h   | 4 +++-
 volumes.c | 4 ++++
 volumes.h | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 5ab0f4a45a15..97cbd032fbb1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -480,6 +480,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_SPARE_DEV	(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 
@@ -495,7 +496,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_SPARE_DEV)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
diff --git a/volumes.c b/volumes.c
index 4d22db25be1d..2a5dcd40c092 100644
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
index c0007adc6a24..79cec37e9194 100644
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
2.7.0

