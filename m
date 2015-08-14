Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbbHNKdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:49 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 17/23] Btrfs: kernel operation should come after user input has been verified
Date: Fri, 14 Aug 2015 18:33:02 +0800
Message-Id: <1439548388-29686-18-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By general rule of thumb there shouldn't be any way that user land
could trigger a kernel operation just by sending wrong arguments.

Here do commit cleanups after user input has been verified.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 673a2c3..937e53b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -325,19 +325,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	    args->start.tgtdev_name[0] == '\0')
 		return -EINVAL;
 
-	/*
-	 * Here we commit the transaction to make sure commit_total_bytes
-	 * of all the devices are updated.
-	 */
-	trans = btrfs_attach_transaction(root);
-	if (!IS_ERR(trans)) {
-		ret = btrfs_commit_transaction(trans, root);
-		if (ret)
-			return ret;
-	} else if (PTR_ERR(trans) != -ENOENT) {
-		return PTR_ERR(trans);
-	}
-
 	/* the disk copy procedure reuses the scrub code */
 	mutex_lock(&fs_info->volume_mutex);
 	ret = btrfs_find_device_by_user_input(root, args->start.srcdevid,
@@ -354,6 +341,19 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	if (ret)
 		return ret;
 
+	/*
+	 * Here we commit the transaction to make sure commit_total_bytes
+	 * of all the devices are updated.
+	 */
+	trans = btrfs_attach_transaction(root);
+	if (!IS_ERR(trans)) {
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret)
+			return ret;
+	} else if (PTR_ERR(trans) != -ENOENT) {
+		return PTR_ERR(trans);
+	}
+
 	btrfs_dev_replace_lock(dev_replace);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
-- 
2.4.1

