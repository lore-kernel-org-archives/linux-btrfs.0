Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55947 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaBJMip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 07:38:45 -0500
Received: by mail-pb0-f53.google.com with SMTP id md12so6178754pbc.40
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 04:38:44 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: receive: don't output normal message into stderr
Date: Mon, 10 Feb 2014 20:36:37 +0800
Message-Id: <1392035797-2887-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Don't output normal messages into stderr, this make xfstests
filter output easier.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-receive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index cce37a7..2d55c53 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -213,7 +213,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	free(r->full_subvol_path);
 	r->full_subvol_path = path_cat3(r->root_path, r->dest_dir_path, path);
 
-	fprintf(stderr, "At snapshot %s\n", path);
+	fprintf(stdout, "At snapshot %s\n", path);
 
 	memcpy(r->cur_subvol->received_uuid, uuid, BTRFS_UUID_SIZE);
 	r->cur_subvol->stransid = ctransid;
-- 
1.8.4

