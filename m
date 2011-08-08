From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: ratelimit the generation printk for the free space cache
Date: Mon,  8 Aug 2011 08:27:46 -0400
Message-ID: <1312806466-3142-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported getting spammed when moving to 3.0 by this message.  Since we
switched to the normal checksumming infrastructure all old free space caches
will be wrong and need to be regenerated so people are likely to see this
message a lot, so ratelimit it so it doesn't fill up their logs and freak them
out.  Thanks,

Reported-by: Andrew Lutomirski <luto@mit.edu>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 85bbac9..44a6323 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/math64.h>
+#include <linux/ratelimit.h>
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
@@ -337,11 +338,12 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 
 			gen = addr;
 			if (*gen != BTRFS_I(inode)->generation) {
-				printk(KERN_ERR "btrfs: space cache generation"
-				       " (%llu) does not match inode (%llu)\n",
-				       (unsigned long long)*gen,
-				       (unsigned long long)
-				       BTRFS_I(inode)->generation);
+				printk_ratelimited(KERN_ERR "btrfs: space cache"
+					" generation (%llu) does not match "
+					"inode (%llu)\n",
+					(unsigned long long)*gen,
+					(unsigned long long)
+					BTRFS_I(inode)->generation);
 				kunmap(page);
 				unlock_page(page);
 				page_cache_release(page);
-- 
1.7.5.2

