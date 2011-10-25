From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 19/66] btrfs: __unlock_for_delalloc should return void
Date: Mon, 24 Oct 2011 21:02:55 -0400
Message-ID: <20111025010852.749199048@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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


