Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43111 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbdJWG6u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 02:58:50 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC426AAA3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 06:58:48 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4] btrfs: Fix transaction abort during failure in btrfs_rm_dev_item
Date: Mon, 23 Oct 2017 09:58:46 +0300
Message-Id: <1508741926-27125-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1508481013-16074-1-git-send-email-nborisov@suse.com>
References: <1508481013-16074-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rm_dev_item calls several function under an activa transaction, however
it fails to abort it if an error happens. Fix this by adding explicit
btrfs_abort_transaction/btrfs_end_transaction calls

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
V4:
 * Reorder the code a bit to prevent duplication of btrfs_free_path 
 invocation. 

 * Collapse the handling of btrfs_search_slot return value in a single if
 branch rather than having it spread across 2 branches 

V3:
 * The path needs to be freed before the the transaction is comitted otherwise 
  we will deadlock.
 fs/btrfs/volumes.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..8b139d203f8c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1765,20 +1765,24 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
 	key.offset = device->devid;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret < 0)
-		goto out;
-
-	if (ret > 0) {
-		ret = -ENOENT;
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
 		goto out;
 	}
 
 	ret = btrfs_del_item(trans, root, path);
-	if (ret)
-		goto out;
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
+	}
+
 out:
 	btrfs_free_path(path);
-	btrfs_commit_transaction(trans);
+	if (!ret)
+		ret = btrfs_commit_transaction(trans);
 	return ret;
 }
 
-- 
2.7.4

