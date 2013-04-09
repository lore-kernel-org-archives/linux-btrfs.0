Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:24150 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUS for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/17] Btrfs-progs: close file descriptor in cmds-send.c
Date: Tue,  9 Apr 2013 19:08:31 +0200
Message-Id: <ec4641ad67590c46431e8bb02123ef01470e3978.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

valgrind found this very obvious issue.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-send.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-send.c b/cmds-send.c
index 5a7183d..3ba5af6 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -82,6 +82,7 @@ int find_mount_root(const char *path, char **mount_root)
 			}
 		}
 	}
+	fclose(mnttab);
 
 	*mount_root = realpath(longest_match, NULL);
 	free(longest_match);
-- 
1.8.2.1

