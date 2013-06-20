Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27399 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341Ab3FTMFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 08:05:44 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5KBxPRj026420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 11:59:26 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5gkC001685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:43 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5guc024016
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:42 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs-progs: skip open devices which is missing
Date: Thu, 20 Jun 2013 20:05:28 +0800
Message-Id: <1371729930-22497-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A device can be added to the device list without getting a name, so we may
access to illegal addresses while opening devices with their name.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 volumes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/volumes.c b/volumes.c
index 8285240..a06896d 100644
--- a/volumes.c
+++ b/volumes.c
@@ -186,6 +186,10 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 
 	list_for_each(cur, head) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
+		if (!device->name) {
+			printk("no name for device %llu, skip it now\n", device->devid);
+			continue;
+		}
 
 		fd = open(device->name, flags);
 		if (fd < 0) {
-- 
1.7.7

