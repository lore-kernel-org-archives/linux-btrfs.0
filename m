Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:56487 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3ATVEn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:43 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210442.XETU2891.eastrmfepo101.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:42 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Arvin Schnell <aschnell@suse.de>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 13/13] trivial patch for btrfs-progs
Date: Sun, 20 Jan 2013 16:04:18 -0500
Message-Id: <1358715858-4469-14-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arvin Schnell <aschnell@suse.de>

Hi,

please find attached a trivial patch for btrfs-progs. Likely not
strictly needed but I noticed valgrind complaining about
uninitialised memory in the ioctl call.

Regards,
  Arvin

Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-send.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-send.c b/cmds-send.c
index b33c802..595a5d0 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -273,6 +273,7 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 		goto out;
 	}
 
+	memset(&io_send, 0, sizeof(io_send));
 	io_send.send_fd = pipefd[1];
 	send->send_fd = pipefd[0];
 
-- 
1.8.1

