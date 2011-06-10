From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: remove unneeded includes from scrub.c
Date: Fri, 10 Jun 2011 15:01:09 +0200
Message-ID: <1307710869-19304-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 92cac19..a8d03d5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -16,13 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#include <linux/sched.h>
-#include <linux/pagemap.h>
-#include <linux/writeback.h>
 #include <linux/blkdev.h>
-#include <linux/rbtree.h>
-#include <linux/slab.h>
-#include <linux/workqueue.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "disk-io.h"
-- 
1.7.3.4

