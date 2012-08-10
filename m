Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:64545 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759786Ab2HJO6X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 10:58:23 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 30.8 OK) with ESMTP id p02ae7o7AB9mnr
	for <linux-btrfs@vger.kernel.org>;
	Fri, 10 Aug 2012 16:58:21 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix that repair code is spuriously executed for transid failures
Date: Fri, 10 Aug 2012 16:58:21 +0200
Message-Id: <1344610701-13816-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If verify_parent_transid() fails for all mirrors, the current code
calls repair_io_failure() anyway which means:
- that the disk block is rewritten without repairing anything and
- that a kernel log message is printed which misleadingly claims
  that a read error was corrected.

This is an example:
parent transid verify failed on 615015833600 wanted 110423 found 110424
parent transid verify failed on 615015833600 wanted 110423 found 110424
btrfs read error corrected: ino 1 off 615015833600 (dev /dev/...)

It is wrong to ignore the results from verify_parent_transid() and to
call repair_eb_io_failure() when the verification of the transids failed.
This commit fixes the issue.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c4c439..29c69e6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -377,9 +377,13 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		ret = read_extent_buffer_pages(io_tree, eb, start,
 					       WAIT_COMPLETE,
 					       btree_get_extent, mirror_num);
-		if (!ret && !verify_parent_transid(io_tree, eb,
+		if (!ret) {
+			if (!verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
-			break;
+				break;
+			else
+				ret = -EIO;
+		}
 
 		/*
 		 * This buffer's crc is fine, but its contents are corrupted, so
-- 
1.7.11.4

