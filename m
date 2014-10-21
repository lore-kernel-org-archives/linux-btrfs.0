Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59655 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751959AbaJUIbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 04:31:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9L8VEx1032449
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 16:31:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: Fix number of arguments check of 'btrfs fi df'
Date: Tue, 21 Oct 2014 16:31:17 +0800
Message-ID: <1413880277-19691-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs fi df' needs exactly one arguments as mount option,
but as 3.17 we can run 'btrfs fi df' without any argument,
and it will error as "ERROR: can't access '%s'" which means
the argument number does not do what it should.

The bug is caused by manually modify the optind and use check_argc_max()
instead of the original check_argc_exact().

This patch fixes it by not modifying the optind and use check_argc_exact()
again.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

---
changlog:
v2:
   Don't introduce opt_num, use optind directly
---
 cmds-filesystem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index bb5881e..70223d8 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -241,7 +241,6 @@ static int cmd_df(int argc, char **argv)
 	DIR *dirstream = NULL;
 	unsigned unit_mode = UNITS_DEFAULT;
 
-	optind = 1;
 	while (1) {
 		int long_index;
 		static const struct option long_options[] = {
@@ -290,7 +289,7 @@ static int cmd_df(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_max(argc, optind + 1))
+	if (check_argc_exact(argc, optind + 1))
 		usage(cmd_df_usage);
 
 	path = argv[optind];
-- 
2.1.2

