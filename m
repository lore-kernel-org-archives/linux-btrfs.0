Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1221 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753798AbbJZKaE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 06:30:04 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9QATT4l004075
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 18:29:29 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/5] btrfs-progs: btrfs: Add missing btrfs_close_all_devices for btrfs command
Date: Mon, 26 Oct 2015 18:28:18 +0800
Message-ID: <c062cb5cd334c0dd785a3c95e474dc8e7be5e44e.1445855131.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
References: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adding a btrfs_close_all_devices() after command callback in btrfs.c
can force-close all opened device before program exit, to avoid memory leak
in all btrfs sub-command.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/btrfs.c b/btrfs.c
index 63df377..9416a29 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -18,6 +18,7 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include "volumes.h"
 #include "crc32c.h"
 #include "commands.h"
 #include "utils.h"
@@ -214,6 +215,7 @@ int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd;
 	const char *bname;
+	int ret;
 
 	if ((bname = strrchr(argv[0], '/')) != NULL)
 		bname++;
@@ -242,5 +244,10 @@ int main(int argc, char **argv)
 	crc32c_optimization_init();
 
 	fixup_argv0(argv, cmd->token);
-	exit(cmd->fn(argc, argv));
+
+	ret = cmd->fn(argc, argv);
+
+	btrfs_close_all_devices();
+
+	exit(ret);
 }
-- 
1.8.5.1

