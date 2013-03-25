Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:43507 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934Ab3CYOVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 10:21:45 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.23 OK)
	with ESMTP id p03002p2P8UoVb for <linux-btrfs@vger.kernel.org>;
	Mon, 25 Mar 2013 15:21:42 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: Use /proc/mounts instead of /etc/mtab
Date: Mon, 25 Mar 2013 15:21:42 +0100
Message-Id: <1364221302-7906-1-git-send-email-sbehrens@giantdisaster.de>
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
1.8.2

