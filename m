From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs scrub: 32 bit compatibility issues
Date: Wed, 16 Mar 2011 10:11:45 +0100
Message-ID: <1300266705-12809-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

According to review of Ilya Dryomov:
 - nstripes int -> u64
 - %lld -> %llu

Please note that the scrub patches haven't been tested on 32 bit systems at
all.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f36f5bf..ef59200 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -411,8 +411,8 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 	                      &multi, 0);
 	if (ret || !multi || length < PAGE_SIZE) {
 		printk(KERN_ERR
-		       "scrub_fixup: btrfs_map_block failed us for %lld\n",
-		       fixup->logical);
+		       "scrub_fixup: btrfs_map_block failed us for %llu\n",
+		       (unsigned long long)fixup->logical);
 		WARN_ON(1);
 		return;
 	}
@@ -479,7 +479,8 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 	spin_unlock(&sdev->stat_lock);
 
 	if (printk_ratelimit())
-		printk(KERN_ERR "btrfs: fixed up at %lld\n", fixup->logical);
+		printk(KERN_ERR "btrfs: fixed up at %llu\n",
+		       (unsigned long long)fixup->logical);
 	return;
 
 uncorrectable:
@@ -489,8 +490,8 @@ uncorrectable:
 	spin_unlock(&sdev->stat_lock);
 
 	if (printk_ratelimit())
-		printk(KERN_ERR "btrfs: unable to fixup at %lld\n",
-			 fixup->logical);
+		printk(KERN_ERR "btrfs: unable to fixup at %llu\n",
+			 (unsigned long long)fixup->logical);
 }
 
 static void scrub_bio_end_io(struct bio *bio, int err)
@@ -857,7 +858,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	int ret;
 	int slot;
 	int i;
-	int nstripes;
+	u64 nstripes;
 	int start_stripe;
 	struct extent_buffer *l;
 	struct btrfs_key key;
@@ -1058,9 +1059,10 @@ again:
 			if (key.objectid < logical &&
 			    (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
 				printk(KERN_ERR
-				       "btrfs scrub: tree block %lld spanning "
-				       "stripes, ignored. logical=%lld\n",
-				       key.objectid, logical);
+				       "btrfs scrub: tree block %llu spanning "
+				       "stripes, ignored. logical=%llu\n",
+				       (unsigned long long)key.objectid,
+				       (unsigned long long)logical);
 				goto next;
 			}
 
-- 
1.7.3.4

