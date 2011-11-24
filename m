From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 39/99] btrfs: __unlock_for_delalloc should return void
Date: Wed, 23 Nov 2011 19:36:12 -0500
Message-ID: <20111124004224.333913220@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 __unlock_for_delalloc has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1384,9 +1384,9 @@ out:
 	return found;
 }
 
-static noinline int __unlock_for_delalloc(struct inode *inode,
-					  struct page *locked_page,
-					  u64 start, u64 end)
+static noinline void __unlock_for_delalloc(struct inode *inode,
+					   struct page *locked_page,
+					   u64 start, u64 end)
 {
 	int ret;
 	struct page *pages[16];
@@ -1396,7 +1396,7 @@ static noinline int __unlock_for_delallo
 	int i;
 
 	if (index == locked_page->index && end_index == index)
-		return 0;
+		return;
 
 	while (nr_pages > 0) {
 		ret = find_get_pages_contig(inode->i_mapping, index,
@@ -1411,7 +1411,6 @@ static noinline int __unlock_for_delallo
 		index += ret;
 		cond_resched();
 	}
-	return 0;
 }
 
 static noinline int lock_delalloc_pages(struct inode *inode,



