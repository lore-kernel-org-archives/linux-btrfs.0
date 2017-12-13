Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbdLMIZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 03:25:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1EC79AD1C
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 08:25:46 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/4] btrfs: Remove redundant bio_get/set from submit_dio_repair_bio
Date: Wed, 13 Dec 2017 10:25:38 +0200
Message-Id: <1513153540-10737-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1513153540-10737-1-git-send-email-nborisov@suse.com>
References: <1513153540-10737-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bio that is passsed is the newly created repair bio which already
has a reference count of 1, which is going to be consumed by the
endio routine on successful submission. On error the handler also
calls bio_put.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9ad8c9321c8f..6d2fe773d479 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7941,15 +7941,12 @@ static inline blk_status_t submit_dio_repair_bio(struct inode *inode,
 
 	BUG_ON(bio_op(bio) == REQ_OP_WRITE);
 
-	bio_get(bio);
-
 	ret = btrfs_bio_wq_end_io(fs_info, bio, BTRFS_WQ_ENDIO_DIO_REPAIR);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = btrfs_map_bio(fs_info, bio, mirror_num, 0);
-err:
-	bio_put(bio);
+
 	return ret;
 }
 
-- 
2.7.4

