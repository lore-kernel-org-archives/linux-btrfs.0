Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18625 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932433AbdKBAWk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 20:22:40 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA20MdYG015581
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 00:22:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA20MdGf031935
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 00:22:39 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA20MdD3004086
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 00:22:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: document rules about bio async submit
Date: Wed,  1 Nov 2017 17:19:27 -0600
Message-Id: <20171101231927.4399-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These rules have been hidden in several if-else and are not
straightforward to follow, for example, dio submit hook's nocsum case
has a bug , i.e. doing async submit instead of sync submit, which has
been fixed recently.

This is documenting the rules for reference.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e9a827b..9a2bdd9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1962,7 +1962,21 @@ static blk_status_t __btrfs_submit_bio_done(void *private_data, struct bio *bio,
 
 /*
  * extent_io.c submission hook. This does the right thing for csum calculation
- * on write, or reading the csums from the tree before a read
+ * on write, or reading the csums from the tree before a read.
+ *
+ * Rules about async/sync submit,
+ * a) read:				sync submit
+ *
+ * b) write without checksum:		sync submit
+ *
+ * c) write with checksum:
+ *    c-1) if bio is issued by fsync:	sync submit
+ *         (sync_writers != 0)
+ *
+ *    c-2) if root is reloc root:	sync submit
+ *         (only in case of buffered IO)
+ *
+ *    c-3) otherwise:			async submit
  */
 static blk_status_t btrfs_submit_bio_hook(void *private_data, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
@@ -8549,6 +8563,7 @@ __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode, u64 file_offset,
 	bool write = bio_op(bio) == REQ_OP_WRITE;
 	blk_status_t ret;
 
+	/* Check btrfs_submit_bio_hook() for rules about async submit. */
 	if (async_submit)
 		async_submit = !atomic_read(&BTRFS_I(inode)->sync_writers);
 
-- 
2.9.4

