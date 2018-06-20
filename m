Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754144AbeFTRyT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:54:19 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 1/7] btrfs: restore uuid_mutex in btrfs_open_devices
Date: Wed, 20 Jun 2018 19:51:28 +0200
Message-Id: <953899caf13686e1f128748ef3220281a1b9a47e.1529516228.git.dsterba@suse.com>
In-Reply-To: <cover.1529516226.git.dsterba@suse.com>
References: <cover.1529516226.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 542c5908abfe84f7b4c1 ("btrfs: replace uuid_mutex by
device_list_mutex in btrfs_open_devices") switched to device_list_mutex
as we need that for the device list traversal, but we also need
uuid_mutex to protect access to fs_devices::opened to be consistent with
other users of that item.

CC: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e034ad9e23b4..1da162928d1a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1146,6 +1146,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 {
 	int ret;
 
+	mutex_lock(&uuid_mutex);
 	mutex_lock(&fs_devices->device_list_mutex);
 	if (fs_devices->opened) {
 		fs_devices->opened++;
@@ -1155,6 +1156,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		ret = open_fs_devices(fs_devices, flags, holder);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
+	mutex_unlock(&uuid_mutex);
 
 	return ret;
 }
-- 
2.17.0

