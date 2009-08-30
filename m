From: Jeffrey Wu <jwu@lkdn.net>
Subject: [PATCH] Btrfs: improved the BIO_RW_DISCARD function definition
Date: Sun, 30 Aug 2009 11:16:36 +0800
Message-ID: <20090830031636.GA9959@jwu-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jwu@lkdn.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(sorry, the last mail is sent by a mistake, resent this time).

The conditional compile func definition shall better not be defined this way:
static int btrfs_issue_discard()
{
#ifdef BIO_RW_DISCARD
	...
#else
	return 0;
#endif
}

instead, can be better done this way:

#ifndef BIO_RW_DISCARD
static int btrfs_issue_discard()
{
	return 0;
}
#endif

#ifdef BIO_RW_DISCARD
static int btrfs_issue_discard()
{ 
	...
}
#endif

Signed-off-by: Jeffrey Wu <jwu@lkdn.net>
---
 fs/btrfs/extent-tree.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 72a2b9c..4ccd94a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -62,6 +62,20 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
 
+#ifndef BIO_RW_DISCARD
+static void btrfs_issue_discard(struct block_device *bdev,
+				u64 start, u64 len)
+{
+	return;
+}
+
+static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
+				u64 num_bytes)
+{
+	return 0;
+}
+#endif
+
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
 {
@@ -1513,12 +1527,10 @@ static void btrfs_issue_discard(struct block_device *bdev,
 {
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
 }
-#endif
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 				u64 num_bytes)
 {
-#ifdef BIO_RW_DISCARD
 	int ret;
 	u64 map_length = num_bytes;
 	struct btrfs_multi_bio *multi = NULL;
@@ -1542,10 +1554,8 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 	}
 
 	return ret;
-#else
-	return 0;
-#endif
 }
+#endif
 
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
-- 
1.6.0.4

