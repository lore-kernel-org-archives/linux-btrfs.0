Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47801 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdJYCzG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 22:55:06 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/6] btrfs: qgroup: Introduce helpers to update and access new qgroup rsv
Date: Wed, 25 Oct 2017 10:54:41 +0800
Message-Id: <20171025025445.16617-3-wqu@suse.com>
In-Reply-To: <20171025025445.16617-1-wqu@suse.com>
References: <20171025025445.16617-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce helpers to:

1) Get total reserved space
   For limit calculation
2) Add/release reserved space for given type
   With underflow detection and warning
3) Add/release reserved space according to child qgroup

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index fe3adb996883..161f16c40264 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -47,6 +47,74 @@
  *  - check all ioctl parameters
  */
 
+/*
+ * Helpers to access qgroup reservation
+ *
+ * Callers should ensure the lock context and type are valid
+ */
+
+static u64 qgroup_rsv_total(const struct btrfs_qgroup *qgroup)
+{
+	u64 ret = 0;
+	int i;
+
+	for (i = 0; i < BTRFS_QGROUP_RSV_LAST; i++)
+		ret += qgroup->rsv.values[i];
+
+	return ret;
+}
+
+#ifdef CONFIG_BTRFS_DEBUG
+static const char *qgroup_rsv_type_str(enum btrfs_qgroup_rsv_type type)
+{
+	if (type == BTRFS_QGROUP_RSV_DATA)
+		return "data";
+	if (type == BTRFS_QGROUP_RSV_META)
+		return "meta";
+	return NULL;
+}
+#endif
+
+static void qgroup_rsv_add(struct btrfs_qgroup *qgroup, u64 num_bytes,
+			   enum btrfs_qgroup_rsv_type type)
+{
+	qgroup->rsv.values[type] += num_bytes;
+}
+
+static void qgroup_rsv_release(struct btrfs_qgroup *qgroup, u64 num_bytes,
+			       enum btrfs_qgroup_rsv_type type)
+{
+	if (qgroup->rsv.values[type] >= num_bytes) {
+		qgroup->rsv.values[type] -= num_bytes;
+		return;
+	}
+#ifdef CONFIG_BTRFS_DEBUG
+	WARN_RATELIMIT(1,
+		"qgroup %llu %s reserved space underflow, have %llu to free %llu",
+		qgroup->qgroupid, qgroup_rsv_type_str(type),
+		qgroup->rsv.values[type], num_bytes);
+#endif
+	qgroup->rsv.values[type] = 0;
+}
+
+static void qgroup_rsv_add_by_qgroup(struct btrfs_qgroup *dest,
+					  struct btrfs_qgroup *src)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_QGROUP_RSV_LAST; i++)
+		qgroup_rsv_add(dest, src->rsv.values[i], i);
+}
+
+static void qgroup_rsv_release_by_qgroup(struct btrfs_qgroup *dest,
+					  struct btrfs_qgroup *src)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_QGROUP_RSV_LAST; i++)
+		qgroup_rsv_release(dest, src->rsv.values[i], i);
+}
+
 static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg, u64 seq,
 					   int mod)
 {
-- 
2.14.2

