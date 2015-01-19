Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbbASSBK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 13:01:10 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: zab@zabbo.net, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix check of running scrub
Date: Mon, 19 Jan 2015 19:01:05 +0100
Message-Id: <1421690465-2465-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Scrub on multiple devices may report wrong status if scrub finishes
early on one of them.

Reported-by: Sandy McArthur Jr <sandymac@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-scrub.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index eb50d8a65708..06c2a306f3b2 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1073,15 +1073,11 @@ static int is_scrub_running_in_kernel(int fd,
 		memset(&sp, 0, sizeof(sp));
 		sp.scrub_args.devid = di_args[i].devid;
 		ret = ioctl(fd, BTRFS_IOC_SCRUB_PROGRESS, &sp.scrub_args);
-		if (ret < 0 && errno == ENODEV)
-			continue;
-		if (ret < 0 && errno == ENOTCONN)
-			return 0;
 		if (!ret)
 			return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 static const char * const cmd_scrub_start_usage[];
-- 
2.1.3

