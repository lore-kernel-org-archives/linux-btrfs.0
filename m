Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50544 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLWThD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 14:37:03 -0500
Received: by mail-pa0-f43.google.com with SMTP id kx10so8533358pab.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 11:37:03 -0800 (PST)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] btrfs-progs: Fix btrfs fi show by uuid and label
Date: Tue, 23 Dec 2014 11:34:52 -0800
Message-Id: <1419363292-12271-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 8be2fff (btrfs-progs: apply realpath for btrfs fi
show when mount point is given) changed the behavior of
btrfs fi show to return an error if the call to realpath()
failed.  This broke the ability to specify a filesystem by
uuid or label.

So let's not consider a failed call to realpath() as an
error.  If the user really specified a bad device, just
return nothing like we did before.
---
 cmds-filesystem.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 8f037dd..a654e6f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -901,13 +901,8 @@ static int cmd_show(int argc, char **argv)
 		 *     realpath do  /mnt/btrfs/  => /mnt/btrfs
 		 *     which shall be recognized by btrfs_scan_kernel()
 		 */
-		if (!realpath(search, path)) {
-			fprintf(stderr, "ERROR: Could not show %s: %s\n",
-					search, strerror(errno));
-			return 1;
-		}
-
-		search = path;
+		if (realpath(search, path))
+			search = path;
 
 		/*
 		 * Needs special handling if input arg is block dev And if
-- 
1.7.10.4

