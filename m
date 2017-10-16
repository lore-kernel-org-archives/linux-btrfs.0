Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41327 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751964AbdJPN33 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:29:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A1CF9AAAD
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:29:27 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: remove stillborn code
Date: Mon, 16 Oct 2017 16:29:23 +0300
Message-Id: <1508160563-30833-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This code was first introduced in 31db9f7c23fb ("Btrfs: introduce
BTRFS_IOC_SEND for btrfs send/receive") and it was not functional, then it got
slightly refactored in e938c8ad543c ("Btrfs: code cleanups for send/receive"),
alas it was still dead. So let's remove it for good!

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/send.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d9ddcdbdd2e7..13b98a554aab 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1271,12 +1271,6 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 		 */
 		if (ino >= bctx->cur_objectid)
 			return 0;
-#if 0
-		if (ino > bctx->cur_objectid)
-			return 0;
-		if (offset + bctx->extent_len > bctx->cur_offset)
-			return 0;
-#endif
 	}
 
 	bctx->found++;
-- 
2.7.4

