From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix page leak when allocing extent buffers
Date: Tue,  1 May 2012 11:44:18 -0400
Message-ID: <1335887058-6833-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we happen to alloc a extent buffer and then alloc a page and notice that
page is already attached to an extent buffer, we will only unlock it and
free our existing eb.  Any pages currently attached to that eb will be
properly freed, but we don't do the page_cache_release() on the page where
we noticed the other extent buffer which can cause us to leak pages and I
hope cause the weird issues we've been seeing in this area.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0f239c68..836fc37 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4121,6 +4121,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 			if (atomic_inc_not_zero(&exists->refs)) {
 				spin_unlock(&mapping->private_lock);
 				unlock_page(p);
+				page_cache_release(p);
 				mark_extent_buffer_accessed(exists);
 				goto free_eb;
 			}
@@ -4200,8 +4201,7 @@ free_eb:
 			unlock_page(eb->pages[i]);
 	}
 
-	if (!atomic_dec_and_test(&eb->refs))
-		return exists;
+	WARN_ON(!atomic_dec_and_test(&eb->refs));
 	btrfs_release_extent_buffer(eb);
 	return exists;
 }
-- 
1.7.7.6

