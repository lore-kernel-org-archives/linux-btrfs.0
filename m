Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45772 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755233Ab1K1Tdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:51 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWmtk020852
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:59 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWkLE012462
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:47 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWkRM020518
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:46 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWjhQ020517
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:45 -0200
Message-Id: <0adb2d2dc73153fe087fdf30250e34ace9262b1e.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 12:23:07 -0200
Subject: [PATCH 19/20] Btrfs: log when a bitmap is rejected for a cluster
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/free-space-cache.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 953f7dd..0151274 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2316,6 +2316,16 @@ again:
 		i = next_zero;
 	}
 
+	if (!found_bits && total_found)
+		printk(KERN_INFO "btrfs: bitmap %llx want:%llx min:%llx cont:%llx start:%llx max:%llx total:%llx\n",
+		       (unsigned long long)entry->offset,
+		       (unsigned long long)bytes,
+		       (unsigned long long)min_bytes,
+		       (unsigned long long)cont1_bytes,
+		       (unsigned long long)(start * block_group->sectorsize),
+		       (unsigned long long)cluster->max_size,
+		       (unsigned long long)(total_found * block_group->sectorsize));
+
 	if (!found_bits)
 		return -ENOSPC;
 
-- 
1.7.4.4

