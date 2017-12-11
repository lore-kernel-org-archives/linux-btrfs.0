Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37236 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdLKW7A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 17:59:00 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: do not merge rbios if their fail stripe index are not identical
Date: Mon, 11 Dec 2017 14:56:31 -0700
Message-Id: <20171211215631.27546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since fail stripe index in rbio would be used to decide which
algorithm reconstruction would be run, we cannot merge rbios if
their's fail striped index are different, otherwise, one of the two
reconstructions would fail.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Change to use if-else style.

 fs/btrfs/raid56.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index c4188fb..c03fcf7 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -601,6 +601,25 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
 	if (last->operation == BTRFS_RBIO_REBUILD_MISSING)
 		return 0;
 
+	if (last->operation == BTRFS_RBIO_READ_REBUILD) {
+		int fa = last->faila;
+		int fb = last->failb;
+		int cur_fa = cur->faila;
+		int cur_fb = cur->failb;
+
+		if (last->faila >= last->failb) {
+			fa = last->failb;
+			fb = last->faila;
+		}
+
+		if (cur->faila >= cur->failb) {
+			cur_fa = cur->failb;
+			cur_fb = cur->faila;
+		}
+			
+		if (fa != cur_fa || fb != cur_fb)
+			return 0;
+	}
 	return 1;
 }
 
-- 
2.9.4

