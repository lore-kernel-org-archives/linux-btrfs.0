Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54316 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3IKN6m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 09:58:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 137889A069A
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:58:42 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id zMye1xh4lxCStxB6 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:58:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check roots last log commit when checking if an inode has been logged
Date: Wed, 11 Sep 2013 09:58:39 -0400
Message-ID: <1378907919-4538-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu introduced a local copy of the last log commit for an inode to make sure we
actually log an inode even if a log commit has already taken place.  In order to
make sure we didn't relog the same inode multiple times he set this local copy
to the current trans when we log the inode, because usually we log the inode and
then sync the log.  The exception to this is during rename, we will relog an
inode if the name changed and it is already in the log.  The problem with this
is then we go to sync the inode, and our check to see if the inode has already
been logged is tripped and we don't sync the log.  To fix this we need to _also_
check against the roots last log commit, because it could be less than what is
in our local copy of the log commit.  This fixes a bug where we rename a file
into a directory and then fsync the directory and then on remount the directory
is no longer there.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/btrfs_inode.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d0ae226..71f074e 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -213,7 +213,10 @@ static inline bool btrfs_is_free_space_inode(struct inode *inode)
 static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 {
 	if (BTRFS_I(inode)->logged_trans == generation &&
-	    BTRFS_I(inode)->last_sub_trans <= BTRFS_I(inode)->last_log_commit)
+	    BTRFS_I(inode)->last_sub_trans <=
+	    BTRFS_I(inode)->last_log_commit &&
+	    BTRFS_I(inode)->last_sub_trans <=
+	    BTRFS_I(inode)->root->last_log_commit)
 		return 1;
 	return 0;
 }
-- 
1.7.7.6

