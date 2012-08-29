Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51722 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2H2IoT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 04:44:19 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7T8iHkv002344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 08:44:18 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7T8iHEG003879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 08:44:17 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7T8iHaX003744
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 03:44:17 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: Add get/set label ioctl
Date: Wed, 29 Aug 2012 16:46:01 +0800
Message-Id: <1346229961-635-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1346229961-635-1-git-send-email-Anand.Jain@oracle.com>
References: <1346229961-635-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfslabel.c |   90 ++++++++++++++++++++++++++++++++++++++--------------------
 ioctl.h      |    2 +
 utils.h      |    1 +
 3 files changed, 62 insertions(+), 31 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index bf73802..3676db0 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -51,6 +51,10 @@ static void change_label_unmounted(char *dev, char *nLabel)
        struct btrfs_root *root;
        struct btrfs_trans_handle *trans;
 
+       if(check_mounted(dev)) {
+         fprintf(stderr, "ERROR: dev is mounted, use mount point\n");
+         return;
+       }
        /* Open the super_block at the default location
         * and as read-write.
         */
@@ -67,10 +71,57 @@ static void change_label_unmounted(char *dev, char *nLabel)
        close_ctree(root);
 }
 
+static void set_fs_label(char *mnt, char *label)
+{
+	int fd, e=0;
+	char fslabel[BTRFS_LABEL_SIZE+1];
+
+	memset(fslabel, 0, BTRFS_LABEL_SIZE+1);
+	strncpy(fslabel,label,BTRFS_LABEL_SIZE);
+
+	fd = open(mnt, O_RDONLY| O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: Open %s failed\n", mnt);
+		return;
+	}
+
+	if(ioctl(fd, BTRFS_IOC_SET_LABEL, fslabel) < 0) {
+		e = errno;
+		fprintf(stderr, "ERROR: get label failed, %s\n",
+			strerror(e));
+	}
+	close(fd);
+}
+
+static void get_fs_label(char *path)
+{
+	int fd, e=0;
+	char label[BTRFS_LABEL_SIZE+1];
+
+	fd = open(path, O_RDONLY| O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: Open %s failed\n", path);
+		return;
+	}
+
+	if(ioctl(fd, BTRFS_IOC_GET_LABEL, label) < 0) {
+		e = errno;
+		fprintf(stderr, "ERROR: get label failed, %s\n",
+			strerror(e));
+		return;
+	}
+	printf("%s\n",label);
+	close(fd);
+}
+
 static void get_label_unmounted(char *dev)
 {
        struct btrfs_root *root;
 
+       if(check_mounted(dev)) {
+         fprintf(stderr, "ERROR: dev is mounted, use mount point\n");
+         return;
+       }
        /* Open the super_block at the default location
         * and as read-only.
         */
@@ -84,41 +135,18 @@ static void get_label_unmounted(char *dev)
 
 int get_label(char *btrfs_dev)
 {
-
-	int ret;
-	ret = check_mounted(btrfs_dev);
-	if (ret < 0)
-	{
-	       fprintf(stderr, "FATAL: error checking %s mount status\n", btrfs_dev);
-	       return -1;
-	}
-
-	if(ret != 0)
-	{
-	       fprintf(stderr, "FATAL: the filesystem has to be unmounted\n");
-	       return -2;
-	}
-	get_label_unmounted(btrfs_dev);
+	if(is_existing_blk_or_reg_file(btrfs_dev))
+		get_label_unmounted(btrfs_dev);
+	else
+		get_fs_label(btrfs_dev);
 	return 0;
 }
 
-
 int set_label(char *btrfs_dev, char *nLabel)
 {
-
-	int ret;
-	ret = check_mounted(btrfs_dev);
-	if (ret < 0)
-	{
-	       fprintf(stderr, "FATAL: error checking %s mount status\n", btrfs_dev);
-	       return -1;
-	}
-
-	if(ret != 0)
-	{
-	       fprintf(stderr, "FATAL: the filesystem has to be unmounted\n");
-	       return -2;
-	}
-	change_label_unmounted(btrfs_dev, nLabel);
+	if(is_existing_blk_or_reg_file(btrfs_dev))
+		change_label_unmounted(btrfs_dev, nLabel);
+	else
+		set_fs_label(btrfs_dev, nLabel);
 	return 0;
 }
diff --git a/ioctl.h b/ioctl.h
index d6f3d07..7e1dcda 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -370,4 +370,6 @@ struct btrfs_ioctl_clone_range_args {
 				struct btrfs_ioctl_received_subvol_args)
 #define BTRFS_IOC_SEND _IOW(BTRFS_IOCTL_MAGIC, 38, struct btrfs_ioctl_send_args)
 
+#define BTRFS_IOC_GET_LABEL _IOR(BTRFS_IOCTL_MAGIC, 53, __u64)
+#define BTRFS_IOC_SET_LABEL _IOW(BTRFS_IOCTL_MAGIC, 54, __u64)
 #endif
diff --git a/utils.h b/utils.h
index c147c12..ba088fe 100644
--- a/utils.h
+++ b/utils.h
@@ -48,4 +48,5 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+int is_existing_blk_or_reg_file(const char* filename);
 #endif
-- 
1.7.1

