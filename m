Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727590AbeIGBzn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 21:55:43 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C08D3AE2C
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2018 21:18:21 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/3] btrfs: use ->devices list instead of ->alloc_list in btrfs_trim_fs
Date: Thu,  6 Sep 2018 17:18:14 -0400
Message-Id: <20180906211816.12121-2-jeffm@suse.com>
In-Reply-To: <20180906211816.12121-1-jeffm@suse.com>
References: <20180906211816.12121-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_trim_fs iterates over the fs_devices->alloc_list while holding
the device_list_mutex.  The problem is that ->alloc_list is protected
by the chunk mutex.  We don't want to hold the chunk mutex over
the trim of the entire file system.  Fortunately, the ->dev_list
list is protected by the dev_list mutex and while it will give us
all devices, including read-only devices, we already just skip the
read-only devices.  Then we can continue to take and release the chunk
mutex while scanning each device.

Fixes: 499f377f49f (btrfs: iterate over unused chunk space in FITRIM)
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..a0e82589c3e8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11008,8 +11008,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	}
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	devices = &fs_info->fs_devices->alloc_list;
-	list_for_each_entry(device, devices, dev_alloc_list) {
+	devices = &fs_info->fs_devices->devices;
+	list_for_each_entry(device, devices, dev_list) {
 		ret = btrfs_trim_free_extents(device, range->minlen,
 					      &group_trimmed);
 		if (ret)
-- 
2.12.3
