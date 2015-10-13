Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64609 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932132AbbJMCUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 22:20:33 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9D2K1Q1012662
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 10:20:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 01/21] btrfs: extent_io: Introduce needed structure for recoding set/clear bits
Date: Tue, 13 Oct 2015 10:20:07 +0800
Message-Id: <1444702827-18169-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new structure, extent_change_set, to record how many bytes are
changed in one set/clear_extent_bits() operation, with detailed changed
ranges info.

This provides the needed facilities for later qgroup reserve framework.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v3:
  Newly introduced, to reuse existing extent_io facilities.
---
 fs/btrfs/extent_io.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c668f36..3107a6e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -2,6 +2,7 @@
 #define __EXTENTIO__
 
 #include <linux/rbtree.h>
+#include "ulist.h"
 
 /* bits for the extent state */
 #define EXTENT_DIRTY		(1U << 0)
@@ -161,6 +162,17 @@ struct extent_buffer {
 #endif
 };
 
+/*
+ * Structure to record how many bytes and which ranges are set/cleared
+ */
+struct extent_changeset {
+	/* How many bytes are set/cleared in this operation */
+	u64 bytes_changed;
+
+	/* Changed ranges */
+	struct ulist *range_changed;
+};
+
 static inline void extent_set_compress_type(unsigned long *bio_flags,
 					    int compress_type)
 {
-- 
2.6.1

