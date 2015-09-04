Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27342 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933099AbbIDNZ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:25:59 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DPmem030028
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:25:48 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/5] btrfs-progs: Avoid using uninitialized optind in cmd_rescue_zero_log
Date: Fri, 4 Sep 2015 21:24:17 +0800
Message-ID: <ec5de1a7a0e4e46cd0b51e5fb63f39a69325cf31.1441357933.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
References: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Better to avoid using optind in cmd_rescue_zero_log(), because no
getopt() before.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-rescue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index 163d0bb..a709e1b 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -182,7 +182,7 @@ int cmd_rescue_zero_log(int argc, char **argv)
 	if (check_argc_exact(argc, 2))
 		usage(cmd_rescue_zero_log_usage);
 
-	devname = argv[optind];
+	devname = argv[1];
 	ret = check_mounted(devname);
 	if (ret < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
-- 
1.8.5.1

