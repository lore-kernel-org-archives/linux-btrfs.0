Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39005 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3GOF0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 08/11] btrfs-progs: get_label_mounted to return label instead of print
Date: Mon, 15 Jul 2013 13:30:54 +0800
Message-Id: <1373866257-10519-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

This would help to reuse the function

v1->v2: removed static and updated .h file, in a preparation
        work for the following patch

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |   18 +++++++++++++-----
 utils.h |    1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index a7f2ca3..e8a42bf 100644
--- a/utils.c
+++ b/utils.c
@@ -1335,7 +1335,7 @@ static int get_label_unmounted(const char *dev)
  * mounted path rather than device.  Return the corresponding error
  * the user specified the device path.
  */
-static int get_label_mounted(const char *mount_path)
+int get_label_mounted(const char *mount_path, char *labelp)
 {
 	char label[BTRFS_LABEL_SIZE];
 	int fd;
@@ -1353,16 +1353,24 @@ static int get_label_mounted(const char *mount_path)
 		return -1;
 	}
 
-	fprintf(stdout, "%s\n", label);
+	strncpy(labelp, label, sizeof(label));
 	close(fd);
 	return 0;
 }
 
 int get_label(const char *btrfs_dev)
 {
-	return is_existing_blk_or_reg_file(btrfs_dev) ?
-		get_label_unmounted(btrfs_dev) :
-		get_label_mounted(btrfs_dev);
+	int ret;
+	char label[BTRFS_LABEL_SIZE];
+
+	if (is_existing_blk_or_reg_file(btrfs_dev))
+		ret = get_label_unmounted(btrfs_dev);
+	else {
+		ret = get_label_mounted(btrfs_dev, label);
+		if (!ret)
+			fprintf(stdout, "%s\n", label);
+	}
+	return ret;
 }
 
 int set_label(const char *btrfs_dev, const char *label)
diff --git a/utils.h b/utils.h
index a10c51a..708b580 100644
--- a/utils.h
+++ b/utils.h
@@ -77,4 +77,5 @@ u64 btrfs_device_size(int fd, struct stat *st);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
+int get_label_mounted(const char *mount_path, char *labelp);
 #endif
-- 
1.7.7.6

