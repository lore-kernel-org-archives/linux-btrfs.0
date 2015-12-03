Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbbLCQ6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:58:14 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D389CAAC3
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:58:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/12] btrfs: make btrfs_close_one_device static
Date: Thu,  3 Dec 2015 17:56:22 +0100
Message-Id: <87ad58c5f07444ab2fa083c62b154f38ef0a3035.1449161602.git.dsterba@suse.com>
In-Reply-To: <cover.1449161602.git.dsterba@suse.com>
References: <cover.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 3 ++-
 fs/btrfs/volumes.h | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a6df8fdc1312..e335938825e1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -125,6 +125,7 @@ static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
+static void btrfs_close_one_device(struct btrfs_device *device);
 
 DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
@@ -6951,7 +6952,7 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info)
 	}
 }
 
-void btrfs_close_one_device(struct btrfs_device *device)
+static void btrfs_close_one_device(struct btrfs_device *device)
 {
 	struct btrfs_fs_devices *fs_devices = device->fs_devices;
 	struct btrfs_device *new_device;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ec5712372732..2dc59eba188d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -566,6 +566,5 @@ static inline void unlock_chunks(struct btrfs_root *root)
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
-void btrfs_close_one_device(struct btrfs_device *device);
 
 #endif
-- 
2.6.2

