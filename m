From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v5 5/7] btrfs: hooks for readahead
Date: Fri,  1 Jul 2011 22:58:51 +0200
Message-ID: <b2a72eaf9581bd30c62cfb010608f1c214aa2b82.1309553533.git.sensille@gmx.net>
References: <cover.1309553533.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1309553533.git.sensille@gmx.net>
In-Reply-To: <cover.1309553533.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This adds the hooks needed for readahead. In the readpage_end_io_hook,
the extent state is checked for the EXTENT_READAHEAD flag. Only in this
case the readahead hook is called, to keep the impact on non-ra as low
as possible.
Additionally, a hook for a failed IO is added, otherwise readahead would
wait indefinitely for the extent to finish.

Changes for v2:
 - eliminate race condition

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c   |   37 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.c |    2 +-
 2 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7fbdfa1..465ebbf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -575,11 +575,47 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	end = min_t(u64, eb->len, PAGE_CACHE_SIZE);
 	end = eb->start + end - 1;
 err:
+	if (test_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)) {
+		clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags);
+		btree_readahead_hook(root, eb, eb->start, ret);
+	}
+
 	free_extent_buffer(eb);
 out:
 	return ret;
 }
 
+static int btree_io_failed_hook(struct bio *failed_bio,
+			 struct page *page, u64 start, u64 end,
+			 struct extent_state *state)
+{
+	struct extent_io_tree *tree;
+	unsigned long len;
+	struct extent_buffer *eb;
+	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+
+	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	if (page->private == EXTENT_PAGE_PRIVATE)
+		goto out;
+	if (!page->private)
+		goto out;
+
+	len = page->private >> 2;
+	WARN_ON(len == 0);
+
+	eb = alloc_extent_buffer(tree, start, len, page);
+	if (eb == NULL)
+		goto out;
+
+	if (test_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)) {
+		clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags);
+		btree_readahead_hook(root, eb, eb->start, -EIO);
+	}
+
+out:
+	return -EIO;	/* we fixed nothing */
+}
+
 static void end_workqueue_bio(struct bio *bio, int err)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
@@ -3134,6 +3170,7 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 static struct extent_io_ops btree_extent_io_ops = {
 	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
+	.readpage_io_failed_hook = btree_io_failed_hook,
 	.submit_bio_hook = btree_submit_bio_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f48b072..877e24f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1774,7 +1774,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (!uptodate && tree->ops &&
 		    tree->ops->readpage_io_failed_hook) {
 			ret = tree->ops->readpage_io_failed_hook(bio, page,
-							 start, end, NULL);
+							 start, end, state);
 			if (ret == 0) {
 				uptodate =
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
-- 
1.7.3.4

