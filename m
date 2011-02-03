From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure search_bitmap finds something in remove_from_bitmap
Date: Wed,  2 Feb 2011 21:39:52 -0500
Message-ID: <1296700792-16850-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we're cleaning up the tree log we need to be able to remove free space from
the block group.  The problem is if that free space spans bitmaps we would not
find the space since we're looking for too many bytes.  So make sure the amount
of bytes we search for is limited to either the number of bytes we want, or the
number of bytes left in the bitmap.  This was tested by a user who was hitting
the BUG() after search_bitmap.  With this patch he can now mount his fs.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e92a8d6..552cb9f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1197,6 +1197,7 @@ again:
 	 */
 	search_start = *offset;
 	search_bytes = *bytes;
+	search_bytes = min(search_bytes, end - search_start + 1);
 	ret = search_bitmap(block_group, bitmap_info, &search_start,
 			    &search_bytes);
 	BUG_ON(ret < 0 || search_start != *offset);
-- 
1.7.2.3

