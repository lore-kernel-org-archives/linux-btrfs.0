Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12000 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752645AbbKIKBY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:01:24 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA9A0fQF031126
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 18:00:41 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: Remove noused path argument in _cmd_device_usage
Date: Mon, 9 Nov 2015 17:59:39 +0800
Message-ID: <5a8b2bad6c1f0fb6a6778d68fbdcc5ee5e831b78.1447063147.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <068f125cbb9037fbd06cf5db81db8ae4a22ae712.1447063147.git.zhaolei@cn.fujitsu.com>
References: <068f125cbb9037fbd06cf5db81db8ae4a22ae712.1447063147.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument of char *path in _cmd_device_usage() is not necessary,
remove it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 739405b..190bed6 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -454,7 +454,7 @@ static const char * const cmd_device_usage_usage[] = {
 	NULL
 };
 
-static int _cmd_device_usage(int fd, char *path, unsigned unit_mode)
+static int _cmd_device_usage(int fd, unsigned unit_mode)
 {
 	int i;
 	int ret = 0;
@@ -507,7 +507,7 @@ static int cmd_device_usage(int argc, char **argv)
 			break;
 		}
 
-		ret = _cmd_device_usage(fd, argv[i], unit_mode);
+		ret = _cmd_device_usage(fd, unit_mode);
 		close_file_or_dir(fd, dirstream);
 
 		if (ret)
-- 
1.8.5.1

