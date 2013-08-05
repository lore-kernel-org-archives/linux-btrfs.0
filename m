Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55654 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3HEI0B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Aug 2013 04:26:01 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so2189498wgh.29
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 01:25:59 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: don't ignore errors from btrfs_run_delayed_items
Date: Mon,  5 Aug 2013 09:25:47 +0100
Message-Id: <1375691147-10428-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375662326-23444-1-git-send-email-fdmanana@gmail.com>
References: <1375662326-23444-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree-log.c was ignoring the return value from btrfs_run_delayed_items()
in several places.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Ensure no line exceeds 80 characters.

 fs/btrfs/tree-log.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ff60d89..f90ae35 100644
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
@@ -990,7 +993,9 @@ again:
 								 inode,
 								 victim_name,
 								 victim_name_len);
-					btrfs_run_delayed_items(trans, root);
+					if (!ret)
+						ret = btrfs_run_delayed_items(
+								  trans, root);
 				}
 				iput(victim_parent);
 				kfree(victim_name);
@@ -1810,7 +1815,7 @@ again:
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

