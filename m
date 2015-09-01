Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47505 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753408AbbIAHYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 03:24:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t817O6mu021463
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 15:24:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 04/14] btrfs: qgroup: Introduce function to insert non-overlap reserve range
Date: Tue, 1 Sep 2015 15:22:01 +0800
Message-ID: <1441092131-14088-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New function insert_data_ranges() will insert non-overlap reserve ranges
into reserve map.

It provides the basis for later qgroup reserve map implement.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e19fe6a..90f5c4b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2549,6 +2549,129 @@ find_reserve_range(struct btrfs_qgroup_data_rsv_map *map, u64 start)
 }
 
 /*
+ * Insert one data range
+ * [start,len) here won't overflap with each other.
+ *
+ * Return 0 if range is inserted and tmp is not used.
+ * Return > 0 if range is inserted and tmp is used.
+ * No catchable error case. Only possible error will cause BUG_ON() as
+ * that's logical error.
+ */
+static int insert_data_range(struct btrfs_qgroup_data_rsv_map *map,
+			     struct data_rsv_range *tmp,
+			     u64 start, u64 len)
+{
+	struct rb_node **p = &map->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct rb_node *tmp_node = NULL;
+	struct data_rsv_range *range = NULL;
+	struct data_rsv_range *prev_range = NULL;
+	struct data_rsv_range *next_range = NULL;
+	int prev_merged = 0;
+	int next_merged = 0;
+	int ret = 0;
+
+	while (*p) {
+		parent = *p;
+		range = rb_entry(parent, struct data_rsv_range, node);
+		if (range->start < start)
+			p = &(*p)->rb_right;
+		else if (range->start > start)
+			p = &(*p)->rb_left;
+		else
+			BUG_ON(1);
+	}
+
+	/* Empty tree, goto isolated case */
+	if (!range)
+		goto insert_isolated;
+
+	/* get adjusted ranges */
+	if (range->start < start) {
+		prev_range = range;
+		tmp_node = rb_next(parent);
+		if (tmp)
+			next_range = rb_entry(tmp_node, struct data_rsv_range,
+					      node);
+	} else {
+		next_range = range;
+		tmp_node = rb_prev(parent);
+		if (tmp)
+			prev_range = rb_entry(tmp_node, struct data_rsv_range,
+					      node);
+	}
+
+	/* try to merge with previous and next ranges */
+	if (prev_range) {
+		if (prev_range->start + prev_range->len == start) {
+			prev_range->len += len;
+			prev_merged = 1;
+		}
+	}
+	if (next_range) {
+		/* prev and next with start,len can be merged */
+		if (prev_merged && start + len == next_range->start) {
+			prev_range->len += next_range->len;
+			next_merged = 1;
+		} else if (start + len == next_range->start) {
+			next_range->start = start;
+			next_range->len += len;
+			rb_erase(&next_range->node, &map->root);
+			kfree(next_range);
+			next_merged = 1;
+		}
+	}
+
+insert_isolated:
+	/* isolated case, need to insert range now */
+	if (!next_merged && !prev_merged) {
+		BUG_ON(!tmp);
+
+		tmp->start = start;
+		tmp->len = len;
+		rb_link_node(&tmp->node, parent, p);
+		rb_insert_color(&tmp->node, &map->root);
+		ret = 1;
+	}
+	return ret;
+}
+
+/*
+ * insert reserve range and merge them if possible
+ *
+ * Return 0 if all inserted and tmp not used
+ * Return > 0 if all inserted and tmp used
+ * No catchable error return value.
+ */
+static int insert_data_ranges(struct btrfs_qgroup_data_rsv_map *map,
+			      struct data_rsv_range *tmp,
+			      struct ulist *insert_list)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	int tmp_used = 0;
+	int ret = 0;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(insert_list, &uiter))) {
+		ret = insert_data_range(map, tmp, unode->val, unode->aux);
+
+		/*
+		 * insert_data_range() won't return error return value,
+		 * no need to hanle <0 case.
+		 *
+		 * Also tmp should be used at most one time, so clear it to
+		 * NULL to cooperate with sanity check in insert_data_range().
+		 */
+		if (ret > 0) {
+			tmp_used = 1;
+			tmp = NULL;
+		}
+	}
+	return tmp_used;
+}
+
+/*
  * Init data_rsv_map for a given inode.
  *
  * This is needed at write time as quota can be disabled and then enabled
-- 
2.5.1

