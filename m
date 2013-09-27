Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56425 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3I0TAt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 15:00:49 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2285F7C042D
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 13:00:49 -0600 (MDT)
Received: from CAS2.int.fusionio.com ([10.101.1.41]) by mx1.fusionio.com with ESMTP id QrqpxvUGi0CqVOzw (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 13:00:48 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not release metadata for space cache inodes
Date: Fri, 27 Sep 2013 15:00:46 -0400
Message-ID: <1380308446-1252-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been testing our error paths and I was tripping the BUG_ON() in
drop_outstanding_extent because our outstanding_extents is 0 for space cache
inodes.  This is because we don't reserve metadata space for these inodes since
we depend on the global block reserve for our space.  To fix this we need to
make sure the DO_ACCOUNTING stuff doesn't actually call release_metadata for
space cache inodes.  With this patch I'm no longer panicing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c462bd1..e6a0079 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1551,7 +1551,13 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			spin_unlock(&BTRFS_I(inode)->lock);
 		}
 
-		if (*bits & EXTENT_DO_ACCOUNTING)
+		/*
+		 * We don't reserve metadata space for space cache inodes so we
+		 * don't need to call dellalloc_release_metadata if there is an
+		 * error.
+		 */
+		if (*bits & EXTENT_DO_ACCOUNTING &&
+		    root != root->fs_info->tree_root)
 			btrfs_delalloc_release_metadata(inode, len);
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
-- 
1.8.3.1

