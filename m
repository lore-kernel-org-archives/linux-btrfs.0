Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54936 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751329AbdJSBtd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 21:49:33 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <hch@lst.de>, Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH v2] btrfs: Fix bug for misused dev_t when lookup in dev state hash table.
Date: Thu, 19 Oct 2017 09:49:27 +0800
Message-ID: <1508377767-61647-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

Fix bug of commit 74d46992e0d9
("block: replace bi_bdev with a gendisk pointer and partitions index").

In this modify, use bio_dev(bio) to find dev state in function
__btrfsic_submit_bio. But when dev_state added to hashtable, it is using
dev_t of block_device.

bio_dev(bio) returns a dev_t of part0 which is different from dev_t in
block_device(bd_dev). bd_dev in block_device represents the exact
partition.
block_device.bd_dev = 
	bio->bi_partno (same as block_device.bd_partno) + bio_dev(bio).

When add a dev_state into hashtable it is using the exact partition's dev_t.
So when lookup it, it should also use the exact partition's dev_t.

Reproduce of this bug:
Use MOUNT_OPTIONS="-o check_int" when run btrfs/001 in xfstest.
Then there will be WARNING like below.
WARNING:
btrfs: attempt to write superblock which references block M @29523968 (sda7     /1111654400/2) which is never written!

changelog:
v1->v2: Add explanation that bio_dev(bio) is different with block_device(bd_dev).

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/check-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index fb07e3c22b9a..02f9eb83173f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2803,7 +2803,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 	mutex_lock(&btrfsic_mutex);
 	/* since btrfsic_submit_bio() is also called before
 	 * btrfsic_mount(), this might return NULL */
-	dev_state = btrfsic_dev_state_lookup(bio_dev(bio));
+	dev_state = btrfsic_dev_state_lookup(bio_dev(bio) + bio->bi_partno);
 	if (NULL != dev_state &&
 	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
 		unsigned int i = 0;
-- 
2.13.5



