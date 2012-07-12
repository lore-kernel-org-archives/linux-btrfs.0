Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33233 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933357Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 01/15] Btrfs: fix buffer leak in btrfs_next_old_leaf
Date: Thu, 12 Jul 2012 11:43:33 +0200
Message-Id: <cf5388307a2b4faab4b11d732b61c85741be6169.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When calling btrfs_next_old_leaf, we were leaking an extent buffer in the
rare case of using the deadlock avoidance code needed for the tree mod log.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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

