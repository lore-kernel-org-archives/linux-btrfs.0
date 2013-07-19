Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44909 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759890Ab3GSJe0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jul 2013 05:34:26 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6J9YP9m006432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jul 2013 09:34:26 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6J9YOeu023105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jul 2013 09:34:25 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6J9YODQ002628
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jul 2013 09:34:24 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix get set label blocking against balance
Date: Fri, 19 Jul 2013 17:39:32 +0800
Message-Id: <1374226772-13463-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1374146298-30789-1-git-send-email-anand.jain@oracle.com>
References: <1374146298-30789-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_ioctl_get_fslabel() and btrfs_ioctl_set_fslabel()
used root->fs_info->volume_mutex mutex which caused operations
like balance to block set/get label operation until its
completion and generally balance operation takes a long
time to complete, so it will be annoying to the user when
cli appears hung

also this patch will add a bit of optimization within
the btrfs_ioctl_get_falabel() function.

v1->v2:
   use fs_info->super_lock instead of uuid_mutex

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2177bea..9a864f1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4042,18 +4042,22 @@ out:
 static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
-	const char *label = root->fs_info->super_copy->label;
-	size_t len = strnlen(label, BTRFS_LABEL_SIZE);
+	size_t len;
 	int ret;
+	char label[BTRFS_LABEL_SIZE];
+
+	spin_lock(&root->fs_info->super_lock);
+	memcpy(label, root->fs_info->super_copy->label, BTRFS_LABEL_SIZE);
+	spin_unlock(&root->fs_info->super_lock);
+
+	len = strnlen(label, BTRFS_LABEL_SIZE);
 
 	if (len == BTRFS_LABEL_SIZE) {
 		pr_warn("btrfs: label is too long, return the first %zu bytes\n",
 			--len);
 	}
 
-	mutex_lock(&root->fs_info->volume_mutex);
 	ret = copy_to_user(arg, label, len);
-	mutex_unlock(&root->fs_info->volume_mutex);
 
 	return ret ? -EFAULT : 0;
 }
@@ -4082,18 +4086,18 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	mutex_lock(&root->fs_info->volume_mutex);
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_unlock;
 	}
 
+	spin_lock(&root->fs_info->super_lock);
 	strcpy(super_block->label, label);
+	spin_unlock(&root->fs_info->super_lock);
 	ret = btrfs_end_transaction(trans, root);
 
 out_unlock:
-	mutex_unlock(&root->fs_info->volume_mutex);
 	mnt_drop_write_file(file);
 	return ret;
 }
-- 
1.8.1.227.g44fe835

