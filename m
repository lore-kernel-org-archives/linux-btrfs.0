Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdLMIZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 03:25:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A95D7AD72
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 08:25:46 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs: Remove redundant pair of bio_get/set in __btrfs_submit_dio_bio
Date: Wed, 13 Dec 2017 10:25:40 +0200
Message-Id: <1513153540-10737-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1513153540-10737-1-git-send-email-nborisov@suse.com>
References: <1513153540-10737-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bio is not referenced after it has been submitted and the endio is
going to consume the sole reference on successful submission. On error,
the callers of __btrfs_submit_dio_bio do invoke bio_put so we don't
leak it either.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6d2fe773d479..692dbd2fc239 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8449,8 +8449,6 @@ __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode, u64 file_offset,
 	if (async_submit)
 		async_submit = !atomic_read(&BTRFS_I(inode)->sync_writers);
 
-	bio_get(bio);
-
 	if (!write) {
 		ret = btrfs_bio_wq_end_io(fs_info, bio, BTRFS_WQ_ENDIO_DATA);
 		if (ret)
@@ -8483,7 +8481,6 @@ __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode, u64 file_offset,
 map:
 	ret = btrfs_map_bio(fs_info, bio, 0, 0);
 err:
-	bio_put(bio);
 	return ret;
 }
 
-- 
2.7.4

