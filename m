Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36617 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3J1Qah (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 12:30:37 -0400
Received: by mail-wg0-f47.google.com with SMTP id c11so6732261wgh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 09:30:35 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix csum search offset/length calculation in log tree
Date: Mon, 28 Oct 2013 16:30:29 +0000
Message-Id: <1382977829-5904-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were setting the csums search offset and length to the right values if
the extent is compressed, but later on right before doing the csums lookup
we were overriding these two parameters regardless of compression being
set or not for the extent.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tree-log.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2ff031a..d75303e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3458,11 +3458,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	if (skip_csum)
 		return 0;
 
-	if (em->compress_type) {
-		csum_offset = 0;
-		csum_len = block_len;
-	}
-
 	/*
 	 * First check and see if our csums are on our outstanding ordered
 	 * extents.
@@ -3546,8 +3541,13 @@ unlocked:
 	if (!mod_len || ret)
 		return ret;
 
-	csum_offset = mod_start - em->start;
-	csum_len = mod_len;
+	if (em->compress_type) {
+		csum_offset = 0;
+		csum_len = block_len;
+	} else {
+		csum_offset = mod_start - em->start;
+		csum_len = mod_len;
+	}
 
 	/* block start is already adjusted for the file extent offset. */
 	ret = btrfs_lookup_csums_range(log->fs_info->csum_root,
-- 
1.7.9.5

