From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: remove duplicate memset in prepare_pages
Date: Tue, 25 Jan 2011 15:11:13 -0500
Message-ID: <1295986273-30308-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We already memset the pages array in __btrfs_buffered_write, there's no need to
do it again in prepare_pages.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c0f312a..fd89c5c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -788,7 +788,6 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 			return err;
 	}
 
-	memset(pages, 0, num_pages * sizeof(struct page *));
 again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = grab_cache_page(inode->i_mapping, index + i);
-- 
1.6.6.1

