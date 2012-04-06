From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 3/4 RESEND] Btrfs: fix btrfs_release_extent_buffer_page with
 the right usage of num_extent_pages
Date: Fri, 06 Apr 2012 14:35:31 +0800
Message-ID: <4F7E8EB3.4070609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

num_extent_pages returns the number of pages in the specific range, not
the index of the last page in the eb range.

btrfs_release_extent_buffer_page is called with start_idx set 0 in current
codes, so it's not a problem yet. But the logic is indeed wrong.

Fix it here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5505356..ddfc1d5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3975,11 +3975,13 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 						unsigned long start_idx)
 {
 	unsigned long index;
+	unsigned long num_pages;
 	struct page *page;
 
 	BUG_ON(extent_buffer_under_io(eb));
 
-	index = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb->start, eb->len);
+	index = start_idx + num_pages;
 	if (start_idx >= index)
 		return;
 
-- 
1.7.1
