Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:43032 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab2IKG0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 02:26:41 -0400
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] Revert "Btrfs: fix some error codes in btrfs_qgroup_inherit()"
Date: Tue, 11 Sep 2012 08:26:38 +0200
Message-Id: <1347344798-18882-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 5986802c2fcc754040bb7ed95f30bb16c4a843b7.

Both paths are not error paths but regular cases where non-qgroup
subvols are involved.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/qgroup.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 38b42e7..b650155 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1371,10 +1371,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 
 	if (srcid) {
 		srcgroup = find_qgroup_rb(fs_info, srcid);
-		if (!srcgroup) {
-			ret = -EINVAL;
+		if (!srcgroup)
 			goto unlock;
-		}
 		dstgroup->rfer = srcgroup->rfer - level_size;
 		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr - level_size;
 		srcgroup->excl = level_size;
@@ -1383,10 +1381,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		qgroup_dirty(fs_info, srcgroup);
 	}
 
-	if (!inherit) {
-		ret = -EINVAL;
+	if (!inherit)
 		goto unlock;
-	}
 
 	i_qgroups = (u64 *)(inherit + 1);
 	for (i = 0; i < inherit->num_qgroups; ++i) {
-- 
1.7.3.4

