From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: handle no memory properly in prepare_pages
Date: Tue, 25 Jan 2011 17:11:54 -0500
Message-ID: <1295993514-29043-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Instead of doing a BUG_ON(1) in prepare_pages if grab_cache_page() fails, just
loop through the pages we've already grabbed and unlock and release them, then
return -ENOMEM like we should.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f4eef63..416eee8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -790,8 +790,12 @@ again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = grab_cache_page(inode->i_mapping, index + i);
 		if (!pages[i]) {
-			err = -ENOMEM;
-			BUG_ON(1);
+			int c;
+			for (c = i - 1; c >= 0; c--) {
+				unlock_page(pages[c]);
+				page_cache_release(pages[c]);
+			}
+			return -ENOMEM;
 		}
 		wait_on_page_writeback(pages[i]);
 	}
-- 
1.6.6.1

