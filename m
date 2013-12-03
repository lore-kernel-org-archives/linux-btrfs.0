Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55376 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab3LCP4X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 10:56:23 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so6725004wib.8
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 07:56:22 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix pass of transid with wrong endianness in send.c
Date: Tue,  3 Dec 2013 15:55:48 +0000
Message-Id: <1386086148-27812-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From sparse:

fs/btrfs/send.c:2190:9: warning: incorrect type in argument 3 (different base types)
fs/btrfs/send.c:2190:9:    expected unsigned long long [unsigned] [usertype] value
fs/btrfs/send.c:2190:9:    got restricted __le64 [usertype] ctransid
fs/btrfs/send.c:2195:17: warning: incorrect type in argument 3 (different base types)
fs/btrfs/send.c:2195:17:    expected unsigned long long [unsigned] [usertype] value
fs/btrfs/send.c:2195:17:    got restricted __le64 [usertype] ctransid
fs/btrfs/send.c:3716:9: warning: incorrect type in argument 3 (different base types)
fs/btrfs/send.c:3716:9:    expected unsigned long long [unsigned] [usertype] value
fs/btrfs/send.c:3716:9:    got restricted __le64 [usertype] ctransid

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 9a58d3f..e5f8b0c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2188,12 +2188,12 @@ static int send_subvol_begin(struct send_ctx *sctx)
 	TLV_PUT_UUID(sctx, BTRFS_SEND_A_UUID,
 			sctx->send_root->root_item.uuid);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_CTRANSID,
-			sctx->send_root->root_item.ctransid);
+		    le64_to_cpu(sctx->send_root->root_item.ctransid));
 	if (parent_root) {
 		TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
 				sctx->parent_root->root_item.uuid);
 		TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_CTRANSID,
-				sctx->parent_root->root_item.ctransid);
+			    le64_to_cpu(sctx->parent_root->root_item.ctransid));
 	}
 
 	ret = send_cmd(sctx);
@@ -3714,7 +3714,7 @@ verbose_printk("btrfs: send_clone offset=%llu, len=%d, clone_root=%llu, "
 	TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
 			clone_root->root->root_item.uuid);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_CTRANSID,
-			clone_root->root->root_item.ctransid);
+		    le64_to_cpu(clone_root->root->root_item.ctransid));
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_CLONE_PATH, p);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_OFFSET,
 			clone_root->offset);
-- 
1.7.9.5

