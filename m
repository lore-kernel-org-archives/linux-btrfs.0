Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2103 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab2GFJVV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 05:21:21 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q669LHH6009992
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Jul 2012 17:21:17 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4 v2] Btrfs: do not abort transaction in prealloc case
Date: Fri, 6 Jul 2012 17:31:33 +0800
Message-Id: <1341567096-30304-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During disk balance, we prealloc new file extent for file data relocation,
but we may fail in 'no available space' case, and it leads to flipping btrfs
into readonly.

It is not necessary to bail out and abort transaction since we do have several
ways to rescue ourselves from ENOSPC case.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
v1->v2: adopt an easier and cleaner way:
        checking return value instead of adding more arguments.

 fs/btrfs/extent-tree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5775dc4..0469398 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5777,7 +5777,11 @@ loop:
 				ret = do_chunk_alloc(trans, root, num_bytes +
 						     2 * 1024 * 1024, data,
 						     CHUNK_ALLOC_LIMITED);
-				if (ret < 0) {
+				/*
+				 * Do not bail out on ENOSPC since we
+				 * can do more things.
+				 */
+				if (ret < 0 && ret != -ENOSPC) {
 					btrfs_abort_transaction(trans,
 								root, ret);
 					goto out;
-- 
1.6.5.2

