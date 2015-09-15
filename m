Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40779 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbbIOIsI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 04:48:08 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t8F8m6Bh031322
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 08:48:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t8F8m6gL013320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 08:48:06 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t8F8m6Fa028581
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 08:48:06 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: provide fail safe for BTRFS_IOC_GET_FSLABEL ioctl
Date: Tue, 15 Sep 2015 16:46:22 +0800
Message-Id: <1442306783-1288-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Old kernel like 2.6.32 does not provide ioctl BTRFS_IOC_GET_FSLABEL.
 So we need to provide a fail safe logic for btrfs-progs running
 on those kernel.

 In this patch when get_label_mounted() fails on the old kernel
 it will fail back to the old method and uses get_label_unmounted(),
 where it will read from the disk directly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |  7 ++++++-
 utils.c           | 18 +++++++++---------
 utils.h           |  1 +
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 8822695..793df0e 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -468,7 +468,12 @@ static int btrfs_scan_kernel(void *search, unsigned unit_mode)
 			goto out;
 		}
 
-		if (get_label_mounted(mnt->mnt_dir, label)) {
+		ret = get_label_mounted(mnt->mnt_dir, label);
+		/* provide backward kernel compatibility */
+		if (ret == -ENOTTY)
+			ret = get_label_unmounted((char *) dev_info_arg->path, label);
+
+		if (ret) {
 			kfree(dev_info_arg);
 			goto out;
 		}
diff --git a/utils.c b/utils.c
index afc97ee..297c5a3 100644
--- a/utils.c
+++ b/utils.c
@@ -1741,7 +1741,7 @@ static int set_label_mounted(const char *mount_path, const char *label)
 	return 0;
 }
 
-static int get_label_unmounted(const char *dev, char *label)
+int get_label_unmounted(const char *dev, char *label)
 {
 	struct btrfs_root *root;
 	int ret;
@@ -1751,11 +1751,6 @@ static int get_label_unmounted(const char *dev, char *label)
 	       fprintf(stderr, "FATAL: error checking %s mount status\n", dev);
 	       return -1;
 	}
-	if (ret > 0) {
-		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
-			dev);
-		return -1;
-	}
 
 	/* Open the super_block at the default location
 	 * and as read-only.
@@ -1780,6 +1775,7 @@ int get_label_mounted(const char *mount_path, char *labelp)
 {
 	char label[BTRFS_LABEL_SIZE];
 	int fd;
+	int ret;
 
 	fd = open(mount_path, O_RDONLY | O_NOATIME);
 	if (fd < 0) {
@@ -1788,10 +1784,14 @@ int get_label_mounted(const char *mount_path, char *labelp)
 	}
 
 	memset(label, '\0', sizeof(label));
-	if (ioctl(fd, BTRFS_IOC_GET_FSLABEL, label) < 0) {
-		fprintf(stderr, "ERROR: unable get label %s\n", strerror(errno));
+	ret = ioctl(fd, BTRFS_IOC_GET_FSLABEL, label);
+	if (ret < 0) {
+		if (errno != ENOTTY) {
+			fprintf(stderr, "ERROR: unable get label %s\n", strerror(errno));
+		}
+		ret = -errno;
 		close(fd);
-		return -1;
+		return ret;
 	}
 
 	strncpy(labelp, label, sizeof(label));
diff --git a/utils.h b/utils.h
index 24d7aa5..4f7bb6f 100644
--- a/utils.h
+++ b/utils.h
@@ -164,6 +164,7 @@ u64 btrfs_device_size(int fd, struct stat *st);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite);
 int get_label_mounted(const char *mount_path, char *labelp);
+int get_label_unmounted(const char *dev, char *label);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed);
 int group_profile_max_safe_loss(u64 flags);
-- 
2.4.1

