Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38590 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaCVRQk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 13:16:40 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so2361574wgg.26
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 10:16:39 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: send, remove dead code from __get_cur_name_and_parent
Date: Sat, 22 Mar 2014 17:16:30 +0000
Message-Id: <1395508590-19063-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6a1a343..2952889 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2004,7 +2004,6 @@ static int __get_cur_name_and_parent(struct send_ctx *sctx,
 {
 	int ret;
 	int nce_ret;
-	struct btrfs_path *path = NULL;
 	struct name_cache_entry *nce = NULL;
 
 	/*
@@ -2030,10 +2029,6 @@ static int __get_cur_name_and_parent(struct send_ctx *sctx,
 		}
 	}
 
-	path = alloc_path_for_send();
-	if (!path)
-		return -ENOMEM;
-
 	/*
 	 * If the inode is not existent yet, add the orphan name and return 1.
 	 * This should only happen for the parent dir that we determine in
@@ -2109,7 +2104,6 @@ out_cache:
 	name_cache_clean_unused(sctx);
 
 out:
-	btrfs_free_path(path);
 	return ret;
 }
 
-- 
1.7.10.4

