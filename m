From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: remove BUG_ON() in compress_file_range()
Date: Thu, 08 Sep 2011 10:22:01 +0800
Message-ID: <4E6826C9.7030603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It's not a big deal if we fail to allocate the array, and instead of
panic we can just give up compressing.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..63b4fc0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -393,7 +393,10 @@ again:
 	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
-		BUG_ON(!pages);
+		if (!pages) {
+			/* just bail out to the uncompressed code */
+			goto cont;
+		}
 
 		if (BTRFS_I(inode)->force_compress)
 			compress_type = BTRFS_I(inode)->force_compress;
@@ -424,6 +427,7 @@ again:
 			will_compress = 1;
 		}
 	}
+cont:
 	if (start == 0) {
 		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
-- 1.7.3.1 
