Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45735 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755012Ab1K1TdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:16 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWU6O020781
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:31 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWSua012382
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:28 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWSi6020329
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:28 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWR9x020328
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:27 -0200
Message-Id: <cec63ec8652d9b2406fd466131013e43c9b395c2.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 13:41:13 -0200
Subject: [PATCH 03/20] Btrfs: fix comment typo
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5d86877..bc0f13d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5304,7 +5304,7 @@ alloc:
 			/*
 			 * whoops, this cluster doesn't actually point to
 			 * this block group.  Get a ref on the block
-			 * group is does point to and try again
+			 * group it does point to and try again
 			 */
 			if (!last_ptr_loop && last_ptr->block_group &&
 			    last_ptr->block_group != block_group &&
-- 
1.7.4.4

