From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: fix warning for 32-bit build of fs/btrfs/check-integrity.c
Date: Tue, 24 Jan 2012 18:19:26 +0100
Message-ID: <1327425566-27490-1-git-send-email-sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There have been 4 warnings on 32-bit build, they are herewith fixed.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index ad0b3ba..b669a7d 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1662,7 +1662,7 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 	block = btrfsic_block_hashtable_lookup(bdev, dev_bytenr,
 					       &state->block_hashtable);
 	if (NULL != block) {
-		u64 bytenr;
+		u64 bytenr = 0;
 		struct list_head *elem_ref_to;
 		struct list_head *tmp_ref_to;
 
@@ -2777,9 +2777,10 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 			printk(KERN_INFO
 			       "submit_bh(rw=0x%x, blocknr=%lu (bytenr %llu),"
 			       " size=%lu, data=%p, bdev=%p)\n",
-			       rw, bh->b_blocknr,
-			       (unsigned long long)dev_bytenr, bh->b_size,
-			       bh->b_data, bh->b_bdev);
+			       rw, (unsigned long)bh->b_blocknr,
+			       (unsigned long long)dev_bytenr,
+			       (unsigned long)bh->b_size, bh->b_data,
+			       bh->b_bdev);
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      bh->b_data, bh->b_size, NULL,
 					      NULL, bh, rw);
@@ -2844,7 +2845,7 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 			printk(KERN_INFO
 			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
 			       " bi_sector=%lu (bytenr %llu), bi_bdev=%p)\n",
-			       rw, bio->bi_vcnt, bio->bi_sector,
+			       rw, bio->bi_vcnt, (unsigned long)bio->bi_sector,
 			       (unsigned long long)dev_bytenr,
 			       bio->bi_bdev);
 
-- 
1.7.3.4

