Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47527 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab3KMBzu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 20:55:50 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 47D3D9A06C3
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 18:55:50 -0700 (MST)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id lDnq7pNZ8AfuSDOD (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 18:55:49 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: only drop modified extents if we logged the whole inode
Date: Tue, 12 Nov 2013 20:55:47 -0500
Message-ID: <1384307747-2666-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fsync, seek and write, rename and then fsync again we will lose the
modified hole extent because the rename will drop all of the modified extents
since we didn't do the fast search.  We need to only drop the modified extents
if we didn't do the fast search and we were logging the entire inode as we don't
need them anymore, otherwise this is being premature.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ba1c685..e7d7a83 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3954,7 +3954,7 @@ log_extents:
 			err = ret;
 			goto out_unlock;
 		}
-	} else {
+	} else if (inode_only == LOG_INODE_ALL) {
 		struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
 		struct extent_map *em, *n;
 
-- 
1.8.3.1

