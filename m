Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:44931 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3DPIpc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 04:45:32 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] Btrfs: automatic rescan after "quota enable" command
Date: Tue, 16 Apr 2013 10:45:20 +0200
Message-Id: <1366101920-13083-4-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When qgroup tracking is enabled, we do an automatic cycle of the new rescan
mechanism.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/qgroup.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bb081b5..0ea2c3e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1356,10 +1356,14 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *quota_root = fs_info->quota_root;
 	int ret = 0;
+	int start_rescan_worker = 0;
 
 	if (!quota_root)
 		goto out;
 
+	if (!fs_info->quota_enabled && fs_info->pending_quota_state)
+		start_rescan_worker = 1;
+
 	fs_info->quota_enabled = fs_info->pending_quota_state;
 
 	spin_lock(&fs_info->qgroup_lock);
@@ -1385,6 +1389,12 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 	if (ret)
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 
+	if (start_rescan_worker) {
+		ret = btrfs_qgroup_rescan(fs_info);
+		if (ret)
+			pr_err("btrfs: start rescan quota failed: %d\n", ret);
+	}
+
 out:
 
 	return ret;
-- 
1.7.1

