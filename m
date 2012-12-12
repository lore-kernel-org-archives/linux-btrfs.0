Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18608 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab2LLAac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 19:30:32 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBC0UVsF009657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:30:32 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBC0UUQC000249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:30:31 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBC0UUVG012919
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 18:30:30 -0600
Message-ID: <50C7D021.9060603@oracle.com>
Date: Wed, 12 Dec 2012 08:30:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [PATCH v4 1/3] Btrfs-progs: get the label of a mounted filesystem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50C7CE36.3060603@oracle.com>

Get the label of a mounted filesystem through the new ioctl BTRFS_IOCTL_FS_GETLABEL.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

---
 btrfslabel.c |   68 +++++++++++++++++++++++++++++++++++++---------------------
 ioctl.h      |    2 ++
 utils.c      |    2 +-
 utils.h      |    1 +
 4 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index cb142b0..761a312 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -67,45 +67,63 @@ static void change_label_unmounted(char *dev, char *nLabel)
        close_ctree(root);
 }
 
-int get_label_unmounted(char *dev)
+static int get_label_unmounted(const char *dev)
 {
-       struct btrfs_root *root;
+	struct btrfs_root *root;
+	int ret;
 
-       /* Open the super_block at the default location
-        * and as read-only.
-        */
-       root = open_ctree(dev, 0, 0);
+	ret = check_mounted(dev);
+	if (ret < 0) {
+	       fprintf(stderr, "FATAL: error checking %s mount status\n", dev);
+	       return -1;
+	}
 
-       if(!root)
-         return -1;
+	/* Open the super_block at the default location
+	 * and as read-only.
+	 */
+	root = open_ctree(dev, 0, 0);
+	if(!root)
+		return -1;
 
-       fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
+	fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
 
-       /* Now we close it since we are done. */
-       close_ctree(root);
-       return 0;
+	/* Now we close it since we are done. */
+	close_ctree(root);
+	return 0;
 }
 
-int get_label(char *btrfs_dev)
+/*
+ * If a partition is mounted, try to get the filesystem label via its
+ * mounted path rather than device.  Return the corresponding error
+ * the user specified the device path.
+ */
+static int get_label_mounted(const char *mount_path)
 {
+	char label[BTRFS_LABEL_SIZE];
+	int fd;
 
-	int ret;
-	ret = check_mounted(btrfs_dev);
-	if (ret < 0)
-	{
-	       fprintf(stderr, "FATAL: error checking %s mount status\n", btrfs_dev);
-	       return -1;
+	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
+		return -1;
 	}
 
-	if(ret != 0)
-	{
-	       fprintf(stderr, "FATAL: the filesystem has to be unmounted\n");
-	       return -2;
+	if (ioctl(fd, BTRFS_IOC_GET_FSLABEL, label) < 0) {
+		fprintf(stderr, "ERROR: unable get label %s\n", strerror(errno));
+		close(fd);
+		return -1;
 	}
-	ret = get_label_unmounted(btrfs_dev);
-	return ret;
+
+	fprintf(stdout, "%s\n", label);
+	return 0;
 }
 
+int get_label(const char *btrfs_dev)
+{
+	return is_existing_blk_or_reg_file(btrfs_dev) ?
+		get_label_unmounted(btrfs_dev) :
+		get_label_mounted(btrfs_dev);
+}
 
 int set_label(char *btrfs_dev, char *nLabel)
 {
diff --git a/ioctl.h b/ioctl.h
index 6fda3a1..ed6784d 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -432,4 +432,6 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 					struct btrfs_ioctl_qgroup_limit_args)
+#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 53, \
+				   char[BTRFS_LABEL_SIZE])
 #endif
diff --git a/utils.c b/utils.c
index 205e667..d59bca3 100644
--- a/utils.c
+++ b/utils.c
@@ -811,7 +811,7 @@ int check_mounted(const char* file)
 		return -errno;
 	}
 
-	ret =  check_mounted_where(fd, file, NULL, 0, NULL);
+	ret = check_mounted_where(fd, file, NULL, 0, NULL);
 	close(fd);
 
 	return ret;
diff --git a/utils.h b/utils.h
index 3a0368b..8750f28 100644
--- a/utils.h
+++ b/utils.h
@@ -46,4 +46,5 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+int is_existing_blk_or_reg_file(const char* filename);
 #endif
-- 
1.7.9.5
