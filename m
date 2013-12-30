Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18510 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3L3INS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:18 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [PATCH v8 04/14] Btrfs: disable qgroups accounting when quata_enable is 0
Date: Mon, 30 Dec 2013 16:12:44 +0800
Message-Id: <1388391175-29539-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's unnecessary to do qgroups accounting without enabling quota.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c       |  2 +-
 fs/btrfs/delayed-ref.c | 18 ++++++++++++++----
 fs/btrfs/qgroup.c      |  3 +++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 316136b..160fa3e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -407,7 +407,7 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
 
 	tree_mod_log_write_lock(fs_info);
 	spin_lock(&fs_info->tree_mod_seq_lock);
-	if (!elem->seq) {
+	if (elem && !elem->seq) {
 		elem->seq = btrfs_inc_tree_mod_seq_major(fs_info);
 		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
 	}
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 9e1a1c9..3ec3d08 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -691,8 +691,13 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
-	if (need_ref_seq(for_cow, ref_root))
-		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
+	if (need_ref_seq(for_cow, ref_root)) {
+		struct seq_list *elem = NULL;
+
+		if (fs_info->quota_enabled)
+			elem = &trans->delayed_ref_elem;
+		seq = btrfs_get_tree_mod_seq(fs_info, elem);
+	}
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
@@ -750,8 +755,13 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
-	if (need_ref_seq(for_cow, ref_root))
-		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
+	if (need_ref_seq(for_cow, ref_root)) {
+		struct seq_list *elem = NULL;
+
+		if (fs_info->quota_enabled)
+			elem = &trans->delayed_ref_elem;
+		seq = btrfs_get_tree_mod_seq(fs_info, elem);
+	}
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e6ef49..1cb58f9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1188,6 +1188,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 {
 	struct qgroup_update *u;
 
+	if (!trans->root->fs_info->quota_enabled)
+		return 0;
+
 	BUG_ON(!trans->delayed_ref_elem.seq);
 	u = kmalloc(sizeof(*u), GFP_NOFS);
 	if (!u)
-- 
1.8.2.1

