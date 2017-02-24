Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60453 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750997AbdBXFya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 00:54:30 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH v2 4/9] btrfs-progs: convert: Introduce simple range structure for convert reserved ranges
Date: Fri, 24 Feb 2017 13:52:27 +0800
Message-ID: <20170224055232.4140-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
References: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new strucutre, simple_range, to present one continuous
range.

Also, use such structure to define btrfs_reserved_ranges(), which
convert and rollback will use.

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index 26356e8a..ba088cc3 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -86,6 +86,7 @@
 #include <uuid/uuid.h>
 #include <linux/limits.h>
 #include <getopt.h>
+#include <stdbool.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -118,6 +119,33 @@
 
 #define CONV_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
 
+/*
+ * Presents one simple continuous range.
+ *
+ * For multiple or non-continuous ranges, use extent_cache_tree from
+ * extent-cache.c
+ */
+struct simple_range {
+	u64 start;
+	u64 len;
+};
+
+static struct simple_range btrfs_reserved_ranges[] = {
+	{0, SZ_1M},
+	{BTRFS_SB_MIRROR_OFFSET(1), SZ_64K},
+	{BTRFS_SB_MIRROR_OFFSET(2), SZ_64K}
+};
+
+/*
+ * Simple range functions
+ *
+ * Get range end (exclusive)
+ */
+static inline u64 range_end(struct simple_range *range)
+{
+	return (range->start + range->len);
+}
+
 struct task_ctx {
 	uint32_t max_copy_inodes;
 	uint32_t cur_copy_inodes;
-- 
2.11.1



