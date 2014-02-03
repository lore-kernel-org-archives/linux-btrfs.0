Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbaBCRYN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 12:24:13 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 408C8AAD1
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 17:24:12 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: send: replace check with an assert in gen_unique_name
Date: Mon,  3 Feb 2014 18:24:09 +0100
Message-Id: <1391448249-761-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The buffer passed to snprintf can hold the fully expanded format string,
64 = 3x largest ULL + 3x char + trailing null.  I don't think that removing the
check entirely is a good idea, hence the ASSERT.

Signed-off-by: David Sterba <dsterba@suse.cz>
---


 fs/btrfs/send.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 730dce395858..f65355dfc882 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1408,11 +1408,7 @@ static int gen_unique_name(struct send_ctx *sctx,
 	while (1) {
 		len = snprintf(tmp, sizeof(tmp), "o%llu-%llu-%llu",
 				ino, gen, idx);
-		if (len >= sizeof(tmp)) {
-			/* should really not happen */
-			ret = -EOVERFLOW;
-			goto out;
-		}
+		ASSERT(len < sizeof(tmp));
 
 		di = btrfs_lookup_dir_item(NULL, sctx->send_root,
 				path, BTRFS_FIRST_FREE_OBJECTID,
-- 
1.7.9

