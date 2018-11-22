Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9835BC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 08:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6161620820
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 08:17:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6161620820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392877AbeKVS4R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 13:56:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:52502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727486AbeKVS4R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 13:56:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F753AD54
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 08:17:53 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove extent_io_ops::readpage_io_failed_hook
Date:   Thu, 22 Nov 2018 10:17:49 +0200
Message-Id: <20181122081749.26146-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For data inodes this hook does nothing but to return -EAGAIN which is
used to signal to the endio routines that this bio belongs to a data
inode. If this is the case the actual retrying is handled by
bio_readpage_error. Alternatively, if this bio belongs to the btree
inode then btree_io_failed_hook just does some cleanup and doesn't
retry anything.

This patch simplifies the code flow by eliminating
readpage_io_failed_hook and instead open-coding btree_io_failed_hook in
end_bio_extent_readpage. Also eliminate some needless checks since IO is always
performed on either data inode or btree inode, both of which are guaranteed to 
have their extent_io_tree::ops set. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c   | 16 ----------
 fs/btrfs/extent_io.c | 69 ++++++++++++++++++++++----------------------
 fs/btrfs/extent_io.h |  1 -
 fs/btrfs/inode.c     |  7 -----
 4 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index feb67dfd663d..5024d9374163 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -673,19 +673,6 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	return ret;
 }
 
-static int btree_io_failed_hook(struct page *page, int failed_mirror)
-{
-	struct extent_buffer *eb;
-
-	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
-	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb->io_pages);
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-		btree_readahead_hook(eb, -EIO);
-	return -EIO;	/* we fixed nothing */
-}
-
 static void end_workqueue_bio(struct bio *bio)
 {
 	struct btrfs_end_io_wq *end_io_wq = bio->bi_private;
@@ -4541,7 +4528,4 @@ static const struct extent_io_ops btree_extent_io_ops = {
 	/* mandatory callbacks */
 	.submit_bio_hook = btree_submit_bio_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
-	.readpage_io_failed_hook = btree_io_failed_hook,
-
-	/* optional callbacks */
 };
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ea808d6cfbc..cca3bccd142e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2333,11 +2333,10 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 }
 
 /*
- * this is a generic handler for readpage errors (default
- * readpage_io_failed_hook). if other copies exist, read those and write back
- * good data to the failed position. does not investigate in remapping the
- * failed extent elsewhere, hoping the device will be smart enough to do this as
- * needed
+ * This is a generic handler for readpage errors. If other copies exist, read
+ * those and write back good data to the failed position. Does not investigate
+ * in remapping the failed extent elsewhere, hoping the device will be smart
+ * enough to do this as needed
  */
 
 static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
@@ -2501,6 +2500,8 @@ static void end_bio_extent_readpage(struct bio *bio)
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
 		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+		bool data_inode = btrfs_ino(BTRFS_I(inode))
+			!= BTRFS_BTREE_INODE_OBJECTID;
 
 		btrfs_debug(fs_info,
 			"end_bio_extent_readpage: bi_sector=%llu, err=%d, mirror=%u",
@@ -2530,7 +2531,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 		len = bvec->bv_len;
 
 		mirror = io_bio->mirror_num;
-		if (likely(uptodate && tree->ops)) {
+		if (likely(uptodate)) {
 			ret = tree->ops->readpage_end_io_hook(io_bio, offset,
 							      page, start, end,
 							      mirror);
@@ -2546,38 +2547,36 @@ static void end_bio_extent_readpage(struct bio *bio)
 		if (likely(uptodate))
 			goto readpage_ok;
 
-		if (tree->ops) {
-			ret = tree->ops->readpage_io_failed_hook(page, mirror);
-			if (ret == -EAGAIN) {
-				/*
-				 * Data inode's readpage_io_failed_hook() always
-				 * returns -EAGAIN.
-				 *
-				 * The generic bio_readpage_error handles errors
-				 * the following way: If possible, new read
-				 * requests are created and submitted and will
-				 * end up in end_bio_extent_readpage as well (if
-				 * we're lucky, not in the !uptodate case). In
-				 * that case it returns 0 and we just go on with
-				 * the next page in our bio. If it can't handle
-				 * the error it will return -EIO and we remain
-				 * responsible for that page.
-				 */
-				ret = bio_readpage_error(bio, offset, page,
-							 start, end, mirror);
-				if (ret == 0) {
-					uptodate = !bio->bi_status;
-					offset += len;
-					continue;
-				}
-			}
+		if (data_inode) {
 
 			/*
-			 * metadata's readpage_io_failed_hook() always returns
-			 * -EIO and fixes nothing.  -EIO is also returned if
-			 * data inode error could not be fixed.
+			 * The generic bio_readpage_error handles errors the
+			 * following way: If possible, new read requests are
+			 * created and submitted and will end up in
+			 * end_bio_extent_readpage as well (if we're lucky,
+			 * not in the !uptodate case). In that case it returns
+			 * 0 and we just go on with the next page in our bio.
+			 * If it can't handle the error it will return -EIO and
+			 * we remain responsible for that page.
 			 */
-			ASSERT(ret == -EIO);
+			ret = bio_readpage_error(bio, offset, page, start, end,
+						 mirror);
+			if (ret == 0) {
+				uptodate = !bio->bi_status;
+				offset += len;
+				continue;
+			}
+		} else {
+			struct extent_buffer *eb =
+				(struct extent_buffer *)page->private;
+			set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
+			eb->read_mirror = mirror;
+			atomic_dec(&eb->io_pages);
+			if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD,
+					       &eb->bflags))
+				btree_readahead_hook(eb, -EIO);
+
+			ret = -EIO;
 		}
 readpage_ok:
 		if (likely(uptodate)) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 22b34426f9f8..c2b3e1ebbf3d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -101,7 +101,6 @@ struct extent_io_ops {
 	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
-	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
 };
 
 struct extent_io_tree {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9f65f131f244..31ce2147c7ea 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10476,12 +10476,6 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return ret;
 }
 
-__attribute__((const))
-static int btrfs_readpage_io_failed_hook(struct page *page, int failed_mirror)
-{
-	return -EAGAIN;
-}
-
 void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	struct inode *inode = tree->private_data;
@@ -10877,7 +10871,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	/* mandatory callbacks */
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
-	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 };
 
 /*
-- 
2.17.1

