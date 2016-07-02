Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbcGKLP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 07:15:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D72F820204
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 11:15:24 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 78566201F4
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 11:15:23 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/7] Btrfs: send, add missing error check for calls to path_loop()
Date: Sat,  2 Jul 2016 13:29:54 +0100
Message-Id: <1467462594-14195-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The function path_loop() can return a negative integer, signaling an
error, 0 if there's no path loop and 1 if there's a path loop. We were
treating any non zero values as meaning that a path loop exists. Fix
this by explicitly checking for errors and gracefully return them to
user space.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 993e1ba..0dc05bb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3200,6 +3200,8 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 
 	sctx->send_progress = sctx->cur_ino + 1;
 	ret = path_loop(sctx, name, pm->ino, pm->gen, &ancestor);
+	if (ret < 0)
+		goto out;
 	if (ret) {
 		LIST_HEAD(deleted_refs);
 		ASSERT(ancestor > BTRFS_FIRST_FREE_OBJECTID);
-- 
2.7.0.rc3

