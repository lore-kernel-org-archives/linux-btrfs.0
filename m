From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix formatting in file.c
Date: Tue, 25 Jan 2011 12:43:30 -0500
Message-ID: <1295977410-16043-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, but these were bugging me.  Just cleanup some of the formatting in
file.c.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c800d58..a754865 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -75,9 +75,8 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 		total_copied += copied;
 
 		/* Return to btrfs_file_aio_write to fault page */
-		if (unlikely(copied == 0)) {
+		if (unlikely(copied == 0))
 			break;
-		}
 
 		if (unlikely(copied < PAGE_CACHE_SIZE - offset)) {
 			offset += copied;
@@ -149,13 +148,14 @@ static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
 		ClearPageChecked(p);
 		set_page_dirty(p);
 	}
-	if (end_pos > isize) {
+
+	/*
+	 * we've only changed i_size in ram, and we haven't updated
+	 * the disk i_size.  There is no need to log the inode
+	 * at this time.
+	 */
+	if (end_pos > isize)
 		i_size_write(inode, end_pos);
-		/* we've only changed i_size in ram, and we haven't updated
-		 * the disk i_size.  There is no need to log the inode
-		 * at this time.
-		 */
-	}
 	return 0;
 }
 
-- 
1.6.6.1

