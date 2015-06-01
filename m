Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17207 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbbFAGQm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 02:16:42 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t516GfUa009468
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:16:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t516Gfkf023204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:16:41 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t516GfDw032123
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:16:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs: kernel operation should come after user input has been verified
Date: Mon,  1 Jun 2015 14:16:17 +0800
Message-Id: <1433139379-640-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1433139379-640-1-git-send-email-anand.jain@oracle.com>
References: <1433139379-640-1-git-send-email-anand.jain@oracle.com>
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
index fe30c9a..ff1ef57 100644
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

