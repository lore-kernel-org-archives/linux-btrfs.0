Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49505 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746Ab3HHIgC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:36:02 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r788a1Hv021828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:36:02 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r788a0DO017996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:36:01 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r788a0fA012631
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:36:00 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v6 4/5] Btrfs: disable qgroups accounting when quata_enable is 0
Date: Thu,  8 Aug 2013 16:35:44 +0800
Message-Id: <1375950946-5470-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375950946-5470-1-git-send-email-bo.li.liu@oracle.com>
References: <1375950946-5470-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's unnecessary to do qgroups accounting without enabling quota.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v6:
* don't record seq for qgroups with quota disabled as we do not need to,
  and keep the checker of qgroups.

 fs/btrfs/ctree.c       |    2 +-
 fs/btrfs/delayed-ref.c |   18 ++++++++++++++----
 fs/btrfs/qgroup.c      |    3 +++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d5387dd..2d22ddf 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -408,7 +408,7 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
 
 	tree_mod_log_write_lock(fs_info);
 	spin_lock(&fs_info->tree_mod_seq_lock);
-	if (!elem->seq) {
+	if (elem && !elem->seq) {
 		elem->seq = btrfs_inc_tree_mod_seq_major(fs_info);
 		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
 	}
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 73a3e55..af57cfc 100644
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
index 1280eff..780ff14 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1200,6 +1200,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 {
 	struct qgroup_update *u;
 
+	if (!trans->root->fs_info->quota_enabled)
+		return 0;
+
 	BUG_ON(!trans->delayed_ref_elem.seq);
 	u = kmalloc(sizeof(*u), GFP_NOFS);
 	if (!u)
-- 
1.7.7

