From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix how we deal with the pages array in the write path
Date: Tue, 25 Jan 2011 17:09:16 -0500
Message-ID: <1295993356-28963-1-git-send-email-josef@redhat.com>
References: <1295986273-30308-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295986273-30308-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Really we don't need to memset the pages array at all, since we know how many
pages we're going to use in the array and pass that around.  So don't memset,
just trust we're not idiots and we pass num_pages around properly.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c0f312a..f4eef63 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -95,8 +95,6 @@ static noinline void btrfs_drop_pages(struct page **pages, size_t num_pages)
 {
 	size_t i;
 	for (i = 0; i < num_pages; i++) {
-		if (!pages[i])
-			break;
 		/* page checked is some magic around finding pages that
 		 * have been modified without going through btrfs_set_page_dirty
 		 * clear it here
@@ -788,7 +786,6 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 			return err;
 	}
 
-	memset(pages, 0, num_pages * sizeof(struct page *));
 again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = grab_cache_page(inode->i_mapping, index + i);
@@ -910,8 +907,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 		WARN_ON(num_pages > nrptrs);
 again:
-		memset(pages, 0, sizeof(struct page *) * nrptrs);
-
 		/*
 		 * Fault pages before locking them in prepare_pages
 		 * to avoid recursive lock
@@ -926,6 +921,11 @@ again:
 		if (ret)
 			break;
 
+		/*
+		 * This is going to setup the pages array with the number of
+		 * pages we want, so we don't really need to worry about the
+		 * contents of pages from loop to loop
+		 */
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, last_index,
 				    write_bytes);
-- 
1.6.6.1

