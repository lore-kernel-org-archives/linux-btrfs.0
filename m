Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40094 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbaCRR4P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 13:56:15 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so4078404wib.4
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 10:56:14 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove unnecessary inode generation lookup in send
Date: Tue, 18 Mar 2014 17:56:06 +0000
Message-Id: <1395165366-24715-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to search in the send tree for the generation number of the inode,
we already have it in the recorded_ref structure passed to us.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5d757ee..db4b10c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3179,7 +3179,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
 	int ret;
 	u64 ino = parent_ref->dir;
 	u64 parent_ino_before, parent_ino_after;
-	u64 new_gen, old_gen;
+	u64 old_gen;
 	struct fs_path *path_before = NULL;
 	struct fs_path *path_after = NULL;
 	int len1, len2;
@@ -3198,12 +3198,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
 	else if (ret < 0)
 		return ret;
 
-	ret = get_inode_info(sctx->send_root, ino, NULL, &new_gen,
-			     NULL, NULL, NULL, NULL);
-	if (ret < 0)
-		return ret;
-
-	if (new_gen != old_gen)
+	if (parent_ref->dir_gen != old_gen)
 		return 0;
 
 	path_before = fs_path_alloc();
-- 
1.7.10.4

