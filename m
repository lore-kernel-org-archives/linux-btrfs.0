Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaDIHJZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 03:09:25 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v9 01/16] Btrfs: disable qgroups accounting when quata_enable is 0
Date: Wed,  9 Apr 2014 15:08:29 +0800
Message-Id: <1397027325-27151-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
References: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
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
index 88d1b1e..54f3c67 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -406,7 +406,7 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
 
 	tree_mod_log_write_lock(fs_info);
 	spin_lock(&fs_info->tree_mod_seq_lock);
-	if (!elem->seq) {
+	if (elem && !elem->seq) {
 		elem->seq = btrfs_inc_tree_mod_seq_major(fs_info);
 		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
 	}
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3129964..3ab37b6 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -656,8 +656,13 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
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
@@ -718,8 +723,13 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
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
index 2cf9058..c634b3e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1186,6 +1186,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
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

