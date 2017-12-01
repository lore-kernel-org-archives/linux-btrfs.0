Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751850AbdLAJTx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 04:19:53 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4BF9DAD76
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Dec 2017 09:19:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/5] btrfs: Greatly simplify btrfs_read_dev_super
Date: Fri,  1 Dec 2017 11:19:44 +0200
Message-Id: <1512119984-12708-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1512119984-12708-1-git-send-email-nborisov@suse.com>
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently this function executes the inner loop at most 1 due to the i = 0;
i < 1 condition. Furthermore, the btrfs_super_generation(super) > transid code
in the if condition is never executed due to latest always set to NULL hence the
first part of the condition always triggering. The gist of btrfs_read_dev_super
is really to read the first superblock.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 82c96607fc46..6d5f632fd1e7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3170,37 +3170,18 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 {
 	struct buffer_head *bh;
-	struct buffer_head *latest = NULL;
-	struct btrfs_super_block *super;
-	int i;
-	u64 transid = 0;
-	int ret = -EINVAL;
+	int ret;
 
 	/* we would like to check all the supers, but that would make
 	 * a btrfs mount succeed after a mkfs from a different FS.
 	 * So, we need to add a special mount option to scan for
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
-	for (i = 0; i < 1; i++) {
-		ret = btrfs_read_dev_one_super(bdev, i, &bh);
-		if (ret)
-			continue;
-
-		super = (struct btrfs_super_block *)bh->b_data;
-
-		if (!latest || btrfs_super_generation(super) > transid) {
-			brelse(latest);
-			latest = bh;
-			transid = btrfs_super_generation(super);
-		} else {
-			brelse(bh);
-		}
-	}
-
-	if (!latest)
+	ret = btrfs_read_dev_one_super(bdev, 0, &bh);
+	if (ret)
 		return ERR_PTR(ret);
 
-	return latest;
+	return bh;
 }
 
 /*
-- 
2.7.4

