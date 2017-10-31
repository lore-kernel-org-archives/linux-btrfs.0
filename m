Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932386AbdJaRqh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A8C5FABF4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/11] btrfs: dev_alloc_list is not protected by RCU, use normal list_del
Date: Tue, 31 Oct 2017 18:44:47 +0100
Message-Id: <2e58a1fff7b50e0b210d05ea9f2314785c6e047c.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dev_alloc_list list could be protected by various mutexes,
depending on the context. The list tracks devices that can take part of
allocating new chunks, so the closest mutex is chunk_mutex. Adding a new
device from inside the ADD_DEV ioctl will need device_list_mutex and
registering a new device from the ioctl needs uuid_mutex.

All mutexes naturally guarantee exclusivity against the same context.
The device ownership can move between the contexts and the exclusivity
is guaranteed by other means, eg. during the mount with the uuid_mutex.

There's no RCU involved for dev_alloc_list.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 098affc58361..6e45751ed957 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2054,7 +2054,7 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 	fs_devices = srcdev->fs_devices;
 
 	list_del_rcu(&srcdev->dev_list);
-	list_del_rcu(&srcdev->dev_alloc_list);
+	list_del(&srcdev->dev_alloc_list);
 	fs_devices->num_devices--;
 	if (srcdev->missing)
 		fs_devices->missing_devices--;
-- 
2.14.0

