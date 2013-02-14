Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:59563 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990Ab3BNUuY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 15:50:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Chris Mason <chris.mason@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] btrfs: fixup/remove module.h usage as required
Date: Thu, 14 Feb 2013 15:50:15 -0500
Message-ID: <1360875015-4260-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want to avoid module.h where posible, since it in turn includes
nearly all of header space.  This means removing it where it is not
required, and using export.h where we are only exporting symbols via
EXPORT_SYMBOL and friends.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[build tested on x86-64 and ppc on today's raid56-experimental branch]

 fs/btrfs/extent_io.c  | 1 -
 fs/btrfs/extent_map.c | 1 -
 fs/btrfs/sysfs.c      | 1 -
 fs/btrfs/ulist.c      | 2 +-
 4 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 907ed00..4c36420 100644
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
index ed88f5e..a84ae95 100644
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
index 99be4c1..ddc61ca 100644
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
1.8.1.2

