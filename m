Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975AbaGQCqb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 22:46:31 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H2kRR4028185
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 10:46:27 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs-progs: adjust the return values for scrub
Date: Thu, 17 Jul 2014 10:40:36 +0800
Message-ID: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

o Return 0 to indicate success,
  when detected errors were corrected during scrubbing.
  P.s. This is also to facilitate scripting when return value
       is to be checked.
o Warn the users if there are uncorrectable errors detected.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-scrub.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5265a2b..f9e2b40 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1514,14 +1514,17 @@ out:
 	}
 	close_file_or_dir(fdmnt, dirstream);
 
-	if (nothing_to_resume)
-		return 2;
 	if (err)
 		return 1;
-	if (e_correctable)
+	if (nothing_to_resume)
+		return 2;
+	if (e_uncorrectable) {
+		ERR(!do_quiet, "ERROR: There are uncorrectable errors.\n");
 		return 3;
-	if (e_uncorrectable)
-		return 4;
+	}
+	if (e_correctable)
+		ERR(!do_quiet, "WARNING: errors detected during scrubbing, corrected.\n");
+
 	return 0;
 }
 
-- 
1.8.1.4

