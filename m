From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v9 5/8] btrfs: add mirror_num to extent_read_full_page
Date: Thu,  1 Sep 2011 16:52:35 +0200
Message-ID: <1fc31c11569494cf143d0e9fa15bc08c60312291.1314887907.git.list.btrfs@jan-o-sch.net>
References: <cover.1314887907.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1314887907.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1314887907.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Currently, extent_read_full_page always assumes we are trying to read mirror
0, which generally is the best we can do. To add flexibility, pass it as a
parameter. This will be needed by scrub fixup code.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/disk-io.c   |    2 +-
 fs/btrfs/extent_io.c |    6 +++---
 fs/btrfs/extent_io.h |    2 +-
 fs/btrfs/inode.c     |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94ecac3..89ad5ef 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -908,7 +908,7 @@ static int btree_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	return extent_read_full_page(tree, page, btree_get_extent);
+	return extent_read_full_page(tree, page, btree_get_extent, 0);
 }
 
 static int btree_releasepage(struct page *page, gfp_t gfp_flags)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8491712..edf1c29 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2076,16 +2076,16 @@ out:
 }
 
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
-			    get_extent_t *get_extent)
+			    get_extent_t *get_extent, int mirror_num)
 {
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
 	int ret;
 
-	ret = __extent_read_full_page(tree, page, get_extent, &bio, 0,
+	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
 				      &bio_flags);
 	if (bio)
-		ret = submit_one_bio(READ, bio, 0, bio_flags);
+		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7b2f0c3..a9dd994 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -185,7 +185,7 @@ int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 		    gfp_t mask);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
-			  get_extent_t *get_extent);
+			  get_extent_t *get_extent, int mirror_num);
 int __init extent_io_init(void);
 void extent_io_exit(void);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 34195f9..2a01e32 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6244,7 +6244,7 @@ int btrfs_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	return extent_read_full_page(tree, page, btrfs_get_extent);
+	return extent_read_full_page(tree, page, btrfs_get_extent, 0);
 }
 
 static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
-- 
1.7.3.4

