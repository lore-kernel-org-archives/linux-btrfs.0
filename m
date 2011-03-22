From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't allocate dip->csums when doing writes
Date: Tue, 22 Mar 2011 11:47:48 -0400
Message-ID: <1300808868-3035-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When doing direct writes we store the checksums in the ordered sum stuff in the
ordered extent for writing them when the write completes, so we don't even use
the dip->csums array.  So if we're writing, don't bother allocating dip->csums
since we won't use it anyway.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e010000..570cd44 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5944,6 +5944,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	int nr_pages = 0;
 	u32 *csums = dip->csums;
 	int ret = 0;
+	int write = rw & REQ_WRITE;
 
 	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
 	if (!bio)
@@ -5980,7 +5981,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 				goto out_err;
 			}
 
-			if (!skip_sum)
+			/* Write's use the ordered csums */
+			if (!write && !skip_sum)
 				csums = csums + nr_pages;
 			start_sector += submit_len >> 9;
 			file_offset += submit_len;
@@ -6048,7 +6050,8 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 	}
 	dip->csums = NULL;
 
-	if (!skip_sum) {
+	/* Write's use the ordered csum stuff, so we don't need dip->csums */
+	if (!write && !skip_sum) {
 		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
 		if (!dip->csums) {
 			kfree(dip);
-- 
1.7.2.3

