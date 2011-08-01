From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: skip looking for delalloc if we don't have ->fill_delalloc
Date: Mon,  1 Aug 2011 12:11:16 -0400
Message-ID: <1312215076-10329-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We always look for delalloc bytes in our io_tree so we can fill in delalloc.
This is fine in most cases, but if we're writing out the btree_inode this is
just a superfluous tree search on the io_tree, and if we have a lot of metadata
dirty this could be an expensive check.  So instead check to see if our io_tree
has a ->fill_delalloc op, and if not don't even bother doing the lookup.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 067b174..e16dcbf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2180,6 +2180,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	int compressed;
 	int write_flags;
 	unsigned long nr_written = 0;
+	bool fill_delalloc = true;
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		write_flags = WRITE_SYNC;
@@ -2210,10 +2211,13 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 	set_page_extent_mapped(page);
 
+	if (!tree->ops || !tree->ops->fill_delalloc)
+		fill_delalloc = false;
+
 	delalloc_start = start;
 	delalloc_end = 0;
 	page_started = 0;
-	if (!epd->extent_locked) {
+	if (!epd->extent_locked && fill_delalloc) {
 		u64 delalloc_to_write = 0;
 		/*
 		 * make sure the wbc mapping index is at least updated
-- 
1.7.5.2

