From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: simplify move_pages and copy_pages
Date: Tue, 29 Nov 2011 18:38:59 +0100
Message-ID: <1322588339-24409-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After commit a65917156e34594 ("Btrfs: stop using highmem for
extent_buffers") we don't need to kmap_atomic anymore and can simplify
both functions.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9472d3d..9e04d9b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4238,16 +4238,9 @@ static void move_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long len)
 {
 	char *dst_kaddr = page_address(dst_page);
-	if (dst_page == src_page) {
-		memmove(dst_kaddr + dst_off, dst_kaddr + src_off, len);
-	} else {
-		char *src_kaddr = page_address(src_page);
-		char *p = dst_kaddr + dst_off + len;
-		char *s = src_kaddr + src_off + len;
+	char *src_kaddr = page_address(src_page);
 
-		while (len--)
-			*--p = *--s;
-	}
+	memmove(dst_kaddr + dst_off, src_kaddr + src_off, len);
 }
 
 static inline bool areas_overlap(unsigned long src, unsigned long dst, unsigned long len)
@@ -4261,14 +4254,10 @@ static void copy_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long len)
 {
 	char *dst_kaddr = page_address(dst_page);
-	char *src_kaddr;
+	char *src_kaddr = page_address(src_page);
 
-	if (dst_page != src_page) {
-		src_kaddr = page_address(src_page);
-	} else {
-		src_kaddr = dst_kaddr;
+		if (dst_page == src_page)
 		BUG_ON(areas_overlap(src_off, dst_off, len));
-	}
 
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
 }
-- 
1.7.7.3

