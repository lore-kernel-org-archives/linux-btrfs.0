Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:48744 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752188AbeCVBUx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 21:20:53 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2] Btrfs: replace: cache rbio when rebuild data on missing device
Date: Thu, 22 Mar 2018 09:20:11 +0800
Message-Id: <1521681611-108404-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <20180302231041.10442-2-bo.li.liu@oracle.com>
References: <20180302231041.10442-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rebuild on missing device is as same as recover, after it's done, rbio
has data which is consistent with on-disk data, so it can be cached to
avoid further reads.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v2: Add comments to explain why REBUILD needs to be merged.

 fs/btrfs/raid56.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index fcfc20de2df3..154318249265 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1987,7 +1987,13 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	kfree(pointers);
 
 cleanup_io:
-	if (rbio->operation == BTRFS_RBIO_READ_REBUILD) {
+	/*
+	 * Similar to READ_REBUILD, REBUILD_MISSING at this point also has a
+	 * valid rbio which is consistent with ondisk content, thus such a valid
+	 * rbio can be cached to avoid further disk reads.
+	 */
+	if (rbio->operation == BTRFS_RBIO_READ_REBUILD ||
+	    rbio->operation == BTRFS_RBIO_REBUILD_MISSING) {
 		/*
 		 * - In case of two failures, where rbio->failb != -1:
 		 *
@@ -2008,8 +2014,6 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		else
 			clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
 
-		rbio_orig_end_io(rbio, err);
-	} else if (rbio->operation == BTRFS_RBIO_REBUILD_MISSING) {
 		rbio_orig_end_io(rbio, err);
 	} else if (err == BLK_STS_OK) {
 		rbio->faila = -1;
-- 
2.14.1.40.g8e62ba1

