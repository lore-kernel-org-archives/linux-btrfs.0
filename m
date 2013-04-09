Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:19656 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934464Ab3DIRIt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:49 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUV for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/17] Btrfs-progs: cleanup subvol_uuid_search memory in btrfs send/receive
Date: Tue,  9 Apr 2013 19:08:34 +0200
Message-Id: <64ff483d9188cdd48ad0cdd03331424dc2016c0f.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Call the cleanup function that was introduced with the other commit.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 1 +
 cmds-send.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index 6688d0c..fc5094e 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -824,6 +824,7 @@ int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 	ret = 0;
 
 out:
+	subvol_uuid_search_finit(&r->sus);
 	return ret;
 }
 
diff --git a/cmds-send.c b/cmds-send.c
index 3ba5af6..fcde74c 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -458,6 +458,7 @@ int cmd_send_start(int argc, char **argv)
 				goto out;
 			}
 			add_clone_source(&send, root_id);
+			subvol_uuid_search_finit(&send.sus);
 			free(subvol);
 			full_send = 0;
 			break;
@@ -630,6 +631,7 @@ int cmd_send_start(int argc, char **argv)
 out:
 	if (send.mnt_fd >= 0)
 		close(send.mnt_fd);
+	subvol_uuid_search_finit(&send.sus);
 	return ret;
 }
 
-- 
1.8.2.1

