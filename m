Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37989 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554Ab3KDVhA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:37:00 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] btrfs: remove unused variable from scrub_fixup_nodatasum
Date: Mon,  4 Nov 2013 22:34:27 +0100
Message-Id: <1383600869-10085-8-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/scrub.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a18e0e2..84139c6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -705,13 +705,11 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 	struct scrub_fixup_nodatasum *fixup;
 	struct scrub_ctx *sctx;
 	struct btrfs_trans_handle *trans = NULL;
-	struct btrfs_fs_info *fs_info;
 	struct btrfs_path *path;
 	int uncorrectable = 0;
 
 	fixup = container_of(work, struct scrub_fixup_nodatasum, work);
 	sctx = fixup->sctx;
-	fs_info = fixup->root->fs_info;
 
 	path = btrfs_alloc_path();
 	if (!path) {
-- 
1.7.10.4

