Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18381 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758463AbaGXDdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:33:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3XD8T017254
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:33:13 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/3] btrfs-progs: output the correct path when fi-usage failed
Date: Thu, 24 Jul 2014 11:27:28 +0800
Message-ID: <1406172448-11454-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1406172114-10793-2-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1406172114-10793-2-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we exec the following cmd:
	# btrfs file usage -t <path>  <-- an invalid path
output:
	# ERROR： can't access '-t'
should be:
	# ERROR: can't access 'path'

Just replace the static 'argv[1]' with 'argv[i]'.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: add missing signoff-by
---
 cmds-fi-disk_usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 78dc414..1f4c88e 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -835,7 +835,7 @@ int cmd_filesystem_usage(int argc, char **argv)
 		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
 			fprintf(stderr, "ERROR: can't access '%s'\n",
-				argv[1]);
+				argv[i]);
 			ret = 1;
 			goto out;
 		}
-- 
1.8.1.4

