Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751010AbdHCMpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 08:45:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6AE43AB22
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Aug 2017 12:45:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Move skip checksum check from btrfs_submit_direct to __btrfs_submit_dio_bio
Date: Thu,  3 Aug 2017 15:44:58 +0300
Message-Id: <1501764298-24522-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the code checks whether we should do data checksumming in
btrfs_submit_direct and the boolean result of this check is passed to
btrfs_submit_direct_hook, in turn passing it to __btrfs_submit_dio_bio which
actually consumes it. The last function actually has all the necessary context
to figure out whether to skip the check or not, so let's move the check closer
to where it's being consumed. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5e48d2c10152..a8bd0f951454 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8424,8 +8424,7 @@ static inline blk_status_t btrfs_lookup_and_bind_dio_csum(struct inode *inode,
 }
 
 static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
-					 u64 file_offset, int skip_sum,
-					 int async_submit)
+					 u64 file_offset, int async_submit)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_dio_private *dip = bio->bi_private;
@@ -8443,7 +8442,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 			goto err;
 	}
 
-	if (skip_sum)
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		goto map;
 
 	if (write && async_submit) {
@@ -8473,8 +8472,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 	return ret;
 }
 
-static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
-				    int skip_sum)
+static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 {
 	struct inode *inode = dip->inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -8537,7 +8535,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 		 */
 		atomic_inc(&dip->pending_bios);
 
-		ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
+		ret = __btrfs_submit_dio_bio(bio, inode, file_offset,
 					     async_submit);
 		if (ret) {
 			bio_put(bio);
@@ -8557,8 +8555,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	} while (submit_len > 0);
 
 submit:
-	ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
-				     async_submit);
+	ret = __btrfs_submit_dio_bio(bio, inode, file_offset, async_submit);
 	if (!ret)
 		return 0;
 
@@ -8583,12 +8580,9 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	struct btrfs_dio_private *dip = NULL;
 	struct bio *bio = NULL;
 	struct btrfs_io_bio *io_bio;
-	int skip_sum;
 	bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
 	int ret = 0;
 
-	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
-
 	bio = btrfs_bio_clone(dio_bio);
 
 	dip = kzalloc(sizeof(*dip), GFP_NOFS);
@@ -8631,7 +8625,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 			dio_data->unsubmitted_oe_range_end;
 	}
 
-	ret = btrfs_submit_direct_hook(dip, skip_sum);
+	ret = btrfs_submit_direct_hook(dip);
 	if (!ret)
 		return;
 
-- 
2.7.4

