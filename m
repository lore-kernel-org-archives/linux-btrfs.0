Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:63508 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaA3N1x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 08:27:53 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so1638370eae.37
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 05:27:52 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: add missing error check in incremental send
Date: Thu, 30 Jan 2014 13:27:12 +0000
Message-Id: <1391088432-21981-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function wait_for_parent_move() returns negative value if an error
happened, 0 if we don't need to wait for the parent's move, and
1 if the wait is needed.
Before this change an error return value was being treated like the
return value 1, which was not correct.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 31b76d0..7250d86 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3215,7 +3215,10 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 				 * dirs, we always have one new and one deleted
 				 * ref. The deleted ref is ignored later.
 				 */
-				if (wait_for_parent_move(sctx, cur)) {
+				ret = wait_for_parent_move(sctx, cur);
+				if (ret < 0)
+					goto out;
+				if (ret) {
 					ret = add_pending_dir_move(sctx,
 								   cur->dir);
 					*pending_move = 1;
-- 
1.7.9.5

