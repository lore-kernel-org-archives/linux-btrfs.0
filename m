Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60135 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3DVNNw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:13:52 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 226FF7C067C
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:13:52 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id jZfo05p7UQSgxOQP (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:13:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix possible infinite loop in slow caching
Date: Mon, 22 Apr 2013 09:13:21 -0400
Message-ID: <1366636401-2066-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I noticed there is an infinite loop in the slow caching code.  If we return 1
when we hit the end of the tree, so we could end up caching the last block group
the slow way and suddenly we're looping forever because we just keep
re-searching and trying again.  Fix this by only doing btrfs_next_leaf() if we
don't need_resched().  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 12c32f9..b441be3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -419,8 +419,7 @@ again:
 			if (ret)
 				break;
 
-			if (need_resched() ||
-			    btrfs_next_leaf(extent_root, path)) {
+			if (need_resched()) {
 				caching_ctl->progress = last;
 				btrfs_release_path(path);
 				up_read(&fs_info->extent_commit_sem);
@@ -428,6 +427,12 @@ again:
 				cond_resched();
 				goto again;
 			}
+
+			ret = btrfs_next_leaf(extent_root, path);
+			if (ret < 0)
+				goto err;
+			if (ret)
+				break;
 			leaf = path->nodes[0];
 			nritems = btrfs_header_nritems(leaf);
 			continue;
-- 
1.7.7.6

