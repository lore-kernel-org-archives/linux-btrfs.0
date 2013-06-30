Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58341 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3F3LxK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 07:53:10 -0400
Received: by mail-wi0-f173.google.com with SMTP id hq4so2228521wib.6
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 04:53:09 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/3] Btrfs-progs: remove unused code
Date: Sun, 30 Jun 2013 12:51:46 +0100
Message-Id: <1372593106-6593-4-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The uuid_unparse() call in btrfs_scan_one_device() was
a no-op.


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 volumes.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index ea1d401..9d5e97e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -223,7 +223,6 @@ int btrfs_scan_one_device(int fd, const char *path,
 	char *buf;
 	int ret;
 	u64 devid;
-	char uuidbuf[37];
 
 	buf = malloc(4096);
 	if (!buf) {
@@ -241,7 +240,6 @@ int btrfs_scan_one_device(int fd, const char *path,
 		*total_devs = 1;
 	else
 		*total_devs = btrfs_super_num_devices(disk_super);
-	uuid_unparse(disk_super->fsid, uuidbuf);
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 
-- 
1.7.9.5

