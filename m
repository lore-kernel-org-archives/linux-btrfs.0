Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:12034 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2GJNaV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 09:30:21 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp3) (RZmta 29.19 OK)
	with ESMTP id p0468bo6A3tlvy for <linux-btrfs@vger.kernel.org>;
	Tue, 10 Jul 2012 15:30:18 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: avoid I/O repair BUG() from btree_read_extent_buffer_pages()
Date: Tue, 10 Jul 2012 15:30:17 +0200
Message-Id: <1341927017-21824-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From btree_read_extent_buffer_pages(), currently repair_io_failure()
can be called with mirror_num being zero when submit_one_bio() returned
an error before. This used to cause a BUG_ON(!mirror_num) in
repair_io_failure() and indeed this is not a case that needs the I/O
repair code to rewrite disk blocks.
This commit prevents calling repair_io_failure() in this case and thus
avoids the BUG_ON() and malfunction.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8cc4710..0a7a99b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -407,7 +407,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 			break;
 	}
 
-	if (failed && !ret)
+	if (failed && !ret && failed_mirror)
 		repair_eb_io_failure(root, eb, failed_mirror);
 
 	return ret;
-- 
1.7.11.1

