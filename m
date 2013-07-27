Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63320 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3G0FQG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jul 2013 01:16:06 -0400
From: Azat Khuzhin <a3at.mail@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Azat Khuzhin <a3at.mail@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] btrfs: use list_for_each_entry_safe() when delete items
Date: Sat, 27 Jul 2013 09:15:49 +0400
Message-Id: <1374902150-389-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace list_for_each_entry() by list_for_each_entry_safe() in next
functions:
- lock_stripe_add()
- __btrfs_close_devices()

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 fs/btrfs/raid56.c  |    4 ++--
 fs/btrfs/volumes.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0525e13..37e6dc9 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -636,7 +636,7 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 {
 	int bucket = rbio_bucket(rbio);
 	struct btrfs_stripe_hash *h = rbio->fs_info->stripe_hash_table->table + bucket;
-	struct btrfs_raid_bio *cur;
+	struct btrfs_raid_bio *cur, *next;
 	struct btrfs_raid_bio *pending;
 	unsigned long flags;
 	DEFINE_WAIT(wait);
@@ -646,7 +646,7 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 	int walk = 0;
 
 	spin_lock_irqsave(&h->lock, flags);
-	list_for_each_entry(cur, &h->hash_list, hash_list) {
+	list_for_each_entry_safe(cur, next, &h->hash_list, hash_list) {
 		walk++;
 		if (cur->raid_map[0] == rbio->raid_map[0]) {
 			spin_lock(&cur->bio_list_lock);
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

