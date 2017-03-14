Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33948 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750847AbdCNIFT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:05:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 2/7] btrfs-progs: convert: Introduce simple range structure for convert reserved ranges
Date: Tue, 14 Mar 2017 16:05:04 +0800
Message-ID: <20170314080509.31163-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
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
 convert/common.h | 27 +++++++++++++++++++++++++++
 convert/main.c   |  1 +
 2 files changed, 28 insertions(+)

diff --git a/convert/common.h b/convert/common.h
index 0d3adeaa..28ca1461 100644
--- a/convert/common.h
+++ b/convert/common.h
@@ -26,6 +26,33 @@
 #include "common-defs.h"
 #include "extent-cache.h"
 
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
+const static struct simple_range btrfs_reserved_ranges[] = {
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
+static inline u64 range_end(const struct simple_range *range)
+{
+	return (range->start + range->len);
+}
+
 struct btrfs_mkfs_config;
 
 struct btrfs_convert_context {
diff --git a/convert/main.c b/convert/main.c
index 079c1ebd..41309645 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -81,6 +81,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <getopt.h>
+#include <stdbool.h>
 
 #include "ctree.h"
 #include "disk-io.h"
-- 
2.12.0



