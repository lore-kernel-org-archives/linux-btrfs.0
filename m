Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65288 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933110AbbIDN0M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:26:12 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DQ066030048
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:26:00 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: search argument from index 1 in get_unit_mode_from_arg
Date: Fri, 4 Sep 2015 21:24:34 +0800
Message-ID: <7581bd31c1787563bd77b8cad97f06afdb5f56de.1441358234.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to search arg[0] in get_unit_mode_from_arg(), because
argv[0] is always command name like: "btrfs filesystem df".

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index ed1fb13..e086e23 100644
--- a/utils.c
+++ b/utils.c
@@ -3000,7 +3000,7 @@ unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode)
 	int arg_i;
 	int arg_end;
 
-	for (arg_i = 0; arg_i < *argc; arg_i++) {
+	for (arg_i = 1; arg_i < *argc; arg_i++) {
 		if (!strcmp(argv[arg_i], "--raw")) {
 			unit_mode = UNITS_RAW;
 			argv[arg_i] = NULL;
-- 
1.8.5.1

