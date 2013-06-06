Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53013 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3FFOc3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 10:32:29 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 147587C0434
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Jun 2013 08:32:29 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id g9rX4fi6tkiNhh5b (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 06 Jun 2013 08:32:28 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't delete fs_roots until after we cleanup the transaction
Date: Thu, 6 Jun 2013 10:32:26 -0400
Message-ID: <1370529146-13797-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We get a use after free if we had a transaction to cleanup since there could be
delayed inodes which refer to their respective fs_root.  Thanks

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 15f31c7..3c2886c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2887,8 +2887,8 @@ fail_qgroup:
 	btrfs_free_qgroup_config(fs_info);
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
-	del_fs_roots(fs_info);
 	btrfs_cleanup_transaction(fs_info->tree_root);
+	del_fs_roots(fs_info);
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
-- 
1.7.7.6

