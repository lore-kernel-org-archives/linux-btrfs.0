Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48898 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3FVFdD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 01:33:03 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH 2/5] Btrfs-progs: skip open devices which is missing
Date: Sat, 22 Jun 2013 13:32:42 +0800
Message-Id: <1371879165-4993-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
References: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A device can be added to the device list without getting a name, so we may
access to illegal addresses while opening devices with their name.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 volumes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/volumes.c b/volumes.c
index e7923ee..f9ac2af 100644
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

