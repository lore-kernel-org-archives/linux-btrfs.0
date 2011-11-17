From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] btrfs: mirror_num should be int, not u64
Date: Thu, 17 Nov 2011 15:31:45 +0100
Message-ID: <1321540305-16545-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My previous patch introduced some u64 for failed_mirror variables, this one
makes it consistent again.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/disk-io.c   |    2 +-
 fs/btrfs/extent_io.c |    4 ++--
 fs/btrfs/extent_io.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b6a5c0d..48b1b00 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -620,7 +620,7 @@ out:
 
 static int btree_io_failed_hook(struct bio *failed_bio,
 			 struct page *page, u64 start, u64 end,
-			 u64 mirror_num, struct extent_state *state)
+			 int mirror_num, struct extent_state *state)
 {
 	struct extent_io_tree *tree;
 	unsigned long len;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1f87c4d..3a729de 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2285,8 +2285,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 				clean_io_failure(start, page);
 		}
 		if (!uptodate) {
-			u64 failed_mirror;
-			failed_mirror = (u64)bio->bi_bdev;
+			int failed_mirror;
+			failed_mirror = (int)(long int)bio->bi_bdev;
 			if (tree->ops && tree->ops->readpage_io_failed_hook)
 				ret = tree->ops->readpage_io_failed_hook(
 						bio, page, start, end,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index feb9be0..7604c30 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -70,7 +70,7 @@ struct extent_io_ops {
 			      unsigned long bio_flags);
 	int (*readpage_io_hook)(struct page *page, u64 start, u64 end);
 	int (*readpage_io_failed_hook)(struct bio *bio, struct page *page,
-				       u64 start, u64 end, u64 failed_mirror,
+				       u64 start, u64 end, int failed_mirror,
 				       struct extent_state *state);
 	int (*writepage_io_failed_hook)(struct bio *bio, struct page *page,
 					u64 start, u64 end,
-- 
1.7.3.4

