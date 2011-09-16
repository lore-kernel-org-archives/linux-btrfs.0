From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix pages truncation in btrfs_ioctl_clone()
Date: Fri, 16 Sep 2011 16:59:53 +0800
Message-ID: <4E731009.2030202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It's a bug in commit f81c9cdc567cd3160ff9e64868d9a1a7ee226480
(Btrfs: truncate pages from clone ioctl target range)

We should pass the dest range to the truncate function, but not the
src range.

Also move the function before locking extent state.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5492bb3..f6af8b0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2237,6 +2237,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			goto out_unlock;
 	}
 
+	/* truncate page cache pages from target inode range */
+	truncate_inode_pages_range(&inode->i_data, destoff,
+				   PAGE_CACHE_ALIGN(destoff + len) - 1);
+
 	/* do any pending delalloc/csum calc on src, one way or
 	   another, and lock file content */
 	while (1) {
@@ -2253,10 +2257,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		btrfs_wait_ordered_range(src, off, len);
 	}
 
-	/* truncate page cache pages from target inode range */
-	truncate_inode_pages_range(&inode->i_data, off,
-				   ALIGN(off + len, PAGE_CACHE_SIZE) - 1);
-
 	/* clone data */
 	key.objectid = btrfs_ino(src);
 	key.type = BTRFS_EXTENT_DATA_KEY;
-- 
1.7.3.1
