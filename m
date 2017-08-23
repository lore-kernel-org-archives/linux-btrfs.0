Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:34456 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbdHWGqS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:46:18 -0400
Received: by mail-pg0-f54.google.com with SMTP id s14so4042209pgs.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:46:17 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 5/7] Btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
Date: Tue, 22 Aug 2017 23:46:03 -0700
Message-Id: <433d5c3c5a47154a8bead243a9f6e0c8b3b7ad7d.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

A naked read of the value of an RCU pointer isn't safe. Put the whole
access in an RCU critical section, not just the pointer dereference.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index befeacd0e847..cf71d0304671 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2823,6 +2823,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	int ret = 0;
 	char *s_uuid = NULL;
+	struct rcu_string *name;
 
 	di_args = memdup_user(arg, sizeof(*di_args));
 	if (IS_ERR(di_args))
@@ -2843,17 +2844,16 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	di_args->bytes_used = btrfs_device_get_bytes_used(dev);
 	di_args->total_bytes = btrfs_device_get_total_bytes(dev);
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	if (dev->name) {
-		struct rcu_string *name;
 
-		rcu_read_lock();
-		name = rcu_dereference(dev->name);
+	rcu_read_lock();
+	name = rcu_dereference(dev->name);
+	if (name) {
 		strncpy(di_args->path, name->str, sizeof(di_args->path));
-		rcu_read_unlock();
 		di_args->path[sizeof(di_args->path) - 1] = 0;
 	} else {
 		di_args->path[0] = '\0';
 	}
+	rcu_read_unlock();
 
 out:
 	mutex_unlock(&fs_devices->device_list_mutex);
-- 
2.14.1

