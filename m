Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbbCSGFC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:05:02 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 7/7] Btrfs: qgroup: allow user to limit qgroup in different type.
Date: Thu, 19 Mar 2015 14:01:04 +0800
Message-ID: <1426744864-7031-12-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

until now, we can account the quota number for data and metadata
separately, but we can not limit only one of them. This patch
add the support to only limit one of the data or metadata.

Also you can limit them at the same time.

Even you can limit data quota, metadata quota and mixed quota
at the same time.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 10 +++++++---
 fs/btrfs/qgroup.h | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bb98bdd..793c7bb 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1322,6 +1322,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup_limits *limits;
+	u8 limits_type = get_limit_type(limit->flags);
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
@@ -1337,9 +1338,12 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	/* To the compatibility, treat the mixed limits as the
-	 * default limits now. will change it later. */
-	limits = &qgroup->mixed_limits;
+	if (limits_type == BTRFS_QGROUP_LIMIT_DATA)
+		limits = &qgroup->data_limits;
+	else if (limits_type == BTRFS_QGROUP_LIMIT_METADATA)
+		limits = &qgroup->metadata_limits;
+	else
+		limits = &qgroup->mixed_limits;
 
 	spin_lock(&fs_info->qgroup_lock);
 	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 11b73f3..6e4565f 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -36,6 +36,32 @@
 #define BTRFS_QGROUP_REF_TYPE_DEFAULT	BTRFS_QGROUP_REF_TYPE_DATA
 
 /*
+ * As we can account and limit data and metadata in
+ * a qgroup separately. We use the first 8 bits in
+ * btrfs_qgroup_limit->flags to specify the type we
+ * want to limit. Currently, there are three choice:
+ * DATA, METADATA, MIXED.
+ */
+#define BTRFS_QGROUP_LIMIT_TYPE_SHIFT   56
+
+#define BTRFS_QGROUP_LIMIT_DATA         1
+#define BTRFS_QGROUP_LIMIT_METADATA     2
+#define BTRFS_QGROUP_LIMIT_MIXED        4
+
+static inline u8 get_limit_type(u64 flag)
+{
+        u8 type = (flag >> BTRFS_QGROUP_LIMIT_TYPE_SHIFT);
+	/*
+	 * If user did not set the type for limit, default
+	 * for mixed_limits;
+	 */
+	if (!type)
+		type = BTRFS_QGROUP_LIMIT_MIXED;
+	return type;
+}
+
+
+/*
  * A description of the operations, all of these operations only happen when we
  * are adding the 1st reference for that subvolume in the case of adding space
  * or on the last reference delete in the case of subtraction.  The only
-- 
1.8.4.2

