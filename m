Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53091 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3JGTQE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 15:16:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id BD0D27C0690
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 13:16:03 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id XPH0zS4y0ORT9J9T (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 13:16:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: free up block groups after everything
Date: Mon, 7 Oct 2013 15:16:01 -0400
Message-ID: <1381173361-7048-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we abort a transaction we will do the tree log cleanup at unmount, but this
happens after we free up the block groups.  This makes all the leak detection
warnings go off because we think we've leaked space but in reality we just
haven't cleaned it up yet.  So instead do the block group cleanup stuff after
free'ing the fs roots so we don't get these warnings.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fdc75ab..419968e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3637,12 +3637,12 @@ int close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	btrfs_free_block_groups(fs_info);
-
 	btrfs_stop_all_workers(fs_info);
 
 	del_fs_roots(fs_info);
 
+	btrfs_free_block_groups(fs_info);
+
 	free_root_pointers(fs_info, 1);
 
 	iput(fs_info->btree_inode);
-- 
1.8.3.1

