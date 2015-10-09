Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:54128 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932265AbbJICU6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:20:58 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992KBMM022962
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:20:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 07/23] btrfs: qgroup: Introduce function to release reserved range
Date: Fri, 9 Oct 2015 10:18:33 +0800
Message-ID: <1444357115-32088-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function release_data_range() to release reserved ranges.
It will iterate through all existing ranges and remove/shrink them.

Note this function will not free reserved space, as the range can be
released in the following conditions:
1) The dirty range gets written to disk.
   In this case, reserved range will be released but reserved bytes
   will not be freed until the delayed_ref is run.

2) Truncate
   In this case, dirty ranges will be released and reserved bytes will
   also be freed.

So the new function won't free reserved space, but record them into
parameter if called needs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add parameter for later trace functions
---
 fs/btrfs/qgroup.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e840f5c..9934929 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2852,6 +2852,139 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 	return ret;
 }
 
+/* Small helper used in release_data_range() to update rsv map */
+static inline void __update_rsv(struct btrfs_qgroup_data_rsv_map *map,
+				u64 *reserved, u64 cur_rsv)
+{
+	if (WARN_ON(map->reserved < cur_rsv)) {
+		if (reserved)
+			*reserved += map->reserved;
+		map->reserved = 0;
+	} else {
+		if (reserved)
+			*reserved += cur_rsv;
+		map->reserved -= cur_rsv;
+	}
+}
+
+/*
+ * Release the range [start, start + len) from rsv map.
+ *
+ * The behavior should be much like reserve_data_range().
+ * @tmp: the allocated memory for case which need to split existing
+ *       range into two.
+ * @reserved: the number of bytes that may need to free
+ * Return > 0 if 'tmp' memory is used and release range successfully
+ * Return 0 if 'tmp' memory is not used and release range successfully
+ * Return < 0 for error
+ */
+static int release_data_range(struct btrfs_qgroup_data_rsv_map *map,
+			      struct data_rsv_range *tmp,
+			      u64 start, u64 len, u64 *reserved)
+{
+	struct data_rsv_range *range;
+	u64 cur_rsv = 0;
+	int ret = 0;
+
+	range = find_reserve_range(map, start);
+	/* empty tree, just return */
+	if (!range)
+		return 0;
+	/*
+	 * For split case
+	 *		|<----desired---->|
+	 * |////////////////////////////////////////////|
+	 * In this case, we need to insert one new range.
+	 */
+	if (range->start < start && range->start + range->len > start + len) {
+		u64 new_start = start + len;
+		u64 new_len = range->start + range->len - start - len;
+
+		cur_rsv = len;
+		if (reserved)
+			*reserved += cur_rsv;
+		map->reserved -= cur_rsv;
+
+		range->len = start - range->start;
+		ret = insert_data_range(map, tmp, new_start, new_len);
+		WARN_ON(ret <= 0);
+		return 1;
+	}
+
+	/*
+	 * Iterate until the end of the range and free release all
+	 * reserved data from map.
+	 * We iterate by existing range, as that will makes codes a
+	 * little more clean.
+	 *
+	 *	|<---------desired------------------------>|
+	 * |//1//|	|//2//|		|//3//|		|//4//|
+	 */
+	while (range->start < start + len) {
+		struct rb_node *next = NULL;
+		int range_freed = 0;
+
+		/*
+		 *		|<---desired---->|
+		 * |///////|
+		 */
+		if (unlikely(range->start + range->len <= start))
+			goto next;
+
+		/*
+		 *	|<----desired---->|
+		 * |///////|
+		 */
+		if (range->start < start &&
+		    range->start + range->len > start) {
+			cur_rsv = range->start + range->len - start;
+
+			range->len = start - range->start;
+			goto next;
+		}
+
+		/*
+		 *	|<--desired-->|
+		 *	    |/////|
+		 * Including same start/end case, so other case don't need
+		 * to check start/end equal case and don't need bother
+		 * deleting range.
+		 */
+		if (range->start >= start &&
+		    range->start + range->len <= start + len) {
+			cur_rsv = range->len;
+
+			range_freed = 1;
+			next = rb_next(&range->node);
+			rb_erase(&range->node, &map->root);
+			kfree(range);
+			goto next;
+
+		}
+
+		/*
+		 *	|<--desired-->|
+		 *		  |///////|
+		 */
+		if (range->start < start + len &&
+		    range->start + range->len > start + len) {
+			cur_rsv = start + len - range->start;
+
+			range->len = range->start + range->len - start - len;
+			range->start = start + len;
+			goto next;
+		}
+next:
+		__update_rsv(map, reserved, cur_rsv);
+		if (!range_freed)
+			next = rb_next(&range->node);
+		if (!next)
+			break;
+		range = rb_entry(next, struct data_rsv_range, node);
+	}
+	return 0;
+}
+
 /*
  * Init data_rsv_map for a given inode.
  *
-- 
2.6.1

