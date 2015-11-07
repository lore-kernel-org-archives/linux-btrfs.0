Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35478 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbbKGA06 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 19:26:58 -0500
Received: by lfbn126 with SMTP id n126so79260499lfb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 16:26:56 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH] btrfs-progs: allow device deletion using 'missing' keyword again
Date: Sat,  7 Nov 2015 01:26:24 +0100
Message-Id: <1446855984-5123-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Device deletion procedures ensures the device is a block device.
This patch introduces 'missing' as keyword again, correctly
passing it on to the kernel instead of complaining about
'missing' not being a block device.

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 cmds-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index c2f3a40..dca30d7 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -161,7 +161,7 @@ static int _cmd_device_remove(int argc, char **argv,
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
-		if (is_block_device(argv[i]) != 1) {
+		if (is_block_device(argv[i]) != 1 && strcmp(argv[i], "missing")) {
 			fprintf(stderr,
 				"ERROR: %s is not a block device\n", argv[i]);
 			ret++;
-- 
2.6.2

