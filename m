Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13102 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757159AbaFSBvU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:51:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1pIaT020929
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:51:18 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: deal with invalid option combinations for btrfs-image
Date: Thu, 19 Jun 2014 09:46:01 +0800
Message-ID: <1403142363-29482-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs-image,
	dump 	may not come with option '-o'
	-r	may not come with option '-c', '-s', '-w', dev_cnt != 1
	-m	may not come with dev_cnt < 2
All of the above should be regarded as invalid combinations,
and the usage will show up.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index db5d193..549722c 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2462,6 +2462,7 @@ int main(int argc, char *argv[])
 	int ret;
 	int sanitize = 0;
 	int dev_cnt = 0;
+	int usage_error = 0;
 	FILE *out;
 
 	while (1) {
@@ -2500,15 +2501,20 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if ((old_restore) && create)
-		print_usage();
-
 	argc = argc - optind;
 	dev_cnt = argc - 1;
 
-	if (multi_devices && dev_cnt < 2)
-		print_usage();
-	if (!multi_devices && dev_cnt != 1)
+	if (create) {
+		usage_error = old_restore;
+	} else {
+		usage_error = walk_trees || sanitize || compress_level;
+		if (multi_devices)
+			usage_error = usage_error || (dev_cnt < 2);
+		else
+			usage_error = usage_error || (dev_cnt != 1);
+	}
+
+	if (usage_error)
 		print_usage();
 
 	source = argv[optind];
-- 
1.8.1.4

