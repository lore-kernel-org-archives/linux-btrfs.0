From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] Btrfs: Check for NULL page in extent_range_uptodate
Date: Wed, 25 Jan 2012 13:03:44 -0600
Message-ID: <1327518224-4103-1-git-send-email-mitch.harder@sabayonlinux.org>
Mime-Version: 1.0
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user has encountered a NULL pointer kernel oops in btrfs when
encountering media errors.  The problem has been identified
as an unhandled NULL pointer returned from find_get_page().
This modification simply checks for a NULL page, and returns
with an error if found (the extent_range_uptodate() function
returns 1 on errors).

After testing this patch, the user reported that the error with
the NULL pointer oops was solved.  However, there is still a
remaining problem with a thread becoming stuck in
wait_on_page_locked(page) in the read_extent_buffer_pages(...)
function in extent_io.c

       for (i = start_i; i < num_pages; i++) {
               page = extent_buffer_page(eb, i);
               wait_on_page_locked(page);
               if (!PageUptodate(page))
                       ret = -EIO;
       }

This patch leaves the issue with the locked page yet to be resolved.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/extent_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9d09a4f..fcf77e1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3909,6 +3909,8 @@ int extent_range_uptodate(struct extent_io_tree *tree,
 	while (start <= end) {
 		index = start >> PAGE_CACHE_SHIFT;
 		page = find_get_page(tree->mapping, index);
+		if (!page)
+			return 1;
 		uptodate = PageUptodate(page);
 		page_cache_release(page);
 		if (!uptodate) {
-- 
1.7.3.4

