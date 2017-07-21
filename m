Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750737AbdGUI22 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 04:28:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A357AC40
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 08:28:27 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: round down size diff when shrinking/growing device
Date: Fri, 21 Jul 2017 11:28:24 +0300
Message-Id: <1500625704-29861-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Further testing showed that the fix introduced in 7dfb8be11b5d
("btrfs: Round down values which are written for total_bytes_size") was
insufficient and it could still lead to discrepancies between the total_bytes in
the super block and the device total bytes. So this patch also ensures that
the difference between old/new sizes when shrinking/growing is also
rounded down. This ensure that we won't be substracting/adding a non-sectorsize
multiples to the superblock/device total sizees.

Fixes: 7dfb8be11b5d ("btrfs: Round down values which are written for total_bytes_size")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fa779875bcfb..774b4168841a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2701,7 +2701,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&fs_info->chunk_mutex);
 	old_total = btrfs_super_total_bytes(super_copy);
-	diff = new_size - device->total_bytes;
+	diff = round_down(new_size - device->total_bytes, fs_info->sectorsize);
 
 	if (new_size <= device->total_bytes ||
 	    device->is_tgtdev_for_dev_replace) {
@@ -4399,7 +4399,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	u64 diff;
 
 	new_size = round_down(new_size, fs_info->sectorsize);
-	diff = old_size - new_size;
+	diff = round_down(old_size - new_size, fs_info->sectorsize);
 
 	if (device->is_tgtdev_for_dev_replace)
 		return -EINVAL;
-- 
2.7.4

