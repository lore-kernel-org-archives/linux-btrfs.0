Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18624 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab2LLAag (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 19:30:36 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBC0UZA4009719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:30:36 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBC0UY3m017421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:30:35 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBC0UYVT012953
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 18:30:34 -0600
Message-ID: <50C7D025.6050708@oracle.com>
Date: Wed, 12 Dec 2012 08:30:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [PATCH v4 2/3] Btrfs-progs: change the label of a mounted filesystem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50C7CE36.3060603@oracle.com>

Change the label of a mounted file system through the new ioctl BTRFS_IOCTL_FS_SETLABEL.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

---
 btrfslabel.c |   84 ++++++++++++++++++++++++++++++++++------------------------
 ioctl.h      |    2 ++
 2 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index 761a312..65388e5 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -46,25 +46,52 @@
 #define GET_LABEL                      3
 #define SET_LABEL                      4
 
-static void change_label_unmounted(char *dev, char *nLabel)
+static int set_label_unmounted(const char *dev, const char *label)
 {
-       struct btrfs_root *root;
-       struct btrfs_trans_handle *trans;
-
-       /* Open the super_block at the default location
-        * and as read-write.
-        */
-       root = open_ctree(dev, 0, 1);
-       if (!root) /* errors are printed by open_ctree() */
-         return;
-
-       trans = btrfs_start_transaction(root, 1);
-       strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
-       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
-       btrfs_commit_transaction(trans, root);
-
-       /* Now we close it since we are done. */
-       close_ctree(root);
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root;
+	int ret;
+
+	ret = check_mounted(dev);
+	if (ret < 0) {
+	       fprintf(stderr, "FATAL: error checking %s mount status\n", dev);
+	       return -1;
+	}
+
+	/* Open the super_block at the default location
+	 * and as read-write.
+	 */
+	root = open_ctree(dev, 0, 1);
+	if (!root) /* errors are printed by open_ctree() */
+		return -1;
+
+	trans = btrfs_start_transaction(root, 1);
+	strncpy(root->fs_info->super_copy.label, label, BTRFS_LABEL_SIZE);
+	root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
+	btrfs_commit_transaction(trans, root);
+
+	/* Now we close it since we are done. */
+	close_ctree(root);
+	return 0;
+}
+
+static int set_label_mounted(const char *mount_path, const char *label)
+{
+	int fd;
+
+	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
+		return -1;
+	}
+
+	if (ioctl(fd, BTRFS_IOC_SET_FSLABEL, label) < 0) {
+		fprintf(stderr, "ERROR: unable get label %s\n", strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	return 0;
 }
 
 static int get_label_unmounted(const char *dev)
@@ -125,22 +152,9 @@ int get_label(const char *btrfs_dev)
 		get_label_mounted(btrfs_dev);
 }
 
-int set_label(char *btrfs_dev, char *nLabel)
+int set_label(char *btrfs_dev, char *label)
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
-	return 0;
+	return is_existing_blk_or_reg_file(btrfs_dev) ?
+		set_label_unmounted(btrfs_dev, label) :
+		set_label_mounted(btrfs_dev, label);
 }
diff --git a/ioctl.h b/ioctl.h
index ed6784d..07259f9 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -434,4 +434,6 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_qgroup_limit_args)
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 53, \
 				   char[BTRFS_LABEL_SIZE])
+#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 54, \
+				   char[BTRFS_LABEL_SIZE])
 #endif
-- 
1.7.9.5
