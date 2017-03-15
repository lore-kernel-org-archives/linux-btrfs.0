Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751972AbdCOQD6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:03:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D64D9ADDA
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 16:03:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/7] btrfs: remove redundant parameter from reada_start_machine_dev
Date: Wed, 15 Mar 2017 17:02:39 +0100
Message-Id: <f8008e872818951e0f38474c6871e9e7e8a671ac.1489593696.git.dsterba@suse.com>
In-Reply-To: <cover.1489593696.git.dsterba@suse.com>
References: <cover.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can read fs_info from dev.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index c1fc79cd4b2a..91df381a60ce 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -649,9 +649,9 @@ static int reada_pick_zone(struct btrfs_device *dev)
 	return 1;
 }
 
-static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
-				   struct btrfs_device *dev)
+static int reada_start_machine_dev(struct btrfs_device *dev)
 {
+	struct btrfs_fs_info *fs_info = dev->fs_info;
 	struct reada_extent *re = NULL;
 	int mirror_num = 0;
 	struct extent_buffer *eb = NULL;
@@ -763,8 +763,7 @@ static void __reada_start_machine(struct btrfs_fs_info *fs_info)
 		list_for_each_entry(device, &fs_devices->devices, dev_list) {
 			if (atomic_read(&device->reada_in_flight) <
 			    MAX_IN_FLIGHT)
-				enqueued += reada_start_machine_dev(fs_info,
-								    device);
+				enqueued += reada_start_machine_dev(device);
 		}
 		mutex_unlock(&fs_devices->device_list_mutex);
 		total += enqueued;
-- 
2.12.0

