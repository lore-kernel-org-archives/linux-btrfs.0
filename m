Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44021 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3IKNim (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 09:38:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4EF357C0423
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:38:42 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id L7kRDdlaXoSIEdYz (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:38:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: actually log directory we are fsync()'ing
Date: Wed, 11 Sep 2013 09:38:39 -0400
Message-ID: <1378906719-3248-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you just create a directory and then fsync that directory and then pull the
power plug you will come back up and the directory will not be there.  That is
because we won't actually create directories if we've logged files inside of
them since they will be created on replay, but in this check we will set our
logged_trans of our current directory if it happens to be a directory, making us
think it doesn't need to be logged.  Fix the logic to only do this to parent
directories.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0d9613c..aaa2e2b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3805,6 +3805,7 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	struct btrfs_root *root;
 	struct dentry *old_parent = NULL;
+	struct inode *orig_inode = inode;
 
 	/*
 	 * for regular files, if its inode is already on disk, we don't
@@ -3824,7 +3825,14 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 	}
 
 	while (1) {
-		BTRFS_I(inode)->logged_trans = trans->transid;
+		/*
+		 * If we are logging a directory then we start with our inode,
+		 * not our parents inode, so we need to skipp setting the
+		 * logged_trans so that further down in the log code we don't
+		 * think this inode has already been logged.
+		 */
+		if (inode != orig_inode)
+			BTRFS_I(inode)->logged_trans = trans->transid;
 		smp_mb();
 
 		if (BTRFS_I(inode)->last_unlink_trans > last_committed) {
-- 
1.7.7.6

