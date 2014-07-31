Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38986 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaGaRxp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 13:53:45 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add support to check for FALLOC_FL_COLLAPSE_RANGE  and FALLOC_FL_ZERO_RANGE crap modes
Date: Thu, 31 Jul 2014 13:53:33 -0400
Message-Id: <1406829213-4759-1-git-send-email-xerofoify@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds checks for the stated modes as if they are crap we will return error
not supported.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/btrfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1f2b99c..599495a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2490,7 +2490,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 	alloc_end = round_up(offset + len, blocksize);
 
 	/* Make sure we aren't being give some crap mode */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE|
+	FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-- 
1.7.10.4

