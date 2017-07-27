Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:33556 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdG0TYt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 15:24:49 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 8A8A4200AD
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 21:24:46 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: eliminate bogus IOC_DEV_INFO call
Date: Thu, 27 Jul 2017 21:24:46 +0200
Message-Id: <20170727192446.27158-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Device ID numbers always start at 1, not at 0. The first IOC_DEV_INFO
call does not make sense, since it will always return ENODEV.

ioctl(3, BTRFS_IOC_DEV_INFO, {devid=0}) = -1 ENODEV (No such device)

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 cmds-fi-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 101a0c4..52c4c62 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -535,7 +535,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 		return 1;
 	}
 
-	for (i = 0, ndevs = 0 ; i <= fi_args.max_id ; i++) {
+	for (i = 1, ndevs = 0 ; i <= fi_args.max_id ; i++) {
 		if (ndevs >= fi_args.num_devices) {
 			error("unexpected number of devices: %d >= %llu", ndevs,
 				(unsigned long long)fi_args.num_devices);
-- 
2.11.0

