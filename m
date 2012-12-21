Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:39117 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab2LUUzv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 15:55:51 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id AjFpPgL1TueFc2GC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 13:55:49 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: overwrite existing csums when logging
Date: Fri, 21 Dec 2012 16:02:10 -0500
Message-ID: <1356123730-19510-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Users were complaining about the warning in btrfs_log_parent_inode() because
we're returning -EEXIST.  This warning is gone in another patch but it's
still making us commit a transaction when we don't have to.  Basically
because we will log all csums in an ordered extent for an em we have the
chance of logging the same csums multiple times.  Since it's not that big of
a deal just allow csums to be over written in logs and that way we are safe.
This gets rid of the EEXIST and we log like we normally would.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file-item.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index bd38cef..93ddc2e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -835,6 +835,13 @@ insert:
 	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
 				      ins_size);
 	path->leave_spinning = 0;
+
+	/*
+	 * We can sometimes already have copied a csum into the log, that's ok
+	 * just overwrite it.
+	 */
+	if (root->objectid == BTRFS_TREE_LOG_OBJECTID && ret == -EEXIST)
+		ret = 0;
 	if (ret < 0)
 		goto fail_unlock;
 	if (ret != 0) {
-- 
1.7.7.6

