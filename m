Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45738 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755102Ab1K1Tda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:30 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWXo4020797
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:33 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWWjL012406
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:32 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWVY2020349
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:32 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWVoZ020348
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:31 -0200
Message-Id: <8e080c19c27a11d4d666e6e865063065c6c2b68f.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 12:36:17 -0200
Subject: [PATCH 07/20] Btrfs: don't set up allocation result twice
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We store the allocation start and length twice in ins, once right
after the other, but with intervening calls that may prevent the
duplicate from being optimized out by the compiler.  Remove one of the
assignments.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 525ff20..24eef3a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5412,9 +5412,6 @@ checks:
 			goto loop;
 		}
 
-		ins->objectid = search_start;
-		ins->offset = num_bytes;
-
 		if (offset < search_start)
 			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
-- 
1.7.4.4

