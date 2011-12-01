From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: fix meta data raid-repair merge problem
Date: Thu,  1 Dec 2011 15:52:35 +0100
Message-ID: <1322751155-30846-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Commit 4a54c8c16 introduced raid-repair, killing the individual
readpage_io_failed_hook entries from inode.c and disk-io.c. Commit
4bb31e92 introduced new readahead code, adding a readpage_io_failed_hook to
disk-io.c.

The raid-repair commit had logic to disable raid-repair, if
readpage_io_failed_hook is set. Thus, the readahead commit effectively
disabled raid-repair for meta data.

This commit changes the logic to always attempt raid-repair when needed and
call the readpage_io_failed_hook in case raid-repair fails. This is much
more straight forward and should have been like that from the beginning.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Reported-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
I should have recognized this within the integration period. Enabling meta data
correction in this rc-phase doesn't make me feel comfortable. But as we haven't
had any problems related to raid repair so far and my tests where successful,
I'd still like to see this in rc4, if nobody objects.

The inline comment added is meant to help myself and others understanding these
bits the next time. There are no algorithmic changes.
---
 fs/btrfs/extent_io.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9472d3d..c7a71bf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2287,14 +2287,20 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (!uptodate) {
 			int failed_mirror;
 			failed_mirror = (int)(unsigned long)bio->bi_bdev;
-			if (tree->ops && tree->ops->readpage_io_failed_hook)
-				ret = tree->ops->readpage_io_failed_hook(
-						bio, page, start, end,
-						failed_mirror, state);
-			else
-				ret = bio_readpage_error(bio, page, start, end,
-							 failed_mirror, NULL);
+			/*
+			 * The generic bio_readpage_error handles errors the
+			 * following way: If possible, new read requests are
+			 * created and submitted and will end up in
+			 * end_bio_extent_readpage as well (if we're lucky, not
+			 * in the !uptodate case). In that case it returns 0 and
+			 * we just go on with the next page in our bio. If it
+			 * can't handle the error it will return -EIO and we
+			 * remain responsible for that page.
+			 */
+			ret = bio_readpage_error(bio, page, start, end,
+							failed_mirror, NULL);
 			if (ret == 0) {
+error_handled:
 				uptodate =
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
@@ -2302,6 +2308,13 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 				uncache_state(&cached);
 				continue;
 			}
+			if (tree->ops && tree->ops->readpage_io_failed_hook) {
+				ret = tree->ops->readpage_io_failed_hook(
+							bio, page, start, end,
+							failed_mirror, state);
+				if (ret == 0)
+					goto error_handled;
+			}
 		}
 
 		if (uptodate) {
-- 
1.7.3.4

