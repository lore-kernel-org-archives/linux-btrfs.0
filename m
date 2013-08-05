Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48152 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3HEAZe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 20:25:34 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so1984545wes.31
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 17:25:33 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't ignore errors from btrfs_run_delayed_items
Date: Mon,  5 Aug 2013 01:25:26 +0100
Message-Id: <1375662326-23444-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree-log.c was ignoring the return value from btrfs_run_delayed_items()
in several places.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tree-log.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ff60d89..f919f26 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -747,7 +747,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	ret = btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
 	if (ret)
 		goto out;
-	btrfs_run_delayed_items(trans, root);
+	else
+		ret = btrfs_run_delayed_items(trans, root);
 out:
 	kfree(name);
 	iput(inode);
@@ -923,7 +924,9 @@ again:
 				kfree(victim_name);
 				if (ret)
 					return ret;
-				btrfs_run_delayed_items(trans, root);
+				ret = btrfs_run_delayed_items(trans, root);
+				if (ret)
+					return ret;
 				*search_done = 1;
 				goto again;
 			}
@@ -990,7 +993,8 @@ again:
 								 inode,
 								 victim_name,
 								 victim_name_len);
-					btrfs_run_delayed_items(trans, root);
+					if (!ret)
+						ret = btrfs_run_delayed_items(trans, root);
 				}
 				iput(victim_parent);
 				kfree(victim_name);
@@ -1810,7 +1814,7 @@ again:
 			ret = btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
 			if (!ret)
-				btrfs_run_delayed_items(trans, root);
+				ret = btrfs_run_delayed_items(trans, root);
 			kfree(name);
 			iput(inode);
 			if (ret)
-- 
1.7.9.5

