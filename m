Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3BIGpD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 01:45:03 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: miaox@cn.fujitsu.com
Subject: [PATCH] Btrfs: cleanup the left refs on the cluster list
Date: Sat,  9 Feb 2013 14:42:02 +0800
Message-Id: <1360392122-5934-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we're going to abort the transaction, we need to first do cleanup
work for the left refs on the cluster list, otherwise we'll get list_del
debug warnings.

(Taken from Miao's patch: Btrfs: fix deadlock when the process of delayed refs fails)

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 61da9d0..7e7884f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2500,6 +2500,12 @@ again:
 
 		ret = run_clustered_refs(trans, root, &cluster);
 		if (ret < 0) {
+			if (!list_empty(&cluster)) {
+				struct list_head *pos, *next;
+
+				list_for_each_safe(pos, next, &cluster);
+					list_del_init(pos);
+			}
 			spin_unlock(&delayed_refs->lock);
 			btrfs_abort_transaction(trans, root, ret);
 			return ret;
-- 
1.7.7.6

