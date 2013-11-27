Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3K0R0h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 12:26:37 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BEADFA7D46
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 18:26:36 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: use mntent functions in find_mount_root
Date: Wed, 27 Nov 2013 18:26:34 +0100
Message-Id: <1385573194-3800-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

getmntent should be used in context of *mntent functions, though
fopen/fclose works.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 43ea06b5c23f..3d2171518db8 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -72,7 +72,7 @@ int find_mount_root(const char *path, char **mount_root)
 		return -errno;
 	close(fd);
 
-	mnttab = fopen("/proc/self/mounts", "r");
+	mnttab = setmntent("/proc/self/mounts", "r");
 	if (!mnttab)
 		return -errno;
 
@@ -87,7 +87,7 @@ int find_mount_root(const char *path, char **mount_root)
 			}
 		}
 	}
-	fclose(mnttab);
+	endmntent(mnttab);
 
 	if (!longest_match) {
 		fprintf(stderr,
-- 
1.8.4.3

