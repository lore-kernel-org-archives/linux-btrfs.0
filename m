Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:23706 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934529Ab3DIRIt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:49 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUR for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/17] Btrfs-progs: Use /proc/mounts instead of /etc/mtab
Date: Tue,  9 Apr 2013 19:08:29 +0200
Message-Id: <1b0cf19d1edcb1d07ed0dc8fe76c7049dff2d42f.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

/etc/mtab is not working correctly in situations where multiple
mount namespaces are used. Use /proc/mounts instead like the
rest of the code is doing it.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-send.c b/cmds-send.c
index b2a340e..5a7183d 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -70,7 +70,7 @@ int find_mount_root(const char *path, char **mount_root)
 		return -errno;
 	close(fd);
 
-	mnttab = fopen("/etc/mtab", "r");
+	mnttab = fopen("/proc/mounts", "r");
 	while ((ent = getmntent(mnttab))) {
 		len = strlen(ent->mnt_dir);
 		if (strncmp(ent->mnt_dir, path, len) == 0) {
-- 
1.8.2.1

