Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12000 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029AbbKIKBW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:01:22 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA9A0enX031122
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 18:00:40 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: cleanup cmd_device_usage
Date: Mon, 9 Nov 2015 17:59:38 +0800
Message-ID: <0000e758dcc9eee7e01c6e19e417f2b393d9e42c.1447063147.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <068f125cbb9037fbd06cf5db81db8ae4a22ae712.1447063147.git.zhaolei@cn.fujitsu.com>
References: <068f125cbb9037fbd06cf5db81db8ae4a22ae712.1447063147.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1: Remove more_than_one variant, use iterator's value instead
2: Remove "out" mark, use break instead.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-device.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index e23ea61..739405b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -487,7 +487,6 @@ static int cmd_device_usage(int argc, char **argv)
 {
 	unsigned unit_mode;
 	int ret = 0;
-	int more_than_one = 0;
 	int i;
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
@@ -499,23 +498,22 @@ static int cmd_device_usage(int argc, char **argv)
 		int fd;
 		DIR *dirstream = NULL;
 
-		if (more_than_one)
+		if (i > 1)
 			printf("\n");
 
 		fd = btrfs_open_dir(argv[i], &dirstream, 1);
 		if (fd < 0) {
 			ret = 1;
-			goto out;
+			break;
 		}
 
 		ret = _cmd_device_usage(fd, argv[i], unit_mode);
 		close_file_or_dir(fd, dirstream);
 
 		if (ret)
-			goto out;
-		more_than_one = 1;
+			break;
 	}
-out:
+
 	return !!ret;
 }
 
-- 
1.8.5.1

