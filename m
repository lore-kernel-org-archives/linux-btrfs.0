Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34711 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008AbcDEP20 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 11:28:26 -0400
Received: by mail-lf0-f48.google.com with SMTP id j11so13088974lfb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 08:28:25 -0700 (PDT)
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>
Subject: [PATCH] btrfs-progs: device stats: Print devid instead of null
Date: Tue,  5 Apr 2016 17:27:43 +0200
Message-Id: <1459870063-6439-1-git-send-email-patrik.lundquist@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Print e.g. "[devid:4].write_io_errs   6" instead of
"[(null)].write_io_errs   6" when device is missing.

Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>
---
 cmds-device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index b17b6c6..7616c43 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -447,6 +447,13 @@ static int cmd_device_stats(int argc, char **argv)
 
 			canonical_path = canonicalize_path((char *)path);
 
+			/* No path when device is missing. */
+			if (!canonical_path) {
+				canonical_path = malloc(32);
+				snprintf(canonical_path, 32,
+					 "devid:%llu", args.devid);
+			}
+
 			if (args.nr_items >= BTRFS_DEV_STAT_WRITE_ERRS + 1)
 				printf("[%s].write_io_errs   %llu\n",
 				       canonical_path,
-- 
2.8.0.rc3

