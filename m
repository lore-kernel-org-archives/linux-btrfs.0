Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34869 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdHaLAy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 07:00:54 -0400
Received: by mail-lf0-f65.google.com with SMTP id h132so230002lfh.2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 04:00:54 -0700 (PDT)
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>
Subject: [PATCH] btrfs-progs: device usage: don't calculate slack on missing device
Date: Thu, 31 Aug 2017 13:00:24 +0200
Message-Id: <20170831110024.9580-1-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Print      Device slack:              0.00B
instead of Device slack:           16.00EiB

Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>
---
 cmds-fi-usage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 101a0c4..6c846c1 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -1040,6 +1040,7 @@ void print_device_sizes(struct device_info *devinfo, unsigned unit_mode)
 		pretty_size_mode(devinfo->device_size, unit_mode));
 	printf("   Device slack: %*s%10s\n",
 		(int)(20 - strlen("Device slack")), "",
-		pretty_size_mode(devinfo->device_size - devinfo->size,
+		pretty_size_mode(devinfo->device_size > 0 ?
+			devinfo->device_size - devinfo->size : 0,
 			unit_mode));
 }
-- 
2.14.1

