Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaEVKi1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 06:38:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com, rm@romanrm.net
Subject: [PATCH 1/2 v3] btrfs: label should not contain return char
Date: Thu, 22 May 2014 18:41:11 +0800
Message-Id: <1400755272-22590-1-git-send-email-anand.jain@oracle.com>
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
 v3: accepts review comments. Thanks David and Eric again
 v2: accepts review comments. Thanks Eric and Roman

 fs/btrfs/sysfs.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c5eb214..159df4f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -373,8 +373,15 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = fs_info->fs_root;
 	int ret;
+	size_t p_len;
 
-	if (len >= BTRFS_LABEL_SIZE) {
+	/*
+	 * p_len is the len until the first occurrence of either
+	 * '\n' or '\0'
+	 */
+	p_len = strcspn(buf, "\n");
+
+	if (p_len >= BTRFS_LABEL_SIZE) {
 		pr_err("BTRFS: unable to set label with more than %d bytes\n",
 		       BTRFS_LABEL_SIZE - 1);
 		return -EINVAL;
@@ -385,7 +392,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 		return PTR_ERR(trans);
 
 	spin_lock(&root->fs_info->super_lock);
-	strcpy(fs_info->super_copy->label, buf);
+	strncpy(fs_info->super_copy->label, buf, p_len);
+	memset(fs_info->super_copy->label + p_len, '\0', 1);
 	spin_unlock(&root->fs_info->super_lock);
 	ret = btrfs_commit_transaction(trans, root);
 
-- 
1.7.1

