Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:53103 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdJXIjz (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 04:39:55 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 2/6] btrfs: qgroup: Introduce helpers to update and access new qgroup rsv
Date: Tue, 24 Oct 2017 16:39:37 +0800
Message-Id: <20171024083941.21428-3-wqu@suse.com>
In-Reply-To: <20171024083941.21428-1-wqu@suse.com>
References: <20171024083941.21428-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce helpers to:

1) Get total reserved space
   For limit calculation

2) Increase reserved space for given type
2) Decrease reserved space for given type

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index fe3adb996883..04fd145516ad 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -47,6 +47,72 @@
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
+	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)
+		ret += qgroup->rsv.values[i];
+
+	return ret;
+}
+
+static const char *qgroup_rsv_type_str(enum btrfs_qgroup_rsv_type type)
+{
+	if (type == BTRFS_QGROUP_RSV_DATA)
+		return "data";
+	if (type == BTRFS_QGROUP_RSV_META)
+		return "meta";
+	return NULL;
+}
+
+static void qgroup_rsv_increase(struct btrfs_qgroup *qgroup, u64 num_bytes,
+				enum btrfs_qgroup_rsv_type type)
+{
+	qgroup->rsv.values[type] += num_bytes;
+}
+
+static void qgroup_rsv_decrease(struct btrfs_qgroup *qgroup, u64 num_bytes,
+				enum btrfs_qgroup_rsv_type type)
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
+static void qgroup_rsv_increase_by_qgroup(struct btrfs_qgroup *dest,
+					  struct btrfs_qgroup *src)
+{
+	int i;
+
+	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)
+		qgroup_rsv_increase(dest, src->rsv.values[i], i);
+}
+
+static void qgroup_rsv_decrease_by_qgroup(struct btrfs_qgroup *dest,
+					  struct btrfs_qgroup *src)
+{
+	int i;
+
+	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)
+		qgroup_rsv_decrease(dest, src->rsv.values[i], i);
+}
+
 static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg, u64 seq,
 					   int mod)
 {
-- 
2.14.2

