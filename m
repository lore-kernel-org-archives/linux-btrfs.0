Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45963 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752539AbdI1Ipb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 04:45:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 898F2AAC8
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 08:45:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 2/2] btrfs: Fix transaction abort during failure in btrfs_rm_dev_item
Date: Thu, 28 Sep 2017 11:45:27 +0300
Message-Id: <1506588327-6616-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1506588327-6616-1-git-send-email-nborisov@suse.com>
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
 <1506588327-6616-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rm_dev_item calls several function under an activa transaction, however
it fails to abort it if an error happens. Fix this by adding explicit
btrfs_abort_transaction/btrfs_end_transaction calls

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

v2: 
 * Explicitly handle every failure case w.r.t transaction abort rather than 
 rely on final btrfs_commit_transaction() to do the right thing. 

 * Also consider the -ENOENT case from btrfs_search_slot as a failure.

 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..4709c7919ef2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1765,20 +1765,29 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
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
+	ret = btrfs_commit_transaction(trans);
 out:
 	btrfs_free_path(path);
-	btrfs_commit_transaction(trans);
 	return ret;
 }
 
-- 
2.7.4

