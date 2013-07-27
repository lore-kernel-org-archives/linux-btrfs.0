Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:50350 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3G0KNE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jul 2013 06:13:04 -0400
From: Azat Khuzhin <a3at.mail@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Azat Khuzhin <a3at.mail@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] btrfs: use list_for_each_entry_safe() when delete items
Date: Sat, 27 Jul 2013 14:12:45 +0400
Message-Id: <1374919965-11690-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace list_for_each_entry() by list_for_each_entry_safe() in
__btrfs_close_devices()

There is another place that delete items lock_stripe_add(), but there we
don't need safe version, because after deleting we exit from loop.

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..1d1b595 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -616,13 +616,13 @@ static void free_device(struct rcu_head *head)
 
 static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
-	struct btrfs_device *device;
+	struct btrfs_device *device, *next;
 
 	if (--fs_devices->opened > 0)
 		return 0;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		struct btrfs_device *new_device;
 		struct rcu_string *name;
 
-- 
1.7.10.4

