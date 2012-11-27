Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:22084 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab2K0Rjx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 12:39:53 -0500
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp4) (RZmta 31.5 OK) with ESMTP id 603d0coARCEh0i
	for <linux-btrfs@vger.kernel.org>;
	Tue, 27 Nov 2012 18:39:52 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a scrub regression in case of write errors
Date: Tue, 27 Nov 2012 18:39:51 +0100
Message-Id: <1354037991-24564-2-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This regression was introduced by the device-replace patches.
Scrub immediately stops checking those disks that have write errors.
This is nothing that happens in the real world, but it is wrong
since scrub is the tool to detect and repair defects. Fix it.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
This patch is only for btrfs-next.

 fs/btrfs/scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 30ba997..8db6a64 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2657,7 +2657,8 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
-		if (atomic64_read(&dev_replace->num_write_errors) > 0) {
+		if (is_dev_replace &&
+		    atomic64_read(&dev_replace->num_write_errors) > 0) {
 			ret = -EIO;
 			break;
 		}
-- 
1.8.0.1

