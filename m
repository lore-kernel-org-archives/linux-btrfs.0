Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35112 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934530AbdBQOoN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:13 -0500
Received: by mail-wr0-f193.google.com with SMTP id q39so5487494wrb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:12 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 25/38] btrfs: make check_compressed_csum take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:16 +0200
Message-Id: <1487342609-20652-26-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/compression.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b8de71abfbd3..9f5e2e222e2a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -100,7 +100,7 @@ static struct bio *compressed_bio_alloc(struct block_device *bdev,
 	return btrfs_bio_alloc(bdev, first_byte >> 9, BIO_MAX_PAGES, gfp_flags);
 }
 
-static int check_compressed_csum(struct inode *inode,
+static int check_compressed_csum(struct btrfs_inode *inode,
 				 struct compressed_bio *cb,
 				 u64 disk_start)
 {
@@ -111,7 +111,7 @@ static int check_compressed_csum(struct inode *inode,
 	u32 csum;
 	u32 *cb_sum = &cb->sums;
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
+	if (inode->flags & BTRFS_INODE_NODATASUM)
 		return 0;
 
 	for (i = 0; i < cb->nr_pages; i++) {
@@ -124,8 +124,8 @@ static int check_compressed_csum(struct inode *inode,
 		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
-			btrfs_print_data_csum_error(BTRFS_I(inode), disk_start, csum,
-						    *cb_sum, cb->mirror_num);
+			btrfs_print_data_csum_error(inode, disk_start, csum, *cb_sum, 
+					cb->mirror_num);
 			ret = -EIO;
 			goto fail;
 		}
@@ -165,7 +165,7 @@ static void end_compressed_bio_read(struct bio *bio)
 		goto out;
 
 	inode = cb->inode;
-	ret = check_compressed_csum(inode, cb,
+	ret = check_compressed_csum(BTRFS_I(inode), cb,
 				    (u64)bio->bi_iter.bi_sector << 9);
 	if (ret)
 		goto csum_failed;
-- 
2.7.4

