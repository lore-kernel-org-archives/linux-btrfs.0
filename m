Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36220 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab3GRLNQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 07:13:16 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6IBDEpv027807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 11:13:15 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6IBDESh029235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 11:13:14 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6IBDEJN029230
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 11:13:14 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix get set label blocking against balance
Date: Thu, 18 Jul 2013 19:18:18 +0800
Message-Id: <1374146298-30789-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <51E655D1.5020309@oracle.com>
References: <51E655D1.5020309@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_ioctl_get_fslabel() and btrfs_ioctl_set_fslabel()
used root->fs_info->volume_mutex mutex which caused operations
like balance to block set/get label operation until its
completion and generally balance operation takes a long
time to complete, so it will be annoying to the user when
cli appears hung

This patch will use mutex uuid_mutex. which is defined
in volume.c, and so it is moved to volume.h as well.

also this patch will add a bit of optimization within
the btrfs_ioctl_get_falabel() function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c   | 16 ++++++++++------
 fs/btrfs/volumes.c |  1 -
 fs/btrfs/volumes.h |  1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2177bea..d67d7d3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4043,17 +4043,21 @@ static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	const char *label = root->fs_info->super_copy->label;
-	size_t len = strnlen(label, BTRFS_LABEL_SIZE);
+	char label_copy[BTRFS_LABEL_SIZE];
+	size_t	len;
 	int ret;
 
+	mutex_lock(&uuid_mutex);
+	memcpy(label_copy, label, BTRFS_LABEL_SIZE);
+	mutex_unlock(&uuid_mutex);
+
+	len = strnlen(label_copy, BTRFS_LABEL_SIZE);
 	if (len == BTRFS_LABEL_SIZE) {
 		pr_warn("btrfs: label is too long, return the first %zu bytes\n",
 			--len);
 	}
 
-	mutex_lock(&root->fs_info->volume_mutex);
-	ret = copy_to_user(arg, label, len);
-	mutex_unlock(&root->fs_info->volume_mutex);
+	ret = copy_to_user(arg, label_copy, len);
 
 	return ret ? -EFAULT : 0;
 }
@@ -4082,7 +4086,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	mutex_lock(&root->fs_info->volume_mutex);
+	mutex_lock(&uuid_mutex);
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
@@ -4093,7 +4097,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 	ret = btrfs_end_transaction(trans, root);
 
 out_unlock:
-	mutex_unlock(&root->fs_info->volume_mutex);
+	mutex_unlock(&uuid_mutex);
 	mnt_drop_write_file(file);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 557a743..a5b3eb3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -49,7 +49,6 @@ static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 
-static DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
 
 static void lock_chunks(struct btrfs_root *root)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8670558..7855ef9 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -26,6 +26,7 @@
 
 #define BTRFS_STRIPE_LEN	(64 * 1024)
 
+static DEFINE_MUTEX(uuid_mutex);
 struct buffer_head;
 struct btrfs_pending_bios {
 	struct bio *head;
-- 
1.8.1.227.g44fe835

