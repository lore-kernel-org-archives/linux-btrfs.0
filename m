From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: truncate pages from clone ioctl target range
Date: Wed, 10 Aug 2011 11:04:04 -0700
Message-ID: <1312999444-20475-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We need to truncate page cache pages for the clone ioctl target range or
else we'll confuse ourselves to no end.  If the old data was cached, we
used to still see it (until remount).  If the page was partially updated
we used to get a mix of old and new data.

Signed-off-by: Sage Weil <sage@newdream.net>
---
v1->v2: use ALIGN macro

 fs/btrfs/ioctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 514c0eb..5acb8e1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2243,6 +2243,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		btrfs_wait_ordered_range(src, off, len);
 	}
 
+	/* truncate page cache pages from target inode range */
+	truncate_inode_pages_range(&inode->i_data, off,
+				   ALIGN(off + len, PAGE_CACHE_SIZE) - 1);
+
 	/* clone data */
 	key.objectid = btrfs_ino(src);
 	key.type = BTRFS_EXTENT_DATA_KEY;
-- 
1.7.0

