From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] Btrfs: Remove unused variable 'last_index' in file.c
Date: Tue, 12 Jul 2011 14:43:45 -0500
Message-ID: <1310499825-18695-1-git-send-email-mitch.harder@sabayonlinux.org>
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The variable 'last_index' is calculated in the __btrfs_buffered_write
function and passed as a parameter to the prepare_pages function,
but is not used anywhere in the prepare_pages function.

Remove instances of 'last_index' in these functions.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/file.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index bd6bbb8..b061de0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1059,7 +1059,7 @@ static int prepare_uptodate_page(struct page *page, u64 pos)
 static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 			 struct page **pages, size_t num_pages,
 			 loff_t pos, unsigned long first_index,
-			 unsigned long last_index, size_t write_bytes)
+			 size_t write_bytes)
 {
 	struct extent_state *cached_state = NULL;
 	int i;
@@ -1159,7 +1159,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page **pages = NULL;
 	unsigned long first_index;
-	unsigned long last_index;
 	size_t num_written = 0;
 	int nrptrs;
 	int ret = 0;
@@ -1172,7 +1171,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		return -ENOMEM;
 
 	first_index = pos >> PAGE_CACHE_SHIFT;
-	last_index = (pos + iov_iter_count(i)) >> PAGE_CACHE_SHIFT;
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
@@ -1206,8 +1204,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		 * contents of pages from loop to loop
 		 */
 		ret = prepare_pages(root, file, pages, num_pages,
-				    pos, first_index, last_index,
-				    write_bytes);
+				    pos, first_index, write_bytes);
 		if (ret) {
 			btrfs_delalloc_release_space(inode,
 					num_pages << PAGE_CACHE_SHIFT);
-- 
1.7.3.4

