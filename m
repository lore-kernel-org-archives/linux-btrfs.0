Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45753 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3F3LxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 07:53:06 -0400
Received: by mail-wi0-f178.google.com with SMTP id k10so2231259wiv.5
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 04:53:04 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/3] Btrfs-progs: add kstrdup() return value check
Date: Sun, 30 Jun 2013 12:51:45 +0100
Message-Id: <1372593106-6593-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When allocating a btrfs_device structure, device_list_add()
in volumes.c was not checking if the call to duplicate the
label string succeeded or not.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 volumes.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/volumes.c b/volumes.c
index d6f81f8..ea1d401 100644
--- a/volumes.c
+++ b/volumes.c
@@ -125,6 +125,11 @@ static int device_list_add(const char *path,
 			return -ENOMEM;
 		}
 		device->label = kstrdup(disk_super->label, GFP_NOFS);
+		if (!device->label) {
+			kfree(device->name);
+			kfree(device);
+			return -ENOMEM;
+		}
 		device->total_devs = btrfs_super_num_devices(disk_super);
 		device->super_bytes_used = btrfs_super_bytes_used(disk_super);
 		device->total_bytes =
-- 
1.7.9.5

