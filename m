Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:49097 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756447AbbJICR0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:17:26 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992Gg2b022701
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:16:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 05/23] btrfs: qgroup: Introduce function to reserve data range per inode
Date: Fri, 9 Oct 2015 10:15:05 +0800
Message-ID: <1444356905-31410-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function reserve_data_range().
This function will find non-overlap range and to insert it into reserve
map using previously introduced functions.

This provides the basis for later per inode reserve map implement.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add needed parameter for later trace functions
---
 fs/btrfs/qgroup.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b690b02..3bdf28e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2701,6 +2701,101 @@ static int insert_data_ranges(struct btrfs_qgroup_data_rsv_map *map,
 }
 
 /*
+ * Check qgroup limit and insert dirty range into reserve_map.
+ *
+ * Must be called with map->lock hold
+ */
+static int reserve_data_range(struct btrfs_root *root,
+			      struct btrfs_qgroup_data_rsv_map *map,
+			      struct data_rsv_range *tmp,
+			      struct ulist *insert_list, u64 start, u64 len,
+			      u64 *reserved)
+{
+	struct data_rsv_range *range;
+	u64 cur_start = 0;
+	u64 cur_len = 0;
+	u64 reserve = 0;
+	int ret = 0;
+
+	range = find_reserve_range(map, start);
+	/* empty tree, insert the whole range */
+	if (!range) {
+		reserve = len;
+		ret = ulist_add(insert_list, start, len, GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+		goto insert;
+	}
+
+	/* For case range is covering the leading part */
+	if (range->start <= start && range->start + range->len > start)
+		cur_start = range->start + range->len;
+	else
+		cur_start = start;
+
+	/*
+	 * iterate until the end of the range.
+	 * Like the following:
+	 *
+	 *	|<--------desired---------------------->|
+	 *|//1//|	|////2//|	|///3///|	<- exists
+	 * Then we will need to insert the following
+	 *	|\\\4\\\|	|\\\5\\\|	|\\\6\\\|
+	 * And only add qgroup->reserved for rang 4,5,6.
+	 */
+	while (cur_start < start + len) {
+		struct rb_node *next_node;
+		u64 next_start;
+
+		if (range->start + range->len <= cur_start) {
+			/*
+			 * Move to next range if current range is before
+			 * cur_start
+			 * e.g range is 1, cur_start is the end of range 1.
+			 */
+			next_node = rb_next(&range->node);
+			if (!next_node) {
+				/*
+				 * no next range, fill the rest
+				 * e.g range is 3, cur_start is end of range 3.
+				 */
+				cur_len = start + len - cur_start;
+				next_start = start + len;
+			} else {
+				range = rb_entry(next_node,
+						 struct data_rsv_range, node);
+				cur_len = min(range->start, start + len) -
+					  cur_start;
+				next_start = range->start + range->len;
+			}
+		} else {
+			/*
+			 * current range is already after cur_start
+			 * e.g range is 2, cur_start is end of range 1.
+			 */
+			cur_len = min(range->start, start + len) - cur_start;
+			next_start = range->start + range->len;
+		}
+		reserve += cur_len;
+		ret = ulist_add(insert_list, cur_start, cur_len, GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+
+		cur_start = next_start;
+	}
+insert:
+	ret = btrfs_qgroup_reserve(root, reserve);
+	if (ret < 0)
+		return ret;
+	/* ranges must be inserted after we are sure it has enough space */
+	ret = insert_data_ranges(map, tmp, insert_list);
+	map->reserved += reserve;
+	if (reserved)
+		*reserved = reserve;
+	return ret;
+}
+
+/*
  * Init data_rsv_map for a given inode.
  *
  * This is needed at write time as quota can be disabled and then enabled
-- 
2.6.1

