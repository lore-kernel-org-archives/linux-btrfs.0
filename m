Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:52503 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3IAKUU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 06:20:20 -0400
From: Azat Khuzhin <a3at.mail@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, miaox@cn.fujitsu.com,
        Azat Khuzhin <a3at.mail@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] btrfs: use list_for_each_entry_safe() when delete items
Date: Sun,  1 Sep 2013 14:19:15 +0400
Message-Id: <1378030756-22166-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace list_for_each_entry() by list_for_each_entry_safe() in
__btrfs_close_devices()

list_for_each_entry() {
        list_replace_rcu();
        call_rcu();             <--    We may free the device, if we get next
                                       device by the current one, the page fault
                                       may happen.
}

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
V2: Add some comments from Miao into commit message

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

