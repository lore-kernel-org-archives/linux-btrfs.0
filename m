Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60101 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932509AbbGVH7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 03:59:44 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6M7vscr024884
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 15:57:54 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Accurate errormsg for resize operation on no-enouth-free-space case
Date: Wed, 22 Jul 2015 15:58:06 +0800
Message-ID: <c691223c924a1219af4652e51dc05b7d98e54cf2.1437551819.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

btrfs progs output following error message when doing resize on
no-enouth-free-space case:
 # btrfs filesystem resize +10g /mnt/btrfs_5gb
 Resize '/mnt/btrfs_5gb' of '+10g'
 ERROR: unable to resize '/mnt/btrfs_5gb' - File too large
 #

It is not a good description for users, and this patch changed it to:
 # ./btrfs filesystem resize +10G /mnt/tmp1
 Resize '/mnt/tmp1' of '+10G'
 ERROR: unable to resize '/mnt/tmp1' - no enouth free space
 #

Reported-by: Taeha Kim <kthguru@gmail.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-filesystem.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 800aa4d..c393ce7 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1327,8 +1327,16 @@ static int cmd_resize(int argc, char **argv)
 	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if( res < 0 ){
-		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n", 
-			path, strerror(e));
+		switch (e) {
+		case EFBIG:
+			fprintf(stderr, "ERROR: unable to resize '%s' - no enouth free space\n",
+				path);
+			break;
+		default:
+			fprintf(stderr, "ERROR: unable to resize '%s' - %s\n",
+				path, strerror(e));
+			break;
+		}
 		return 1;
 	} else if (res > 0) {
 		const char *err_str = btrfs_err_str(res);
-- 
1.8.5.1

