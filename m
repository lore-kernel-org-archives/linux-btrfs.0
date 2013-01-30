Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:45789 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab3A3TVq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 14:21:46 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 0LFM1Fpq5wpVDBYR (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 12:21:46 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix missing i_size update
Date: Wed, 30 Jan 2013 14:28:34 -0500
Message-ID: <1359574114-1804-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have an ordered extent before the ordered extent we are currently
completing that is after the current disk_i_size we will put our i_size
update into that ordered extent so that we do not expose stale data.  The
problem is that if our disk i_size is updated past the previous ordered
extent we won't update the i_size with the pending i_size update.  So check
the pending i_size update and if its above the current disk i_size we need
to go ahead and try to update.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ordered-data.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index cbd4838..c447e4c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -895,9 +895,16 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	 * if the disk i_size is already at the inode->i_size, or
 	 * this ordered extent is inside the disk i_size, we're done
 	 */
-	if (disk_i_size == i_size || offset <= disk_i_size) {
+	if (disk_i_size == i_size)
+		goto out;
+
+	/*
+	 * We still need to update disk_i_size if outstanding_isize is greater
+	 * than disk_i_size.
+	 */
+	if (offset <= disk_i_size &&
+	    (!ordered || ordered->outstanding_isize < disk_i_size))
 		goto out;
-	}
 
 	/*
 	 * walk backward from this ordered extent to disk_i_size.
-- 
1.7.7.6

