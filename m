From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: truncate pages from clone ioctl target range
Date: Tue,  9 Aug 2011 12:00:41 -0700
Message-ID: <1312916441-23662-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We need to truncate page cache pages for the clone ioctl target range or
else we'll confuse ourselves to no end.  If the old data was cached, we'll
still see it (until remount).  If it was dirty we'll get a mix of old and
new data if the page(s) are partially updated.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..cac9491 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2243,6 +2243,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		btrfs_wait_ordered_range(src, off, len);
 	}
 
+	/* truncate page cache pages from target inode range */
+	truncate_inode_pages_range(&inode->i_data, off,
+			      ((off+len+PAGE_CACHE_SIZE-1)&PAGE_CACHE_MASK)-1);
+
 	/* clone data */
 	key.objectid = btrfs_ino(src);
 	key.type = BTRFS_EXTENT_DATA_KEY;
-- 
1.7.0

