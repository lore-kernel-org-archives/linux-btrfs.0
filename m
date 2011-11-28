Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45927 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754216Ab1K1UAg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 15:00:36 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJxX3D024269
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:59:43 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWVfe012400
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:31 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWVAo020344
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:31 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWUVk020343
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:30 -0200
Message-Id: <ee7e764e25cdb706586a1b17ecffcaad8c898b01.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 12:30:32 -0200
Subject: [PATCH 06/20] Btrfs: skip block groups without enough space for a
 cluster
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We test whether a block group has enough free space to hold the
requested block, but when we're doing clustered allocation, we can
save some cycles by testing whether it has enough room for the cluster
upfront, otherwise we end up attempting to set up a cluster and
failing.  Only in the NO_EMPTY_SIZE loop do we attempt an unclustered
allocation, and by then we'll have zeroed the cluster size, so this
patch won't stop us from using the block group as a last resort.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7edb9e6..525ff20 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5264,7 +5264,7 @@ alloc:
 		spin_lock(&block_group->free_space_ctl->tree_lock);
 		if (cached &&
 		    block_group->free_space_ctl->free_space <
-		    num_bytes + empty_size) {
+		    num_bytes + empty_cluster + empty_size) {
 			spin_unlock(&block_group->free_space_ctl->tree_lock);
 			goto loop;
 		}
-- 
1.7.4.4

