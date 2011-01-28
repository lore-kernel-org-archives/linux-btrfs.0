From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix some memory leak issues
Date: Fri, 28 Jan 2011 17:08:42 -0500
Message-ID: <1296252522-3260-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My reworking of file.c left a few memory leaks, this patch fixes these up.
Really these are places where before the rework we just BUG()'ed anyway, so it's
not that bad :).  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 416eee8..8dba070 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -876,8 +876,10 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		pinned[0] = grab_cache_page(inode->i_mapping, first_index);
 		if (!PageUptodate(pinned[0])) {
 			ret = btrfs_readpage(NULL, pinned[0]);
-			if (ret)
+			if (ret) {
+				kfree(pages);
 				return ret;
+			}
 			wait_on_page_locked(pinned[0]);
 		} else {
 			unlock_page(pinned[0]);
@@ -891,6 +893,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			if (ret) {
 				if (pinned[0])
 					page_cache_release(pinned[0]);
+				kfree(pages);
 				return ret;
 			}
 			wait_on_page_locked(pinned[1]);
@@ -965,8 +968,10 @@ again:
 						      dirty_pages, pos,
 						      copied);
 			if (ret) {
+				WARN_ON(1);
 				btrfs_delalloc_release_space(inode,
 					dirty_pages << PAGE_CACHE_SHIFT);
+				btrfs_drop_pages(pages, num_pages);
 				break;
 			}
 		}
-- 
1.7.2.3

