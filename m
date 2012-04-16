From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: always store the mirror we read the eb from
Date: Mon, 16 Apr 2012 09:42:26 -0400
Message-ID: <1334583746-3332-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a panic where we were trying to fix a bad mirror but the
mirror number we were giving was 0, which is invalid.  This is because we
don't do the transid verification until after the read, so as far as the
read code is concerned the read was a success.  So instead store the mirror
we read from so that if there is some failure post read we know which mirror
to try next and which mirror needs to be fixed if we find a good copy of the
block.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c   |    8 ++++----
 fs/btrfs/extent_io.c |   15 ++++++---------
 fs/btrfs/extent_io.h |    4 ++--
 fs/btrfs/inode.c     |    2 +-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2a3ddd2..eff59fa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -390,8 +390,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 
 		if (!failed_mirror) {
 			failed = 1;
-			printk(KERN_ERR "failed mirror was %d\n", eb->failed_mirror);
-			failed_mirror = eb->failed_mirror;
+			failed_mirror = eb->read_mirror;
 		}
 
 		mirror_num++;
@@ -564,7 +563,7 @@ struct extent_buffer *find_eb_for_page(struct extent_io_tree *tree,
 }
 
 static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
-			       struct extent_state *state)
+			       struct extent_state *state, int mirror)
 {
 	struct extent_io_tree *tree;
 	u64 found_start;
@@ -589,6 +588,7 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	if (!reads_done)
 		goto err;
 
+	eb->read_mirror = mirror;
 	if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
 		ret = -EIO;
 		goto err;
@@ -652,7 +652,7 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 
 	eb = (struct extent_buffer *)page->private;
 	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->failed_mirror = failed_mirror;
+	eb->read_mirror = failed_mirror;
 	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
 		btree_readahead_hook(root, eb, eb->start, -EIO);
 	return -EIO;	/* we fixed nothing */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0c3ec00..7c501d3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2297,7 +2297,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	u64 start;
 	u64 end;
 	int whole_page;
-	int failed_mirror;
+	int mirror;
 	int ret;
 
 	if (err)
@@ -2336,20 +2336,18 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		}
 		spin_unlock(&tree->lock);
 
+		mirror = (int)(unsigned long)bio->bi_bdev;
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
-							      state);
+							      state, mirror);
 			if (ret)
 				uptodate = 0;
 			else
 				clean_io_failure(start, page);
 		}
 
-		if (!uptodate)
-			failed_mirror = (int)(unsigned long)bio->bi_bdev;
-
 		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
-			ret = tree->ops->readpage_io_failed_hook(page, failed_mirror);
+			ret = tree->ops->readpage_io_failed_hook(page, mirror);
 			if (!ret && !err &&
 			    test_bit(BIO_UPTODATE, &bio->bi_flags))
 				uptodate = 1;
@@ -2364,8 +2362,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 * can't handle the error it will return -EIO and we
 			 * remain responsible for that page.
 			 */
-			ret = bio_readpage_error(bio, page, start, end,
-							failed_mirror, NULL);
+			ret = bio_readpage_error(bio, page, start, end, mirror, NULL);
 			if (ret == 0) {
 				uptodate =
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -4458,7 +4455,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	}
 
 	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->failed_mirror = 0;
+	eb->read_mirror = 0;
 	atomic_set(&eb->io_pages, num_reads);
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index faf10eb..b516c3b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -79,7 +79,7 @@ struct extent_io_ops {
 					u64 start, u64 end,
 				       struct extent_state *state);
 	int (*readpage_end_io_hook)(struct page *page, u64 start, u64 end,
-				    struct extent_state *state);
+				    struct extent_state *state, int mirror);
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
@@ -135,7 +135,7 @@ struct extent_buffer {
 	spinlock_t refs_lock;
 	atomic_t refs;
 	atomic_t io_pages;
-	int failed_mirror;
+	int read_mirror;
 	struct list_head leak_list;
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 261021c..77c2b03 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1947,7 +1947,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
  * extent_io.c will try to find good copies for us.
  */
 static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
-			       struct extent_state *state)
+			       struct extent_state *state, int mirror)
 {
 	size_t offset = start - ((u64)page->index << PAGE_CACHE_SHIFT);
 	struct inode *inode = page->mapping->host;
-- 
1.7.7.6

