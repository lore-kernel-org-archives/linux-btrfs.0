Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28309 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbbIAHYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 03:24:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t817O5R1021460
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 15:24:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 03/14] btrfs: qgroup: Introduce new function to search most left reserve range
Date: Tue, 1 Sep 2015 15:22:00 +0800
Message-ID: <1441092131-14088-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce the new function to search the most left reserve range in a
reserve map.

It provides the basis for later reserve map implement.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2e9a93f..e19fe6a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2513,6 +2513,42 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 }
 
 /*
+ * Return the nearest left range of given start
+ * No ensure about the range will cover start.
+ */
+static struct data_rsv_range *
+find_reserve_range(struct btrfs_qgroup_data_rsv_map *map, u64 start)
+{
+	struct rb_node **p = &map->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct rb_node *prev = NULL;
+	struct data_rsv_range *range = NULL;
+
+	while (*p) {
+		parent = *p;
+		range = rb_entry(parent, struct data_rsv_range, node);
+		if (range->start < start)
+			p = &(*p)->rb_right;
+		else if (range->start > start)
+			p = &(*p)->rb_left;
+		else
+			return range;
+	}
+
+	/* empty tree */
+	if (!parent)
+		return NULL;
+	if (range->start <= start)
+		return range;
+
+	prev = rb_prev(parent);
+	/* Already most left one */
+	if (!prev)
+		return range;
+	return rb_entry(prev, struct data_rsv_range, node);
+}
+
+/*
  * Init data_rsv_map for a given inode.
  *
  * This is needed at write time as quota can be disabled and then enabled
-- 
2.5.1

