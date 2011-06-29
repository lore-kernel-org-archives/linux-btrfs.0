From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v3 4/6] btrfs: hooks for readahead
Date: Wed, 29 Jun 2011 18:32:20 +0200
Message-ID: <260cc7b32235ec663586ee15101f7a5aaa381b2b.1309364964.git.sensille@gmx.net>
References: <cover.1309364964.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1309364964.git.sensille@gmx.net>
In-Reply-To: <cover.1309364964.git.sensille@gmx.net>
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
index 904c4b3..f5b7b79 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -574,11 +574,47 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
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
@@ -3132,6 +3168,7 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 static struct extent_io_ops btree_extent_io_ops = {
 	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
+	.readpage_io_failed_hook = btree_io_failed_hook,
 	.submit_bio_hook = btree_submit_bio_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b7f0b9b..19ca500 100644
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

