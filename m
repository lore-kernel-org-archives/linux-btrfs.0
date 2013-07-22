Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50199 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3GVQ4E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 12:56:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8D67C9A0405
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 10:56:03 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id HnLVPOEPzYsqnkb6 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 10:56:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: release both paths before logging dir/changed extents
Date: Mon, 22 Jul 2013 12:56:00 -0400
Message-ID: <1374512160-1888-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ceph guys tripped over this bug where we were still holding onto the
original path that we used to copy the inode with when logging.  This is based
on Chris's fix which was reported to fix the problem.  We need to drop the paths
in two cases anyway so just move the drop up so that we don't have duplicate
code.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2c67914..ff60d89 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3746,8 +3746,9 @@ next_slot:
 	}
 
 log_extents:
+	btrfs_release_path(path);
+	btrfs_release_path(dst_path);
 	if (fast_search) {
-		btrfs_release_path(dst_path);
 		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
 		if (ret) {
 			err = ret;
@@ -3764,8 +3765,6 @@ log_extents:
 	}
 
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-		btrfs_release_path(path);
-		btrfs_release_path(dst_path);
 		ret = log_directory_changes(trans, root, inode, path, dst_path);
 		if (ret) {
 			err = ret;
-- 
1.7.7.6

