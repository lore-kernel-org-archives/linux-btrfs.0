Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37605 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041407AbdDUXMu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 19:12:50 -0400
Received: by mail-it0-f45.google.com with SMTP id x188so178172itb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 16:12:49 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id p70sm1352666itg.0.2017.04.21.16.12.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Apr 2017 16:12:48 -0700 (PDT)
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 21 Apr 2017 23:12:47 +0000
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: add quota override attribute
Message-ID: <20170421231246.GA3778@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170421231232.GA3769@ircssh-2.c.rugged-nimbus-611.internal>

This patch introduces the quota override flag to btrfs_fs_info, and
a change to quota limit checking code to temporarily allow for quota
to be overridden for processes with cap_sys_resource.

It's useful for administrative programs, such as log rotation,
that may need to temporarily use more disk space in order to free up
a greater amount of overall disk space without yielding more disk
space to the rest of userland.

Eventually, we may want to add the idea of an operator-specific
quota, operator reserved space, or something else to allow for
administrative override, but this is perhaps the simplest
solution.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ctree.h  | 3 +++
 fs/btrfs/qgroup.c | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c411590..01a095b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1098,6 +1098,9 @@ struct btrfs_fs_info {
 	u32 nodesize;
 	u32 sectorsize;
 	u32 stripesize;
+
+	/* Allow tasks with cap_sys_resource to override the quota */
+	bool quota_override;
 };
 
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a59801d..0328492 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2347,8 +2347,12 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
+static bool qgroup_check_limits(const struct btrfs_qgroup *qg,
+				u64 num_bytes, bool quota_override)
 {
+	if (quota_override && capable(CAP_SYS_RESOURCE))
+		return true;
+
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 	    qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
 		return false;
@@ -2366,6 +2370,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
+	bool qo = fs_info->quota_override;
 	int ret = 0;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -2401,7 +2406,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 
 		qg = unode_aux_to_qgroup(unode);
 
-		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
+		if (enforce && !qgroup_check_limits(qg, num_bytes, qo)) {
 			ret = -EDQUOT;
 			goto out;
 		}
-- 
2.9.3

