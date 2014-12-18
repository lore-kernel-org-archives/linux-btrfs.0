Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43856 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbaLRDeo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 22:34:44 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBI3YDgB001488
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 11:34:13 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: remove uneccessary subvol name check for subvol deletion
Date: Thu, 18 Dec 2014 11:32:35 +0800
Message-ID: <1418873555-4530-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we want to delete a subvol, we first check to see whether it is
a subvolume or not. After the check, we are sure that it is a valid
subvol, don't have to check its name.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-subvolume.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 53eec46..a35e2ad 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -281,21 +281,6 @@ again:
 	vname = basename(dupvname);
 	free(cpath);
 
-	if (!test_issubvolname(vname)) {
-		fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
-			vname);
-		ret = 1;
-		goto out;
-	}
-
-	len = strlen(vname);
-	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: snapshot name too long '%s'\n",
-			vname);
-		ret = 1;
-		goto out;
-	}
-
 	fd = open_file_or_dir(dname, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", dname);
-- 
1.8.1.4

