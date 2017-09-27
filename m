Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52685 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752084AbdI0Ksx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 06:48:53 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6349DABB2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 10:48:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Fix transaction abort during failure in btrfs_rm_dev_item
Date: Wed, 27 Sep 2017 13:48:47 +0300
Message-Id: <1506509327-18862-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1506509327-18862-1-git-send-email-nborisov@suse.com>
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rm_dev_item calls several function under an activa transaction, however
it fails to abort it if an error happens. Fix this by adding respective
btrfs_abort_transaction calls

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..640fdd35ec85 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1765,8 +1765,10 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
 	key.offset = device->devid;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
 		goto out;
+	}
 
 	if (ret > 0) {
 		ret = -ENOENT;
@@ -1775,7 +1777,7 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_del_item(trans, root, path);
 	if (ret)
-		goto out;
+		btrfs_abort_transaction(trans, ret);
 out:
 	btrfs_free_path(path);
 	btrfs_commit_transaction(trans);
-- 
2.7.4

