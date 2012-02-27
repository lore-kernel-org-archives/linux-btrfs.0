From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] btrfs: fixup module.h usage as required
Date: Sun, 26 Feb 2012 20:16:58 -0500
Message-ID: <1330305418-3507-1-git-send-email-paul.gortmaker@windriver.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Delete the instances of module.h that aren't actually used
or needed.  Replace with export.h as required.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
[This is 100% independent of any cleanups I'm working on, so it
 can go in via the btrfs tree seamlessly.]

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a55fbe6..9452204 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4,7 +4,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
-#include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/swap.h>
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7c97b33..711c877 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1,6 +1,5 @@
 #include <linux/err.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
 #include "ctree.h"
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index daac9ae..5b326cd 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -21,7 +21,6 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
-#include <linux/module.h>
 #include <linux/kobject.h>
 
 #include "ctree.h"
diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 12f5147..273dea8 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -5,7 +5,7 @@
  */
 
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include "ulist.h"
 
 /*
-- 
1.7.9.1

