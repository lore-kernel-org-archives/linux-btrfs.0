Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:54111 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373Ab3KMQTL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 11:19:11 -0500
Received: from pizpot.store ([192.168.43.236])
	by joses.store (RZmta 32.13 OK) with ESMTP id g03cc8pADGJ83U8
	for <linux-btrfs@vger.kernel.org>;
	Wed, 13 Nov 2013 17:19:08 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: print bytenr instead of page pointer in check-int
Date: Wed, 13 Nov 2013 17:19:08 +0100
Message-Id: <28616d106f4ab980e26ab8f27c677f47009d9fa5.1384359438.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The page pointer information was useless. The bytenr is what you
want when you search for submitted write bios.

Additionally, a new bit in the print mask is added that allows
to selectively enable the check-int submit_bio verbose mode. Before,
the global verbose mode had to be enabled leading to many million
useless lines in the kernel log.

And a comment is added that explains that LOG_BUF_SHIFT needs to
be set to a really high value.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index e0aab4456974..b50764bef141 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -77,6 +77,15 @@
  * the integrity of (super)-block write requests, do not
  * enable the config option BTRFS_FS_CHECK_INTEGRITY to
  * include and compile the integrity check tool.
+ *
+ * Expect millions of lines of information in the kernel log with an
+ * enabled check_int_print_mask. Therefore set LOG_BUF_SHIFT in the
+ * kernel config to at least 26 (which is 64MB). Usually the value is
+ * limited to 21 (which is 2MB) in init/Kconfig. The file needs to be
+ * changed like this before LOG_BUF_SHIFT can be set to a high value:
+ * config LOG_BUF_SHIFT
+ *       int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
+ *       range 12 30
  */
 
 #include <linux/sched.h>
@@ -124,6 +133,7 @@
 #define BTRFSIC_PRINT_MASK_INITIAL_DATABASE			0x00000400
 #define BTRFSIC_PRINT_MASK_NUM_COPIES				0x00000800
 #define BTRFSIC_PRINT_MASK_TREE_WITH_ALL_MIRRORS		0x00001000
+#define BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH_VERBOSE		0x00002000
 
 struct btrfsic_dev_state;
 struct btrfsic_state;
@@ -3015,6 +3025,7 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 	    (rw & WRITE) && NULL != bio->bi_io_vec) {
 		unsigned int i;
 		u64 dev_bytenr;
+		u64 cur_bytenr;
 		int bio_is_patched;
 		char **mapped_datav;
 
@@ -3033,6 +3044,7 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 				       GFP_NOFS);
 		if (!mapped_datav)
 			goto leave;
+		cur_bytenr = dev_bytenr;
 		for (i = 0; i < bio->bi_vcnt; i++) {
 			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_CACHE_SIZE);
 			mapped_datav[i] = kmap(bio->bi_io_vec[i].bv_page);
@@ -3044,16 +3056,13 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 				kfree(mapped_datav);
 				goto leave;
 			}
-			if ((BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
-			     BTRFSIC_PRINT_MASK_VERBOSE) ==
-			    (dev_state->state->print_mask &
-			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
-			      BTRFSIC_PRINT_MASK_VERBOSE)))
+			if (dev_state->state->print_mask &
+			    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH_VERBOSE)
 				printk(KERN_INFO
-				       "#%u: page=%p, len=%u, offset=%u\n",
-				       i, bio->bi_io_vec[i].bv_page,
-				       bio->bi_io_vec[i].bv_len,
+				       "#%u: bytenr=%llu, len=%u, offset=%u\n",
+				       i, cur_bytenr, bio->bi_io_vec[i].bv_len,
 				       bio->bi_io_vec[i].bv_offset);
+			cur_bytenr += bio->bi_io_vec[i].bv_len;
 		}
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      mapped_datav, bio->bi_vcnt,
-- 
1.8.4.3

