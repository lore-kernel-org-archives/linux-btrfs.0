Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:59189 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbeASFhr (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:37:47 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 04/16] btrfs-progs: check: Move node_ptr structure to check/common.h
Date: Fri, 19 Jan 2018 13:37:19 +0800
Message-Id: <20180119053731.10795-5-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.h | 39 +++++++++++++++++++++++++++++++++++++++
 check/main.c   | 11 +----------
 2 files changed, 40 insertions(+), 10 deletions(-)
 create mode 100644 check/common.h

diff --git a/check/common.h b/check/common.h
new file mode 100644
index 000000000000..25874aec597b
--- /dev/null
+++ b/check/common.h
@@ -0,0 +1,39 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+/*
+ * Defines and function declarations for code shared by both lowmem and
+ * original mode
+ */
+#ifndef __BTRFS_CHECK_COMMON_H__
+#define __BTRFS_CHECK_COMMON_H__
+#include "ctree.h"
+
+/*
+ * Use for tree walk to walk through trees whose leaves/nodes can be shared
+ * between different trees. (Namely subvolume/fs trees)
+ */
+struct node_refs {
+	u64 bytenr[BTRFS_MAX_LEVEL];
+	u64 refs[BTRFS_MAX_LEVEL];
+	int need_check[BTRFS_MAX_LEVEL];
+	/* field for checking all trees */
+	int checked[BTRFS_MAX_LEVEL];
+	/* the corresponding extent should be marked as full backref or not */
+	int full_backref[BTRFS_MAX_LEVEL];
+};
+
+#endif
diff --git a/check/main.c b/check/main.c
index dbd2b755c48f..fbd73c42bee8 100644
--- a/check/main.c
+++ b/check/main.c
@@ -45,6 +45,7 @@
 #include "help.h"
 #include "check/original.h"
 #include "check/lowmem.h"
+#include "check/common.h"
 
 enum task_position {
 	TASK_EXTENTS,
@@ -1667,16 +1668,6 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 	return ret;
 }
 
-struct node_refs {
-	u64 bytenr[BTRFS_MAX_LEVEL];
-	u64 refs[BTRFS_MAX_LEVEL];
-	int need_check[BTRFS_MAX_LEVEL];
-	/* field for checking all trees */
-	int checked[BTRFS_MAX_LEVEL];
-	/* the corresponding extent should be marked as full backref or not */
-	int full_backref[BTRFS_MAX_LEVEL];
-};
-
 static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
 			     struct extent_buffer *eb, struct node_refs *nrefs,
 			     u64 level, int check_all);
-- 
2.15.1

