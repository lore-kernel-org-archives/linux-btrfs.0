Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38526 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaBEQtF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 11:49:05 -0500
Received: by mail-wi0-f172.google.com with SMTP id e4so776753wiv.11
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 08:49:03 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2] Btrfs: use right extent item position in send when finding extent clones
Date: Wed,  5 Feb 2014 16:48:55 +0000
Message-Id: <1391618936-8716-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was a leftover from the commit:

   74dd17fbe3d65829e75d84f00a9525b2ace93998
   (Btrfs: fix btrfs send for inline items and compression)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f71fcbc..7a1b547 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1257,8 +1257,6 @@ static int find_extent_clone(struct send_ctx *sctx,
 		extent_item_pos = logical - found_key.objectid;
 	else
 		extent_item_pos = 0;
-
-	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(sctx->send_root->fs_info,
 					found_key.objectid, extent_item_pos, 1,
 					__iterate_backrefs, backref_ctx);
-- 
1.7.9.5

