Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:55835 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2GDOPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 10:15:04 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix buffer leak in btrfs_next_old_leaf
Date: Wed,  4 Jul 2012 16:15:02 +0200
Message-Id: <1341411302-22994-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When calling btrfs_next_old_leaf, we were leaking an extent buffer in the
rare case of using the deadlock avoidance code needed for the tree mod log.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Chris: you can either put it on top of your current for-linus branch,
use it as a fixup to d42244a (part of your for-linus), or even keep it
for the next rc, as that buffer leak should be really rare.

-Jan

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8206b39..67fe46f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5127,6 +5127,7 @@ again:
 				 * locked. To solve this situation, we give up
 				 * on our lock and cycle.
 				 */
+				free_extent_buffer(next);
 				btrfs_release_path(path);
 				cond_resched();
 				goto again;
-- 
1.7.3.4

