Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:62008 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755795AbdJQLe5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 07:34:57 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <hch@lst.de>
CC: Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH] btrfs: Fix bug for misused dev_t when lookup in dev state hash table.
Date: Tue, 17 Oct 2017 19:34:47 +0800
Message-ID: <1508240087-36513-1-git-send-email-gujx@cn.fujitsu.com>
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

Reproduce of this bug:
Use MOUNT_OPTIONS="-o check_int" when run btrfs/001 in xfstest.
Then there will be WARNING like below.
WARNING:
btrfs: attempt to write superblock which references block M @29523968 (sda7     /1111654400/2) which is never written!

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



