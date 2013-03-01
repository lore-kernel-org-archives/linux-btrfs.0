Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50994 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3CASaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 13:30:15 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 343279A067A
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Mar 2013 11:30:15 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id AyGZcujpJGo3jaWe (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2013 11:30:14 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use set_nlink if our i_nlink is 0
Date: Fri, 1 Mar 2013 13:37:22 -0500
Message-ID: <1362163042-16514-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to inc the nlink of deleted entries when running replay so we can do the
unlink on the fs_root and get everything cleaned up and then have the orphan
cleanup do the right thing.  The problem is inc_nlink complains about this, even
thought it still does the right thing.  So use set_nlink() if our i_nlink is 0
to keep users from seeing the warnings during log replay.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c7ef569..451fad9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1382,7 +1382,10 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 	if (ret == 0) {
-		btrfs_inc_nlink(inode);
+		if (!inode->i_nlink)
+			set_nlink(inode, 1);
+		else
+			btrfs_inc_nlink(inode);
 		ret = btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;
-- 
1.7.7.6

