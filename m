From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix compile warnings in extent_io.c
Date: Mon, 23 Apr 2012 13:58:01 -0400
Message-ID: <1335203881-7899-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

These warnings are bogus since we will always have at least one page in an
eb, but to make the compiler happy just set ret = 0 in these two cases.
Thanks,
Btrfs: fix compile warnings in extent_io.c

These warnings are bogus since we will always have at least one page in an
eb, but to make the compiler happy just set ret = 0 in these two cases.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 308c1c2..4ecd080 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1927,7 +1927,7 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
 	u64 start = eb->start;
 	unsigned long i, num_pages = num_extent_pages(eb->start, eb->len);
-	int ret;
+	int ret = 0;
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
@@ -3152,7 +3152,7 @@ static int write_one_eb(struct extent_buffer *eb,
 	u64 offset = eb->start;
 	unsigned long i, num_pages;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE);
-	int ret;
+	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
-- 
1.7.7.6

