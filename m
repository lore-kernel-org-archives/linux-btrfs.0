Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:48024 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236Ab3AQI2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 03:28:46 -0500
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: prevent qgroup destroy when there are still relations
Date: Thu, 17 Jan 2013 09:22:09 +0100
Message-Id: <7d45dfa6046b4a6546e5217d9adba34f464f27b8.1358410295.git.sensille@gmx.net>
In-Reply-To: <cover.1358410295.git.sensille@gmx.net>
References: <cover.1358410295.git.sensille@gmx.net>
In-Reply-To: <cover.1358410295.git.sensille@gmx.net>
References: <cover.1358410295.git.sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently you can just destroy a qgroup even though it is in use by other qgroups
or has qgroups assigned to it. This patch prevents destruction of qgroups unless
they are completely unused. Otherwise destroy will return EBUSY.

Reported-by: Eric Hopper <hopper@omnifarious.org>
Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/qgroup.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 28f2b39..a5c8562 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -963,17 +963,28 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u64 qgroupid)
 {
 	struct btrfs_root *quota_root;
+	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
 		return -EINVAL;
 
+	/* check if there are no relations to this qgroup */
+	spin_lock(&fs_info->qgroup_lock);
+	qgroup = find_qgroup_rb(fs_info, qgroupid);
+	if (qgroup) {
+		if (!list_empty(&qgroup->groups) || !list_empty(&qgroup->members)) {
+			spin_unlock(&fs_info->qgroup_lock);
+			return -EBUSY;
+		}
+	}
+	spin_unlock(&fs_info->qgroup_lock);
+
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
 	spin_lock(&fs_info->qgroup_lock);
 	del_qgroup_rb(quota_root->fs_info, qgroupid);
-
 	spin_unlock(&fs_info->qgroup_lock);
 
 	return ret;
-- 
1.7.3.4

