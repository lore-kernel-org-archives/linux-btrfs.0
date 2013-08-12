Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8265 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab3HLLlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 07:41:23 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] btrfs: reuse kbasename helper
Date: Mon, 12 Aug 2013 14:41:10 +0300
Message-Id: <1376307670-27010-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To get name of the file from a pathname let's use kbasename() helper. It allows
to simplify code a bit.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/btrfs/send.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d3f3b43..4fdc99d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -26,6 +26,7 @@
 #include <linux/radix-tree.h>
 #include <linux/crc32c.h>
 #include <linux/vmalloc.h>
+#include <linux/string.h>
 
 #include "send.h"
 #include "backref.h"
@@ -2591,20 +2592,14 @@ static int record_ref(struct list_head *head, u64 dir,
 	ref->dir_gen = dir_gen;
 	ref->full_path = path;
 
-	tmp = strrchr(ref->full_path->start, '/');
-	if (!tmp) {
-		ref->name_len = ref->full_path->end - ref->full_path->start;
-		ref->name = ref->full_path->start;
+	ref->name = kbasename(ref->full_path->start);
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
1.8.4.rc1

