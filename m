Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17920 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966243AbdCXTOj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 15:14:39 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: bring back repair during read
Date: Fri, 24 Mar 2017 12:13:24 -0700
Message-Id: <1490382804-25087-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 20a7db8ab3f2 ("btrfs: add dummy callback for readpage_io_failed
and drop checks") made a cleanup around readpage_io_failed_hook, and
it was supposed to keep the original sematics, but it also
unexpectedly disabled repair during read for dup, raid1 and raid10.

This fixes the problem by letting data's inode call the generic
readpage_io_failed callback by returning -EAGAIN from its
readpage_io_failed_hook in order to notify end_bio_extent_readpage to
do the rest.  We don't call it directly because the generic one takes
an offset from end_bio_extent_readpage() to calculate the index in the
checksum array.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 46 ++++++++++++++++++++++++++++------------------
 fs/btrfs/inode.c     |  7 +++----
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 28e8192..1edb55d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2583,26 +2583,36 @@ static void end_bio_extent_readpage(struct bio *bio)
 
 		if (tree->ops) {
 			ret = tree->ops->readpage_io_failed_hook(page, mirror);
-			if (!ret && !bio->bi_error)
-				uptodate = 1;
-		} else {
+			if (ret == -EAGAIN) {
+				/*
+				 * Data inode's readpage_io_failed_hook() always
+				 * return -EAGAIN.
+				 *
+				 * The generic bio_readpage_error handles errors
+				 * the following way: If possible, new read
+				 * requests are created and submitted and will
+				 * end up in end_bio_extent_readpage as well (if
+				 * we're lucky, not in the !uptodate case). In
+				 * that case it returns 0 and we just go on with
+				 * the next page in our bio. If it can't handle
+				 * the error it will return -EIO and we remain
+				 * responsible for that page.
+				 */
+				ret = bio_readpage_error(bio, offset, page,
+							 start, end, mirror);
+				if (ret == 0) {
+					uptodate = !bio->bi_error;
+					offset += len;
+					continue;
+				}
+			}
+
 			/*
-			 * The generic bio_readpage_error handles errors the
-			 * following way: If possible, new read requests are
-			 * created and submitted and will end up in
-			 * end_bio_extent_readpage as well (if we're lucky, not
-			 * in the !uptodate case). In that case it returns 0 and
-			 * we just go on with the next page in our bio. If it
-			 * can't handle the error it will return -EIO and we
-			 * remain responsible for that page.
+			 * metadata's readpage_io_failed_hook() always returns
+			 * -EIO and fixes nothing.  -EIO is also returned if
+			 * data inode error could not be fixed.
 			 */
-			ret = bio_readpage_error(bio, offset, page, start, end,
-						 mirror);
-			if (ret == 0) {
-				uptodate = !bio->bi_error;
-				offset += len;
-				continue;
-			}
+			ASSERT(ret == -EIO);
 		}
 readpage_ok:
 		if (likely(uptodate)) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c40060c..39a80a0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10508,10 +10508,9 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 }
 
-__attribute__((const))
-static int dummy_readpage_io_failed_hook(struct page *page, int failed_mirror)
+static int btrfs_readpage_io_failed_hook(struct page *page, int failed_mirror)
 {
-	return 0;
+	return -EAGAIN;
 }
 
 static const struct inode_operations btrfs_dir_inode_operations = {
@@ -10556,7 +10555,7 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
 	.merge_bio_hook = btrfs_merge_bio_hook,
-	.readpage_io_failed_hook = dummy_readpage_io_failed_hook,
+	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
 	.fill_delalloc = run_delalloc_range,
-- 
2.5.5

