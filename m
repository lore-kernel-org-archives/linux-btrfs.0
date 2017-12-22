Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45526 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdLVGTB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 22 Dec 2017 01:19:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 03/10] btrfs: qgroup: Introduce function to convert META_PREALLOC into META_PERTRANS
Date: Fri, 22 Dec 2017 14:18:40 +0800
Message-Id: <20171222061847.13158-4-wqu@suse.com>
In-Reply-To: <20171222061847.13158-1-wqu@suse.com>
References: <20171222061847.13158-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For meta_prealloc reservation user, after btrfs_join_transaction()
caller will modify tree so part (or even all) meta_prealloc reservation
should be converted to meta_pertrans until transaction commit time.

This patch introduce a new function,
btrfs_qgroup_convert_reserved_meta() to do this for META_PREALLOC
reservation user.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h |  8 ++++++++
 2 files changed, 64 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ce3d6c95d297..24fc6e46f717 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3146,6 +3146,62 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes, type);
 }
 
+static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
+				int num_bytes)
+{
+	struct btrfs_root *quota_root = fs_info->quota_root;
+	struct btrfs_qgroup *qgroup;
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	int ret = 0;
+
+	if (num_bytes == 0)
+		return;
+	if (!quota_root)
+		return;
+
+	spin_lock(&fs_info->qgroup_lock);
+	qgroup = find_qgroup_rb(fs_info, ref_root);
+	if (!qgroup)
+		goto out;
+	ulist_reinit(fs_info->qgroup_ulist);
+	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
+		       (uintptr_t)qgroup, GFP_ATOMIC);
+	if (ret < 0)
+		goto out;
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
+		struct btrfs_qgroup *qg;
+		struct btrfs_qgroup_list *glist;
+
+		qg = unode_aux_to_qgroup(unode);
+
+		qgroup_rsv_release(fs_info, qg, num_bytes,
+				BTRFS_QGROUP_RSV_META_PREALLOC);
+		qgroup_rsv_add(fs_info, qg, num_bytes,
+				BTRFS_QGROUP_RSV_META_PERTRANS);
+		list_for_each_entry(glist, &qg->groups, next_group) {
+			ret = ulist_add(fs_info->qgroup_ulist,
+					glist->group->qgroupid,
+					(uintptr_t)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				goto out;
+		}
+	}
+out:
+	spin_unlock(&fs_info->qgroup_lock);
+}
+
+void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
+	    !is_fstree(root->objectid))
+		return;
+	qgroup_convert_meta(fs_info, root->objectid, num_bytes);
+}
+
 /*
  * Check qgroup reserved space leaking, normally at destroy inode
  * time
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index b47740e2e017..4814d680c50f 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -332,5 +332,13 @@ static inline void btrfs_qgroup_free_meta_prealloc(struct btrfs_root *root,
  */
 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root);
 
+/*
+ * Convert @num_bytes of META_PREALLOCATED reservation to META_PERTRANS.
+ *
+ * This is called when preallocated meta reservation needs to be used.
+ * Normally after btrfs_join_transaction() call.
+ */
+void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes);
+
 void btrfs_qgroup_check_reserved_leak(struct inode *inode);
 #endif /* __BTRFS_QGROUP__ */
-- 
2.15.1

