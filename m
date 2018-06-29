Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966221AbeF2I4t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:49 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15CF4AD67
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/14] btrfs: prune unused includes
Date: Fri, 29 Jun 2018 10:56:47 +0200
Message-Id: <5df591b4bc0429e1aac5154531798e8f4838c9cb.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove includes if none of the interfaces and exports is used in the
given source file.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c  |  4 ----
 fs/btrfs/dev-replace.c  |  5 -----
 fs/btrfs/disk-io.c      |  2 --
 fs/btrfs/file.c         |  3 ---
 fs/btrfs/inode-map.c    |  1 -
 fs/btrfs/inode.c        |  4 ----
 fs/btrfs/ioctl.c        |  5 -----
 fs/btrfs/ordered-data.c |  1 -
 fs/btrfs/raid56.c       | 13 -------------
 fs/btrfs/reada.c        |  1 -
 fs/btrfs/struct-funcs.c |  1 -
 fs/btrfs/super.c        |  3 ---
 fs/btrfs/sysfs.c        |  2 --
 fs/btrfs/volumes.c      |  3 ---
 14 files changed, 48 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d3e447b45bf7..f48794a36068 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -5,7 +5,6 @@
 
 #include <linux/kernel.h>
 #include <linux/bio.h>
-#include <linux/buffer_head.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
@@ -14,10 +13,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/backing-dev.h>
-#include <linux/mpage.h>
-#include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/bit_spinlock.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/log2.h>
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e2ba0419297a..819440204fd5 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -6,14 +6,9 @@
 #include <linux/sched.h>
 #include <linux/bio.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
 #include <linux/blkdev.h>
-#include <linux/random.h>
-#include <linux/iocontext.h>
-#include <linux/capability.h>
 #include <linux/kthread.h>
 #include <linux/math64.h>
-#include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
 #include "disk-io.h"
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7ee825b96187..efdfbd334b85 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -5,8 +5,6 @@
 
 #include <linux/fs.h>
 #include <linux/blkdev.h>
-#include <linux/scatterlist.h>
-#include <linux/swap.h>
 #include <linux/radix-tree.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 11e43e69d12f..9f11ce754f75 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -5,14 +5,11 @@
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
-#include <linux/highmem.h>
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/backing-dev.h>
-#include <linux/mpage.h>
 #include <linux/falloc.h>
-#include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 12fcd8897c33..c120b8e25a3e 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2007 Oracle.  All rights reserved.
  */
 
-#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/pagemap.h>
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f30608dc038b..02e12e8bffc4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -14,17 +14,13 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/backing-dev.h>
-#include <linux/mpage.h>
-#include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/compat.h>
-#include <linux/bit_spinlock.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/falloc.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
-#include <linux/mount.h>
 #include <linux/btrfs.h>
 #include <linux/blkdev.h>
 #include <linux/posix_acl_xattr.h>
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5556e9ea2a4b..a78a2c8cbd09 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5,23 +5,18 @@
 
 #include <linux/kernel.h>
 #include <linux/bio.h>
-#include <linux/buffer_head.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fsnotify.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
-#include <linux/mpage.h>
 #include <linux/namei.h>
-#include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/compat.h>
-#include <linux/bit_spinlock.h>
 #include <linux/security.h>
 #include <linux/xattr.h>
 #include <linux/mm.h>
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2e1a1694a33d..6055d357ce4c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -6,7 +6,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include "ctree.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 27ed47a23f26..42631079c492 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -5,32 +5,19 @@
  */
 
 #include <linux/sched.h>
-#include <linux/wait.h>
 #include <linux/bio.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
 #include <linux/blkdev.h>
-#include <linux/random.h>
-#include <linux/iocontext.h>
-#include <linux/capability.h>
-#include <linux/ratelimit.h>
-#include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/hash.h>
 #include <linux/list_sort.h>
 #include <linux/raid/xor.h>
 #include <linux/mm.h>
-#include <asm/div64.h>
 #include "ctree.h"
-#include "extent_map.h"
 #include "disk-io.h"
-#include "transaction.h"
-#include "print-tree.h"
 #include "volumes.h"
 #include "raid56.h"
 #include "async-thread.h"
-#include "check-integrity.h"
-#include "rcu-string.h"
 
 /* set when additional merges to this rbio are not allowed */
 #define RBIO_RMW_LOCKED_BIT	1
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 40f1bcef394d..83d49f2e7bc6 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -7,7 +7,6 @@
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
-#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include "ctree.h"
diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index b7b4acb12833..4c13b737f568 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2007 Oracle.  All rights reserved.
  */
 
-#include <linux/highmem.h>
 #include <asm/unaligned.h>
 
 #include "ctree.h"
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 81107ad49f3a..a264bea21c3a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -5,7 +5,6 @@
 
 #include <linux/blkdev.h>
 #include <linux/module.h>
-#include <linux/buffer_head.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -15,8 +14,6 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
-#include <linux/mpage.h>
-#include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/statfs.h>
 #include <linux/compat.h>
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4a4e960c7c66..3717c864ba23 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -7,10 +7,8 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
-#include <linux/buffer_head.h>
 #include <linux/kobject.h>
 #include <linux/bug.h>
-#include <linux/genhd.h>
 #include <linux/debugfs.h>
 
 #include "ctree.h"
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e034ad9e23b4..f768cb7a1913 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8,15 +8,12 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
-#include <linux/iocontext.h>
-#include <linux/capability.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
 #include <linux/uuid.h>
 #include <linux/list_sort.h>
-#include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
 #include "disk-io.h"
-- 
2.17.1

