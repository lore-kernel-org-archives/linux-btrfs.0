Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8488 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756699AbaIDDKA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 23:10:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8439uBN005338
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Sep 2014 11:09:56 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: remove wrong set_argv0 for restore
Date: Thu, 4 Sep 2014 11:09:24 +0800
Message-ID: <1409800164-14491-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1409800164-14491-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1409800164-14491-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, you could see the following after exec restore
	# :too few arguments

The tool name "btrfs restore" is missing.

The @set_argv0() function is introduced by:
	commit a184abc70f7b1468e6036ab576f1587ee0574668
	btrfs-progs: move the check_argc_* functions into utils.c
	...
	Also add a new function "set_argv0" to set the correct tool name:
        *btrfs-image*: too few arguments

But @set_argv0() only applies to the independent tools with
the name pattern btrfs-***.
Since restore is now is subcommand under "btrfs",
there is no need to use @set_argv0() before check_argc_* to
repair the prompt tool name before "too few arguments".

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index f909429..38a131e 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1229,7 +1229,6 @@ int cmd_restore(int argc, char **argv)
 		}
 	}
 
-	set_argv0(argv);
 	if (!list_roots && check_argc_min(argc - optind, 2))
 		usage(cmd_restore_usage);
 	else if (list_roots && check_argc_min(argc - optind, 1))
-- 
1.8.1.4

