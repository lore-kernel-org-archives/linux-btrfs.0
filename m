Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:34942 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbcEDNgr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 09:36:47 -0400
Received: by mail-lf0-f50.google.com with SMTP id j8so59941302lfd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 06:36:47 -0700 (PDT)
From: Marek Rusinowski <marekrusinowski@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Marek Rusinowski <marekrusinowski@gmail.com>
Subject: [PATCH] btrfs-progs: subvolume sync: fix handling of -s option
Date: Wed,  4 May 2016 15:36:35 +0200
Message-Id: <1462368995-24542-1-git-send-email-marekrusinowski@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Setting check interval for subvolume sync resulted
in picking wrong element from argv for it's value:

  $ btrfs subvolume sync -s 10 ./dir
  ERROR: invalid sleep interval ./dir
  $ btrfs subvolume sync ./dir -s 10
  Segmentation fault

Signed-off-by: Marek Rusinowski <marekrusinowski@gmail.com>
---
 cmds-subvolume.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 2319684..c444617 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1194,10 +1194,9 @@ static int cmd_subvol_sync(int argc, char **argv)
 
 		switch (c) {
 		case 's':
-			sleep_interval = atoi(argv[optind]);
+			sleep_interval = atoi(optarg);
 			if (sleep_interval < 1) {
-				error("invalid sleep interval %s",
-					argv[optind]);
+				error("invalid sleep interval %s", optarg);
 				ret = 1;
 				goto out;
 			}
-- 
2.8.1

