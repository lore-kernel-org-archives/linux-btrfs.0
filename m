Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:15610 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbdKXFVk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 00:21:40 -0500
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 64530AC00B1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 14:21:30 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id AD7F8BF8009
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 14:21:29 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: mkfs: check the status of file at mkfs
Message-ID: <adf7ec95-b00b-9101-76fe-6c41b90c7707@jp.fujitsu.com>
Date: Fri, 24 Nov 2017 14:21:15 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, only the status of block devices is checked at mkfs,
but we should also check for regular files whether they are already
formatted or mounted to prevent overwrite accidentally.

Device status is checked by test_dev_for_mkfs().
The part which is not related to block device is split from this
and used for both block device and regular file.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 mkfs/common.c | 46 ++++++++++++++++++++++++++++++----------------
 mkfs/common.h |  1 +
 mkfs/main.c   |  8 ++++++--
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index 71318b10..5bf56828 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -632,23 +632,9 @@ int test_dev_for_mkfs(const char *file, int force_overwrite)
 		error("%s is a swap device", file);
 		return 1;
 	}
-	if (!force_overwrite) {
-		if (check_overwrite(file)) {
-			error("use the -f option to force overwrite of %s",
-					file);
-			return 1;
-		}
-	}
-	ret = check_mounted(file);
-	if (ret < 0) {
-		error("cannot check mount status of %s: %s", file,
-				strerror(-ret));
+	ret = test_status_for_mkfs(file, force_overwrite);
+	if (ret)
 		return 1;
-	}
-	if (ret == 1) {
-		error("%s is mounted", file);
-		return 1;
-	}
 	/* check if the device is busy */
 	fd = open(file, O_RDWR|O_EXCL);
 	if (fd < 0) {
@@ -669,6 +655,34 @@ int test_dev_for_mkfs(const char *file, int force_overwrite)
 	return 0;
 }
 
+/*
+ * check if the file (device) is formatted or mounted
+ */
+int test_status_for_mkfs(const char *file, int force_overwrite)
+{
+	int ret;
+
+	if (!force_overwrite) {
+		if (check_overwrite(file)) {
+			error("use the -f option to force overwrite of %s",
+					file);
+			return 1;
+		}
+	}
+	ret = check_mounted(file);
+	if (ret < 0) {
+		error("cannot check mount status of %s: %s", file,
+				strerror(-ret));
+		return 1;
+	}
+	if (ret == 1) {
+		error("%s is mounted", file);
+		return 1;
+	}
+
+	return 0;
+}
+
 int is_vol_small(const char *file)
 {
 	int fd = -1;
diff --git a/mkfs/common.h b/mkfs/common.h
index 3757e9e7..f5ee5ee4 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -72,6 +72,7 @@ int test_minimum_size(const char *file, u64 min_dev_size);
 int is_vol_small(const char *file);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, int ssd);
+int test_status_for_mkfs(const char *file, int force_overwrite);
 int test_dev_for_mkfs(const char *file, int force_overwrite);
 
 #endif
diff --git a/mkfs/main.c b/mkfs/main.c
index a69a699f..e405e5a2 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1598,8 +1598,12 @@ int main(int argc, char **argv)
 	while (dev_cnt-- > 0) {
 		file = argv[optind++];
 		if (is_block_device(file) == 1)
-			if (test_dev_for_mkfs(file, force_overwrite))
-				goto error;
+			ret = test_dev_for_mkfs(file, force_overwrite);
+		else
+			ret = test_status_for_mkfs(file, force_overwrite);
+
+		if (ret)
+			goto error;
 	}
 
 	optind = saved_optind;
-- 
2.13.6

