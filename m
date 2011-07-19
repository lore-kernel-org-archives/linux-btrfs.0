From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v4 2/8] scrub: added unverified_errors
Date: Tue, 19 Jul 2011 17:11:04 +0200
Message-ID: <61ed91cf8fef4c406f892f3d6d5a20193a20d3fd.1311087946.git.list.btrfs@jan-o-sch.net>
References: <cover.1311087946.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1311087946.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1311087946.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

In normal operation, scrub is reading data sequentially in large portions.
In case of an i/o error, we try to find the corrupted area(s) by issuing
page sized read requests. With this commit we increment the
unverified_errors counter if all of the small size requests succeed.

Userland patches carrying such conspicous events to the administrator should
already be around.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/scrub.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a8d03d5..35099fa 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -201,18 +201,25 @@ nomem:
  * recheck_error gets called for every page in the bio, even though only
  * one may be bad
  */
-static void scrub_recheck_error(struct scrub_bio *sbio, int ix)
+static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
 {
+	struct scrub_dev *sdev = sbio->sdev;
+	u64 sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
+
 	if (sbio->err) {
-		if (scrub_fixup_io(READ, sbio->sdev->dev->bdev,
-				   (sbio->physical + ix * PAGE_SIZE) >> 9,
+		if (scrub_fixup_io(READ, sbio->sdev->dev->bdev, sector,
 				   sbio->bio->bi_io_vec[ix].bv_page) == 0) {
 			if (scrub_fixup_check(sbio, ix) == 0)
-				return;
+				return 0;
 		}
 	}
 
+	spin_lock(&sdev->stat_lock);
+	++sdev->stat.read_errors;
+	spin_unlock(&sdev->stat_lock);
+
 	scrub_fixup(sbio, ix);
+	return 1;
 }
 
 static int scrub_fixup_check(struct scrub_bio *sbio, int ix)
@@ -382,8 +389,14 @@ static void scrub_checksum(struct btrfs_work *work)
 	int ret;
 
 	if (sbio->err) {
+		ret = 0;
 		for (i = 0; i < sbio->count; ++i)
-			scrub_recheck_error(sbio, i);
+			ret |= scrub_recheck_error(sbio, i);
+		if (!ret) {
+			spin_lock(&sdev->stat_lock);
+			++sdev->stat.unverified_errors;
+			spin_unlock(&sdev->stat_lock);
+		}
 
 		sbio->bio->bi_flags &= ~(BIO_POOL_MASK - 1);
 		sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
@@ -396,10 +409,6 @@ static void scrub_checksum(struct btrfs_work *work)
 			bi->bv_offset = 0;
 			bi->bv_len = PAGE_SIZE;
 		}
-
-		spin_lock(&sdev->stat_lock);
-		++sdev->stat.read_errors;
-		spin_unlock(&sdev->stat_lock);
 		goto out;
 	}
 	for (i = 0; i < sbio->count; ++i) {
@@ -420,8 +429,14 @@ static void scrub_checksum(struct btrfs_work *work)
 			WARN_ON(1);
 		}
 		kunmap_atomic(buffer, KM_USER0);
-		if (ret)
-			scrub_recheck_error(sbio, i);
+		if (ret) {
+			ret = scrub_recheck_error(sbio, i);
+			if (!ret) {
+				spin_lock(&sdev->stat_lock);
+				++sdev->stat.unverified_errors;
+				spin_unlock(&sdev->stat_lock);
+			}
+		}
 	}
 
 out:
-- 
1.7.3.4

