Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:53078 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3AZSKn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jan 2013 13:10:43 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130126181042.JSMX23841.eastrmfepo103.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 26 Jan 2013 13:10:42 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH] Btrfs-progs: Fix trival compiler error in cmds-qgroup.c
Date: Sat, 26 Jan 2013 13:10:33 -0500
Message-Id: <1359223833-8214-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The compiler does not realize that usage() never returns.
Initializing the variable keeps it quiet.
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 70019d0..3ac2e14 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -338,7 +338,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	int ret = 0;
 	int fd;
 	int e;
-	char *path;
+	char *path = NULL;
 	struct btrfs_ioctl_qgroup_limit_args args;
 	unsigned long long size;
 	int compressed = 0;
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
