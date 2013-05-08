Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:24501 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab3EHI4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 May 2013 04:56:12 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 31.27 OK)
	with ESMTP id g01efep487Besq for <linux-btrfs@vger.kernel.org>;
	Wed, 8 May 2013 10:56:09 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix possible memory leak in replace_path()
Date: Wed,  8 May 2013 10:56:09 +0200
Message-Id: <1368003369-19813-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In replace_path(), if read_tree_block() fails, we cannot return
directly, we should free some allocated memory otherwise memory
leak happens.

Similar to Wang's "Btrfs: fix possible memory leak in the
find_parent_nodes()" patch, the current commit fixes an issue that
is related to the "Btrfs: fix all callers of read_tree_block"
commit.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index aca3c30..e45d899 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1773,7 +1773,7 @@ again:
 			if (!eb || !extent_buffer_uptodate(eb)) {
 				ret = (!eb) ? -ENOMEM : -EIO;
 				free_extent_buffer(eb);
-				return ret;
+				break;
 			}
 			btrfs_tree_lock(eb);
 			if (cow) {
-- 
1.8.2.2

