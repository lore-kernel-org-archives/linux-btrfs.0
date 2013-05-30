Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35175 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab3E3U6U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 16:58:20 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E0AC39A0359
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 14:58:19 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id O6LYjpiYRUn5L5IM (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 14:58:19 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: stop all workers before cleaning up roots
Date: Thu, 30 May 2013 16:58:16 -0400
Message-ID: <1369947496-27707-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave reported a panic because the extent_root->commit_root was NULL in the
caching kthread.  That is because we just unset it in free_root_pointers, which
is not the correct thing to do, we have to either wait for the caching kthread
to complete or hold the extent_commit_sem lock so we know the thread has exited.
This patch makes the kthreads all stop first and then we do our cleanup.  This
should fix the race.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b53afd..77cb566 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3547,13 +3547,13 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_free_block_groups(fs_info);
 
-	free_root_pointers(fs_info, 1);
+	btrfs_stop_all_workers(fs_info);
 
 	del_fs_roots(fs_info);
 
-	iput(fs_info->btree_inode);
+	free_root_pointers(fs_info, 1);
 
-	btrfs_stop_all_workers(fs_info);
+	iput(fs_info->btree_inode);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
-- 
1.7.7.6

