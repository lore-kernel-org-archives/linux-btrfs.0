Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39489 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdJTGaR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 02:30:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AA9ECADE2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 06:30:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3] btrfs: Fix transaction abort during failure in btrfs_rm_dev_item
Date: Fri, 20 Oct 2017 09:30:13 +0300
Message-Id: <1508481013-16074-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20171019115457.GI3521@twin.jikos.cz>
References: <20171019115457.GI3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rm_dev_item calls several function under an activa transaction, however
it fails to abort it if an error happens. Fix this by adding explicit
btrfs_abort_transaction/btrfs_end_transaction calls

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V3:
 * The path needs to be freed before the the transaction is comitted otherwise 
 we will deadlock.

 fs/btrfs/volumes.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b39737568c22..4de498817e8a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1765,20 +1765,32 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
 	key.offset = device->devid;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
 		goto out;
+	}
 
 	if (ret > 0) {
 		ret = -ENOENT;
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
 		goto out;
 	}
 
 	ret = btrfs_del_item(trans, root, path);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
 		goto out;
+	}
+
+	btrfs_free_path(path);
+	ret = btrfs_commit_transaction(trans);
+	return ret;
+
 out:
 	btrfs_free_path(path);
-	btrfs_commit_transaction(trans);
 	return ret;
 }
 
-- 
2.7.4

