Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30883 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2LQLfG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 06:35:06 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBHBZ4hO008810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 11:35:05 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBHBZ4V7014174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 11:35:04 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBHBZ3X8008883
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 05:35:03 -0600
Message-ID: <50CF0363.9050900@oracle.com>
Date: Mon, 17 Dec 2012 19:34:59 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [PATCH v5 1/4] Btrfs-progs: get label of a mounted file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50CF0053.4050906@oracle.com>


With this new ioctl(2), we can get the label for a mounted file system.
It still does normal process to fetch label if the specified file system is unmounted.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

---
 btrfslabel.c |   74 ++++++++++++++++++++++++++++++++++++++--------------------
 ioctl.h      |    2 ++
 utils.c      |    2 +-
 utils.h      |    1 +
 4 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index cb142b0..443eff6 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -67,45 +67,69 @@ static void change_label_unmounted(char *dev, char *nLabel)
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
+	if (ret > 0) {
+		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
+			dev);
+		return -1;
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
+	memset(label, '\0', sizeof(label));
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
index 6fda3a1..0807b05 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -432,4 +432,6 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 					struct btrfs_ioctl_qgroup_limit_args)
+#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
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
