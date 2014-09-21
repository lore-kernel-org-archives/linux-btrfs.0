Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:63881 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaIUBBa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 21:01:30 -0400
Received: by mail-we0-f180.google.com with SMTP id u56so1300860wes.39
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 18:01:28 -0700 (PDT)
From: Dimitri John Ledkov <xnox@debian.org>
To: linux-btrfs@vger.kernel.org
Cc: Dimitri John Ledkov <xnox@debian.org>
Subject: [PATCH 1/4] Properly cast to avoid compiler warnings, fixes FTBFS on alpha and ia64.
Date: Sun, 21 Sep 2014 02:01:19 +0100
Message-Id: <1411261282-26831-1-git-send-email-xnox@debian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bug-Debian: http://bugs.debian.org/539433
Bug-Debian: http://bugs.debian.org/583768
Authors:
 Luca Bruno <lucab@debian.org>
 Alexander Kurtz <kurtz.alex@googlemail.com>
 Daniel Baumann <daniel.baumann@progress-technologies.net>

Signed-off-by: Dimitri John Ledkov <xnox@debian.org>
---
 btrfs-convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 71b7bd6..3673050 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2441,7 +2441,7 @@ static int do_rollback(const char *devname)
 	ext2_root = btrfs_read_fs_root(root->fs_info, &key);
 	if (!ext2_root || IS_ERR(ext2_root)) {
 		fprintf(stderr, "unable to open subvol %llu\n",
-			key.objectid);
+			(unsigned long long) key.objectid);
 		goto fail;
 	}
 
-- 
2.1.0.rc1

