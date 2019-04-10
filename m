Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AB8C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 13:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E10DA20830
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 13:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbfDJNQQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 09:16:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:56088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729060AbfDJNQQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 09:16:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78151AF70
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 13:16:15 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant inode argument from btrfs_add_ordered_sum
Date:   Wed, 10 Apr 2019 16:16:11 +0300
Message-Id: <20190410131611.18149-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Ordered csums are keyed off of a btrfs_ordered_extent, which already
has a reference to the inode. This implies that an explicit inode
argument is redundant. So remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file-item.c    | 4 ++--
 fs/btrfs/ordered-data.c | 5 ++---
 fs/btrfs/ordered-data.h | 3 +--
 fs/btrfs/relocation.c   | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 3038054bbd2b..7e2cd9c81eb1 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -464,7 +464,7 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 
 				sums->len = this_sum_bytes;
 				this_sum_bytes = 0;
-				btrfs_add_ordered_sum(inode, ordered, sums);
+				btrfs_add_ordered_sum(ordered, sums);
 				btrfs_put_ordered_extent(ordered);
 
 				bytes_left = bio->bi_iter.bi_size - total_bytes;
@@ -499,7 +499,7 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 
 	}
 	this_sum_bytes = 0;
-	btrfs_add_ordered_sum(inode, ordered, sums);
+	btrfs_add_ordered_sum(ordered, sums);
 	btrfs_put_ordered_extent(ordered);
 	return 0;
 }
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 6fde2b2741ef..4d9bb0dea9af 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -270,13 +270,12 @@ int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
  * when an ordered extent is finished.  If the list covers more than one
  * ordered extent, it is split across multiples.
  */
-void btrfs_add_ordered_sum(struct inode *inode,
-			   struct btrfs_ordered_extent *entry,
+void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum)
 {
 	struct btrfs_ordered_inode_tree *tree;
 
-	tree = &BTRFS_I(inode)->ordered_tree;
+	tree = &BTRFS_I(entry->inode)->ordered_tree;
 	spin_lock_irq(&tree->lock);
 	list_add_tail(&sum->list, &entry->list);
 	spin_unlock_irq(&tree->lock);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index fb9a161f0215..4c5991c3de14 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -167,8 +167,7 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
 				      int type, int compress_type);
-void btrfs_add_ordered_sum(struct inode *inode,
-			   struct btrfs_ordered_extent *entry,
+void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 							 u64 file_offset);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 25fc6a4f3ecf..2246aa2e30e3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4604,7 +4604,7 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 		new_bytenr = ordered->start + (sums->bytenr - disk_bytenr);
 		sums->bytenr = new_bytenr;
 
-		btrfs_add_ordered_sum(inode, ordered, sums);
+		btrfs_add_ordered_sum(ordered, sums);
 	}
 out:
 	btrfs_put_ordered_extent(ordered);
-- 
2.17.1

