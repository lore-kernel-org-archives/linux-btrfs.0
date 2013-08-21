Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3HUHca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 03:32:30 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Josef Bacik <jbacik@fusionio.com>, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] btrfs: reuse kbasename helper
Date: Wed, 21 Aug 2013 10:32:13 +0300
Message-Id: <1377070333-29089-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To get name of the file from a pathname let's use kbasename() helper. It allows
to simplify code a bit.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Since v1:
- fix build warnings
 fs/btrfs/send.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d3f3b43..f5281cc 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -26,6 +26,7 @@
 #include <linux/radix-tree.h>
 #include <linux/crc32c.h>
 #include <linux/vmalloc.h>
+#include <linux/string.h>
 
 #include "send.h"
 #include "backref.h"
@@ -2581,7 +2582,6 @@ static int record_ref(struct list_head *head, u64 dir,
 		      u64 dir_gen, struct fs_path *path)
 {
 	struct recorded_ref *ref;
-	char *tmp;
 
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
 	if (!ref)
@@ -2591,20 +2591,14 @@ static int record_ref(struct list_head *head, u64 dir,
 	ref->dir_gen = dir_gen;
 	ref->full_path = path;
 
-	tmp = strrchr(ref->full_path->start, '/');
-	if (!tmp) {
-		ref->name_len = ref->full_path->end - ref->full_path->start;
-		ref->name = ref->full_path->start;
+	ref->name = (char *)kbasename(ref->full_path->start);
+	ref->name_len = ref->full_path->end - ref->name;
+	ref->dir_path = ref->full_path->start;
+	if (ref->name == ref->full_path->start)
 		ref->dir_path_len = 0;
-		ref->dir_path = ref->full_path->start;
-	} else {
-		tmp++;
-		ref->name_len = ref->full_path->end - tmp;
-		ref->name = tmp;
-		ref->dir_path = ref->full_path->start;
+	else
 		ref->dir_path_len = ref->full_path->end -
 				ref->full_path->start - 1 - ref->name_len;
-	}
 
 	list_add_tail(&ref->list, head);
 	return 0;
-- 
1.8.4.rc2

