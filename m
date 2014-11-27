Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15539 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882AbaK0CDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 21:03:25 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAR233e5010587
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 10:03:03 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix return value problem for btrfs sub show
Date: Thu, 27 Nov 2014 10:01:34 +0800
Message-ID: <1417053695-14210-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you exec:
	# btrfs sub show <dir>	<== non-subvolume dir
The cmd print error messages as expected, but returns 0.
By convetion, it should return non-zero and we should explicitly
set it before it goto out.

With other pieces adopted:
1) removed a unnecessary return value set -EINVAL
2) fixed another code branch which may return 0 upon error.
3) with 2) applied, the ret = 0 follows can be removed

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-subvolume.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index fa58a24..53eec46 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -906,6 +906,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	}
 	if (!ret) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", fullpath);
+		ret = 1;
 		goto out;
 	}
 
@@ -919,7 +920,6 @@ static int cmd_subvol_show(int argc, char **argv)
 		fprintf(stderr,
 			"ERROR: %s doesn't belong to btrfs mount point\n",
 			fullpath);
-		ret = -EINVAL;
 		goto out;
 	}
 	ret = 1;
@@ -958,13 +958,13 @@ static int cmd_subvol_show(int argc, char **argv)
 	memset(&get_ri, 0, sizeof(get_ri));
 	get_ri.root_id = sv_id;
 
-	if (btrfs_get_subvol(mntfd, &get_ri)) {
+	ret = btrfs_get_subvol(mntfd, &get_ri);
+	if (ret) {
 		fprintf(stderr, "ERROR: can't find '%s'\n",
 			svpath);
 		goto out;
 	}
 
-	ret = 0;
 	/* print the info */
 	printf("%s\n", fullpath);
 	printf("\tName: \t\t\t%s\n", get_ri.name);
-- 
1.8.1.4

