Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45739 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755104Ab1K1Tda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:30 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWVLI020785
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:31 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWTbR012384
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:29 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWTpi020334
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:29 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWSG5020333
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:28 -0200
Message-Id: <17459f722c790fa3efb9e4f899472235a3a91ddb.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 12:07:49 -0200
Subject: [PATCH 04/20] Btrfs: reset cluster's max_size when creating bitmap
 cluster
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The field that indicates the size of the largest contiguous chunk of
free space in the cluster is not initialized when setting up bitmaps,
it's only increased when we find a larger contiguous chunk.  We end up
retaining a larger value than appropriate for highly-fragmented
clusters, which may cause pointless searches for large contiguous
groups, and even cause clusters that do not meet the density
requirements to be set up.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ff179b1..ec23d43 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2320,6 +2320,7 @@ again:
 
 	if (!found) {
 		start = i;
+		cluster->max_size = 0;
 		found = true;
 	}
 
-- 
1.7.4.4

