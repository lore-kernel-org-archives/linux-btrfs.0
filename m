Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59236 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab2IDQlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Sep 2012 12:41:45 -0400
From: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
Subject: [PATCH] Warn when skipping snapshots created with older kernels.
Date: Tue,  4 Sep 2012 18:40:58 +0200
Message-Id: <1346776858-6208-1-git-send-email-g2p.code+btrfs@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This message is more explicit than "ERROR: could not resolve root_id",
the message that will be shown immediately before `btrfs send` bails.

Also skip invalid high OIDs.

Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
---
 send-utils.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/send-utils.c b/send-utils.c
index a43d47e..386aeb3 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -224,6 +224,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 
 			if ((sh->objectid != 5 &&
 			    sh->objectid < BTRFS_FIRST_FREE_OBJECTID) ||
+			    sh->objectid >= BTRFS_LAST_FREE_OBJECTID ||
 			    sh->objectid == BTRFS_FREE_INO_OBJECTID)
 				goto skip;
 
@@ -231,6 +232,11 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				/* older kernels don't have uuids+times */
 				if (sh->len < sizeof(root_item)) {
 					root_item_valid = 0;
+					fprintf(stderr,
+					        "Ignoring subvolume id %llu, "
+					        "btrfs send needs snapshots "
+					        "created with kernel 3.6+\n",
+					        sh->objectid);
 					goto skip;
 				}
 				root_item_ptr = (struct btrfs_root_item *)
-- 
1.7.12.117.gdc24c27

