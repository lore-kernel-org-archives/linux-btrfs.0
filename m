Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49020 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2KEMnm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2012 07:43:42 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qA5ChepQ022335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Nov 2012 12:43:41 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qA5ChePU019713
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Nov 2012 12:43:40 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qA5Chdu6025494
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Nov 2012 06:43:39 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix a double free on pending snapshots in error handling
Date: Mon,  5 Nov 2012 20:42:09 +0800
Message-Id: <1352119329-18716-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com>
References: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When creating a snapshot, failing to commit a transaction can end up
with aborting the transaction, following by doing a cleanup for it, where
we'll free all snapshots pending to disk.

So we check it and avoid double free on pending snapshots.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8fcf9a5..4e1a1ce 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -571,8 +571,12 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 		ret = btrfs_commit_transaction(trans,
 					       root->fs_info->extent_root);
 	}
-	if (ret)
+	if (ret) {
+		/* cleanup_transaction has freed this for us */
+		if (trans->aborted)
+			pending_snapshot = NULL;
 		goto fail;
+	}
 
 	ret = pending_snapshot->error;
 	if (ret)
-- 
1.7.7.6

