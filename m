Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36088 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbcCIBTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 20:19:47 -0500
Received: by mail-pf0-f180.google.com with SMTP id 63so25922817pfe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Mar 2016 17:19:47 -0800 (PST)
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Subject: [PATCH] Fix broken 'device scan' arguments parsing
Date: Tue,  8 Mar 2016 17:19:40 -0800
Message-Id: <1457486380-4051-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 52179e4fea41e55f31c92cd033a0b53a5107b4f4 'btrfs-progs: unify argc
min/max checking' brokes 'btrfs device scan' command when no argument
was given. Fix this.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 cmds-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index cb470af..94ffdc5 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -273,7 +273,7 @@ static int cmd_device_scan(int argc, char **argv)
 	if (all && check_argc_max(argc - optind, 1))
 		usage(cmd_device_scan_usage);
 
-	if (all || argc - optind == 1) {
+	if (all || argc - optind == 0) {
 		printf("Scanning for Btrfs filesystems\n");
 		ret = btrfs_scan_lblkid();
 		error_on(ret, "error %d while scanning", ret);
-- 
2.5.0

