Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1039 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab3EGG14 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 02:27:56 -0400
Message-ID: <51889BF1.1000300@cn.fujitsu.com>
Date: Tue, 07 May 2013 14:15:13 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: save us a mutex_lock usage when doing quota rescan
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If qgroup_rescan worker is in progress, we should ignore
the extent that has not been dealt with qgroup_rescan worker,just
let them dealt later otherwise we may get wrong qgroup accounting.

However, we have checked this before find_all_roots() without spin_lock.
When doing qgroup accounting, we don't have to check it again, because
during this period,qgroup_rescan worker can deal with more extents and
qgroup_rescan_extent->objectid can only go larger, so here the check
is unnecessary.

Just remove this check, so that we don't need hold qgroup_rescan_lock
when doing qgroup accounting.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d059d86..2710784 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1445,15 +1445,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		return ret;
 
-	mutex_lock(&fs_info->qgroup_rescan_lock);
 	spin_lock(&fs_info->qgroup_lock);
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
-		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
-			ret = 0;
-			goto unlock;
-		}
-	}
-
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
 		goto unlock;
@@ -1492,7 +1484,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
-	mutex_unlock(&fs_info->qgroup_rescan_lock);
 	ulist_free(roots);
 
 	return ret;
-- 
1.7.7.6




