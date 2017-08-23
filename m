Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:34459 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753238AbdHWGqS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:46:18 -0400
Received: by mail-pg0-f54.google.com with SMTP id s14so4042321pgs.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:46:18 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 6/7] Btrfs: make some volumes.c functions static
Date: Tue, 22 Aug 2017 23:46:04 -0700
Message-Id: <cc1060b3024f9731796e5d57fc272a0862661efb.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

These aren't used outside of volumes.c.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/volumes.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9b7a8e6257ee..9f2ed74a2c81 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -594,7 +594,7 @@ static void pending_bios_fn(struct btrfs_work *work)
 }
 
 
-void btrfs_free_stale_device(struct btrfs_device *cur_dev)
+static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 {
 	struct btrfs_fs_devices *fs_devs;
 	struct btrfs_device *dev;
@@ -1110,14 +1110,15 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	return ret;
 }
 
-void btrfs_release_disk_super(struct page *page)
+static void btrfs_release_disk_super(struct page *page)
 {
 	kunmap(page);
 	put_page(page);
 }
 
-int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
-		struct page **page, struct btrfs_super_block **disk_super)
+static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
+				 struct page **page,
+				 struct btrfs_super_block **disk_super)
 {
 	void *p;
 	pgoff_t index;
@@ -1860,8 +1861,9 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
-					struct btrfs_device *device)
+static struct btrfs_device *
+btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
+			      struct btrfs_device *device)
 {
 	struct btrfs_device *next_device;
 
-- 
2.14.1

