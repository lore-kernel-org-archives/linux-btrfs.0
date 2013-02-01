Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:39069 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673Ab3BAU6o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 15:58:44 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id dQU5t3yDdITY480y (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2013 13:58:43 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: account for orphan inodes properly during cleanup
Date: Fri, 1 Feb 2013 16:05:17 -0500
Message-ID: <1359752717-13540-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave sent me a panic where we were doing the orphan cleanup and panic'ed
trying to release our reservation from the orphan block rsv.  The reason for
this is because our orphan block rsv had been free'd out from underneath us
because the transaction commit found that there were no orphan inodes
according to its count and decided to free it.  This is incorrect so make
sure we inc the orphan inodes count so the accounting is all done properly.
This would also cause the warning in the orphan commit code normally if you
had any orphans to cleanup as they would only decrement the orphan count so
you'd get a negative orphan count which could cause problems during runtime.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 804a34b..5398883 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2502,6 +2502,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 */
 		set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			&BTRFS_I(inode)->runtime_flags);
+		atomic_inc(&root->orphan_inodes);
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
-- 
1.7.7.6

