From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use find_or_create_page instead of grab_cache_page
Date: Mon, 11 Jul 2011 10:51:30 -0400
Message-ID: <1310395890-11805-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

grab_cache_page will use mapping_gfp_mask(), which for all inodes is set to
GFP_HIGHUSER_MOVABLE.  So instead use find_or_create_page in all cases where we
need GFP_NOFS so we don't deadlock.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c             |    3 ++-
 fs/btrfs/free-space-cache.c |    4 ++--
 fs/btrfs/inode.c            |    2 +-
 fs/btrfs/ioctl.c            |    4 ++--
 fs/btrfs/relocation.c       |    3 ++-
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 59cbdb1..3c8c435 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1081,7 +1081,8 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 
 again:
 	for (i = 0; i < num_pages; i++) {
-		pages[i] = grab_cache_page(inode->i_mapping, index + i);
+		pages[i] = find_or_create_page(inode->i_mapping, index + i,
+					       GFP_NOFS);
 		if (!pages[i]) {
 			faili = i - 1;
 			err = -ENOMEM;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index fd7fa2a..6377713 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -307,7 +307,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		if (!num_entries && !num_bitmaps)
 			break;
 
-		page = grab_cache_page(inode->i_mapping, index);
+		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
 		if (!page)
 			goto free_cache;
 
@@ -594,7 +594,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	 * know and don't freak out.
 	 */
 	while (index < num_pages) {
-		page = grab_cache_page(inode->i_mapping, index);
+		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
 		if (!page) {
 			int i;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6ede58..faf516e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3398,7 +3398,7 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
 
 	ret = -ENOMEM;
 again:
-	page = grab_cache_page(mapping, index);
+	page = find_or_create_page(mapping, index, GFP_NOFS);
 	if (!page) {
 		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
 		goto out;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..09c9a8d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -867,8 +867,8 @@ again:
 	/* step one, lock all the pages */
 	for (i = 0; i < num_pages; i++) {
 		struct page *page;
-		page = grab_cache_page(inode->i_mapping,
-					    start_index + i);
+		page = find_or_create_page(inode->i_mapping,
+					    start_index + i, GFP_NOFS);
 		if (!page)
 			break;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 5e0a3dc..59bb176 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2955,7 +2955,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			page_cache_sync_readahead(inode->i_mapping,
 						  ra, NULL, index,
 						  last_index + 1 - index);
-			page = grab_cache_page(inode->i_mapping, index);
+			page = find_or_create_page(inode->i_mapping, index,
+						   GFP_NOFS);
 			if (!page) {
 				btrfs_delalloc_release_metadata(inode,
 							PAGE_CACHE_SIZE);
-- 
1.7.5.2

