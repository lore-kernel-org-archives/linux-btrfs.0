Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57991 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbeC0Su4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:50:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D8F8AC98
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 18:50:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/6] btrfs: use RCU in btrfs_show_devname for device list traversal
Date: Tue, 27 Mar 2018 20:48:29 +0200
Message-Id: <7c574ffc98700bda85d92ffc7b9ad49b65017e9d.1522176187.git.dsterba@suse.com>
In-Reply-To: <cover.1522176187.git.dsterba@suse.com>
References: <cover.1522176187.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The show_devname callback is used to print device name in
/proc/self/mounts, we need to traverse the device list consistently and
read the name that's copied to a seq buffer so we don't need further
locking.

If the first device is being deleted at the same time, the RCU will
allow us to read the device name, though it will become stale right
after the RCU protection ends. This is unavoidable and the user can
expect that the device will disappear from the filesystem's list at some
point.

The device_list_mutex was pretty heavy as it is used eg. for writing
superblock and a few other IO related contexts. This can stall any
application that reads the proc file for no reason.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4b817947e00f..9c18f05b954d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2290,11 +2290,18 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 	struct list_head *head;
 	struct rcu_string *name;
 
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	/*
+	 * Lightweight locking of the devices. We should not need
+	 * device_list_mutex here as we only read the device data and the list
+	 * is protected by RCU.  Even if a device is deleted during the list
+	 * traversals, we'll get valid data, the freeing callback will wait at
+	 * least until until the rcu_read_unlock.
+	 */
+	rcu_read_lock();
 	cur_devices = fs_info->fs_devices;
 	while (cur_devices) {
 		head = &cur_devices->devices;
-		list_for_each_entry(dev, head, dev_list) {
+		list_for_each_entry_rcu(dev, head, dev_list) {
 			if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
 				continue;
 			if (!dev->name)
@@ -2306,14 +2313,12 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 	}
 
 	if (first_dev) {
-		rcu_read_lock();
 		name = rcu_dereference(first_dev->name);
 		seq_escape(m, name->str, " \t\n\\");
-		rcu_read_unlock();
 	} else {
 		WARN_ON(1);
 	}
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	rcu_read_unlock();
 	return 0;
 }
 
-- 
2.16.2

