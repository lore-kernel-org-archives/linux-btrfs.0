Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43238 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaETGeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 02:34:05 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: sandeen@redhat.com, rm@romanrm.net
Subject: [PATCH 1/2 v2] btrfs: label should not contain return char
Date: Tue, 20 May 2014 14:36:48 +0800
Message-Id: <1400567808-9494-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

generally if you use
  echo "test" > /sys/fs/btrfs/<fsid>/label
it would introduce return char at the end and it can not
be part of the label. The correct command is
  echo -n "test" > /sys/fs/btrfs/<fsid>/label

This patch will check for this user error

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 v2: accepts review comments. Thanks Eric and Roman

 fs/btrfs/sysfs.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c5eb214..ca63fcd 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -373,22 +373,36 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = fs_info->fs_root;
 	int ret;
+	char *label;
+	char *pos;
 
-	if (len >= BTRFS_LABEL_SIZE) {
+	label = kzalloc(len, GFP_NOFS);
+	if (!label)
+		return -ENOMEM;
+
+	memcpy(label, buf, len);
+	if ((pos = strchr(label, '\n')))
+		*pos = '\0';
+
+	if (strlen(label) >= BTRFS_LABEL_SIZE) {
 		pr_err("BTRFS: unable to set label with more than %d bytes\n",
 		       BTRFS_LABEL_SIZE - 1);
+		kfree(label);
 		return -EINVAL;
 	}
 
 	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		kfree(label);
 		return PTR_ERR(trans);
+	}
 
 	spin_lock(&root->fs_info->super_lock);
-	strcpy(fs_info->super_copy->label, buf);
+	strcpy(fs_info->super_copy->label, label);
 	spin_unlock(&root->fs_info->super_lock);
 	ret = btrfs_commit_transaction(trans, root);
 
+	kfree(label);
 	if (!ret)
 		return len;
 
-- 
1.7.1

