Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36080 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751553AbdF0HCc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 03:02:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF98BAAB9
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 07:02:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: convert while loop to list_for_each_entry
Date: Tue, 27 Jun 2017 10:02:24 +0300
Message-Id: <1498546946-6853-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes, just make the loop a bit more readable

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index adf32f46a73f..9f4426014490 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4619,7 +4619,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *info = trans->fs_info;
 	struct btrfs_fs_devices *fs_devices = info->fs_devices;
-	struct list_head *cur;
+	struct btrfs_device *device;
 	struct map_lookup *map = NULL;
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
@@ -4693,22 +4693,15 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	if (!devices_info)
 		return -ENOMEM;
 
-	cur = fs_devices->alloc_list.next;
-
 	/*
 	 * in the first pass through the devices list, we gather information
 	 * about the available holes on each device.
 	 */
 	ndevs = 0;
-	while (cur != &fs_devices->alloc_list) {
-		struct btrfs_device *device;
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
 		u64 max_avail;
 		u64 dev_offset;
 
-		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
-
-		cur = cur->next;
-
 		if (!device->writeable) {
 			WARN(1, KERN_ERR
 			       "BTRFS: read-only device in alloc_list\n");
-- 
2.7.4

