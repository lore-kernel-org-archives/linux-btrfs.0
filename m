Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41945 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab3KFKuN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 05:50:13 -0500
Received: by mail-pa0-f43.google.com with SMTP id hz1so10318008pad.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 02:50:12 -0800 (PST)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] Btrfs-progs: set return value to 0 if subvolume get-default successfully
Date: Wed,  6 Nov 2013 18:49:12 +0800
Message-Id: <1383734952-11943-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmd_subvol_get_default() returns 1 even if finds default subvolume
successfully.

Set the correct return value.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-subvolume.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f7249f8..8be6df7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -691,6 +691,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	/* no need to resolve roots if FS_TREE is default */
 	if (default_id == BTRFS_FS_TREE_OBJECTID) {
 		printf("ID 5 (FS_TREE)\n");
+		ret = 0;
 		goto out;
 	}
 
-- 
1.8.3.1

