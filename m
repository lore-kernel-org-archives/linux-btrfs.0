Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:54128 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932265AbbJICVA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:21:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992KDBX022970
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:20:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 09/23] btrfs: delayed_ref: Add new function to record reserved space into delayed ref
Date: Fri, 9 Oct 2015 10:18:35 +0800
Message-ID: <1444357115-32088-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new function btrfs_add_delayed_qgroup_reserve() function to record
how much space is reserved for that extent.

As btrfs only accounts qgroup at run_delayed_refs() time, so newly
allocated extent should keep the reserved space until then.

So add needed function with related members to do it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 29 +++++++++++++++++++++++++++++
 fs/btrfs/delayed-ref.h | 14 ++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ac3e81d..bd9b63b 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -476,6 +476,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&head_ref->ref_list);
 	head_ref->processing = 0;
 	head_ref->total_ref_mod = count_mod;
+	head_ref->qgroup_reserved = 0;
+	head_ref->qgroup_ref_root = 0;
 
 	/* Record qgroup extent info if provided */
 	if (qrecord) {
@@ -746,6 +748,33 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
+				     struct btrfs_trans_handle *trans,
+				     u64 ref_root, u64 bytenr, u64 num_bytes)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *ref_head;
+	int ret = 0;
+
+	if (!fs_info->quota_enabled || !is_fstree(ref_root))
+		return 0;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	spin_lock(&delayed_refs->lock);
+	ref_head = find_ref_head(&delayed_refs->href_root, bytenr, 0);
+	if (!ref_head) {
+		ret = -ENOENT;
+		goto out;
+	}
+	WARN_ON(ref_head->qgroup_reserved || ref_head->qgroup_ref_root);
+	ref_head->qgroup_ref_root = ref_root;
+	ref_head->qgroup_reserved = num_bytes;
+out:
+	spin_unlock(&delayed_refs->lock);
+	return ret;
+}
+
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 13fb5e6..d4c41e2 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -113,6 +113,17 @@ struct btrfs_delayed_ref_head {
 	int total_ref_mod;
 
 	/*
+	 * For qgroup reserved space freeing.
+	 *
+	 * ref_root and reserved will be recorded after
+	 * BTRFS_ADD_DELAYED_EXTENT is called.
+	 * And will be used to free reserved qgroup space at
+	 * run_delayed_refs() time.
+	 */
+	u64 qgroup_ref_root;
+	u64 qgroup_reserved;
+
+	/*
 	 * when a new extent is allocated, it is just reserved in memory
 	 * The actual extent isn't inserted into the extent allocation tree
 	 * until the delayed ref is processed.  must_insert_reserved is
@@ -242,6 +253,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       u64 owner, u64 offset, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int no_quota);
+int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
+				     struct btrfs_trans_handle *trans,
+				     u64 ref_root, u64 bytenr, u64 num_bytes);
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
-- 
2.6.1

