Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63663 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3FYNCV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Jun 2013 09:02:21 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so12636646pad.14
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 06:02:21 -0700 (PDT)
Message-ID: <51C994D5.3070509@gmail.com>
Date: Tue, 25 Jun 2013 21:02:13 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: avoid memory leak in btrfs_close_devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Three kind of structures need to be freed on close:
      * All struct btrfs_device managed by fs_devices
      * The name field for each struct btrfs_device
      * The above items for seed_devices

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  volumes.c |   16 +++++++++++++---
  1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/volumes.c b/volumes.c
index d6f81f8..257b740 100644
--- a/volumes.c
+++ b/volumes.c
@@ -153,6 +153,16 @@ static int device_list_add(const char *path,
  	return 0;
  }

+static void btrfs_close_device(struct btrfs_device *device)
+{
+	close(device->fd);
+	device->fd = -1;
+	device->writeable = 0;
+	if (device->name)
+		kfree(device->name);
+	kfree(device);
+}
+
  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
  {
  	struct btrfs_fs_devices *seed_devices;
@@ -161,17 +171,17 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
  again:
  	list_for_each(cur, &fs_devices->devices) {
  		device = list_entry(cur, struct btrfs_device, dev_list);
-		close(device->fd);
-		device->fd = -1;
-		device->writeable = 0;
+		btrfs_close_device(device);
  	}

  	seed_devices = fs_devices->seed;
  	fs_devices->seed = NULL;
  	if (seed_devices) {
+		kfree(fs_devices);
  		fs_devices = seed_devices;
  		goto again;
  	}
+	kfree(fs_devices);

  	return 0;
  }
-- 
1.7.10.4

