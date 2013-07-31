Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19210 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3GaPiJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 11:38:09 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6VFc9mx005910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:09 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc8Rx028626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:08 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc8vS027673
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v5 4/5] Btrfs: disable qgroups accounting when quota is off
Date: Wed, 31 Jul 2013 23:37:44 +0800
Message-Id: <1375285066-14173-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So we don't need to do qgroups accounting trick without enabling quota.
This reduces my tester's costing time from ~28s to ~23s.  

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    6 ++++++
 fs/btrfs/qgroup.c      |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 10a5c72..c6612f5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2524,6 +2524,12 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 	struct qgroup_update *qgroup_update;
 	int ret = 0;
 
+	if (!trans->root->fs_info->quota_enabled) {
+		if (trans->delayed_ref_elem.seq)
+			btrfs_put_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
+		return 0;
+	}
+
 	if (list_empty(&trans->qgroup_ref_list) !=
 	    !trans->delayed_ref_elem.seq) {
 		/* list without seq or seq without list */
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1280eff..f3e82aa 100644
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
@@ -1850,6 +1853,9 @@ out:
 
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 {
+	if (!trans->root->fs_info->quota_enabled)
+		return;
+
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
 		return;
 	pr_err("btrfs: qgroups not uptodate in trans handle %p: list is%s empty, seq is %#x.%x\n",
-- 
1.7.7

