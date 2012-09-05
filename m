Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:48825 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2IEHuV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 03:50:21 -0400
From: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Cc: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
Subject: [PATCH] warn when skipping snapshots created with older
Date: Wed,  5 Sep 2012 09:50:05 +0200
Message-Id: <1346831405-24095-1-git-send-email-g2p.code+btrfs@gmail.com>
References: <5046D3A0.6060402@jan-o-sch.net>
In-Reply-To: <5046D3A0.6060402@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, I fixed the objectid test.
Apply with --scissors.

-- >8 --
Subject: [PATCH] btrfs send: warn when skipping snapshots created with older
 kernels.

This message is more explicit than "ERROR: could not resolve root_id",
the message that will be shown immediately before `btrfs send` bails.

Also skip invalid high OIDs, to prevent spurious warnings.

Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
---
 send-utils.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/send-utils.c b/send-utils.c
index a43d47e..03ca72a 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -224,13 +224,18 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 
 			if ((sh->objectid != 5 &&
 			    sh->objectid < BTRFS_FIRST_FREE_OBJECTID) ||
-			    sh->objectid == BTRFS_FREE_INO_OBJECTID)
+			    sh->objectid > BTRFS_LAST_FREE_OBJECTID)
 				goto skip;
 
 			if (sh->type == BTRFS_ROOT_ITEM_KEY) {
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

