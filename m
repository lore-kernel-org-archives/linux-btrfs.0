Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26579 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752675AbcLOH2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 02:28:54 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: t-itoh@jp.fujitsu.com
Subject: [PATCH] btrfs-progs: Fix NULL pointer when receive clone operation
Date: Thu, 15 Dec 2016 15:28:02 +0800
Message-Id: <20161215072802.21452-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subvol_info returned from subvol_uuid_search() can be NULL.
So the branch checking IS_ERR(si) should also check if it's NULL.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-receive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index cb42aa2..c8f2fff 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -750,7 +750,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 	si = subvol_uuid_search(&rctx->sus, 0, clone_uuid, clone_ctransid,
 				NULL,
 				subvol_search_by_received_uuid);
-	if (IS_ERR(si)) {
+	if (IS_ERR(si) || !si) {
 		if (memcmp(clone_uuid, rctx->cur_subvol.received_uuid,
 				BTRFS_UUID_SIZE) == 0) {
 			/* TODO check generation of extent */
-- 
2.10.2



