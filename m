Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7689C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 17:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F8B220872
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 17:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547227097;
	bh=wLB5HgnjutDzopgHLDLFb7p5OKpLw1v/KGBrlXy4NHw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=c4PUN+ZGqLDHcqcn5/ZoLN+1ovvuKLe/085AEdieQi9vXEgxgUq0jWVWshsa1tXHi
	 DrM3HPp8f98/Ovz1l6RlkRzsff34+zoSxyr0K91u54qWgGxl7mVGwKYgCxC1yCP+3V
	 l2LDIybLlqoztJe2UOr6OrUPG+mHki2zDOljGVQU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732530AbfAKRSM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 12:18:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731663AbfAKRSM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 12:18:12 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F1F20872
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547227091;
        bh=wLB5HgnjutDzopgHLDLFb7p5OKpLw1v/KGBrlXy4NHw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=zH1rV+CmpjUJpADjk0QB5JlXYgOqLzqto+78LUITMJ83NKmFFt5RY9RlvTpGl3tBz
         CxLGLfkzZ4la5/DkDH4H+Feg6U9il0jIuJKMNTP1qpOEyLwKbfICjTqRhW4MiTnyQh
         zkl4DyJ//XqFERKXsjtFvkaARZU7Vfy/VC5SCVBg=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: avoid deadlock with memory reclaim due to allocation of devices
Date:   Fri, 11 Jan 2019 17:17:59 +0000
Message-Id: <20190111171759.19920-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213211725.14832-1-fdmanana@kernel.org>
References: <20181213211725.14832-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

In a few places we are allocating a device using the GFP_KERNEL flag when
it is not safe to do so, because if reclaim is triggered it can cause a
transaction commit while we are holding the device list mutex. This mutex
is required in the transaction commit path (at write_all_supers() and
btrfs_update_commit_device_size()).

So fix this by setting up a nofs memory allocation context in those cases.

Fixes: 78f2c9e6dbb14 ("btrfs: device add and remove: use GFP_KERNEL")
Fixes: e0ae999414238 ("btrfs: preallocate device flush bio")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Change the approach to fix the problem by setting up nofs contextes
    where needed.

 fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2576b1a379c9..663566baae78 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -14,6 +14,7 @@
 #include <linux/semaphore.h>
 #include <linux/uuid.h>
 #include <linux/list_sort.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "extent_map.h"
 #include "disk-io.h"
@@ -988,20 +989,29 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 	}
 
 	if (!device) {
+		unsigned int nofs_flag;
+
 		if (fs_devices->opened) {
 			mutex_unlock(&fs_devices->device_list_mutex);
 			return ERR_PTR(-EBUSY);
 		}
 
+		/*
+		 * Setup nofs context because we are holding the device list
+		 * mutex, which is required for a transaction commit.
+		 */
+		nofs_flag = memalloc_nofs_save();
 		device = btrfs_alloc_device(NULL, &devid,
 					    disk_super->dev_item.uuid);
 		if (IS_ERR(device)) {
+			memalloc_nofs_restore(nofs_flag);
 			mutex_unlock(&fs_devices->device_list_mutex);
 			/* we can safely leave the fs_devices entry around */
 			return device;
 		}
 
-		name = rcu_string_strdup(path, GFP_NOFS);
+		name = rcu_string_strdup(path, GFP_KERNEL);
+		memalloc_nofs_restore(nofs_flag);
 		if (!name) {
 			btrfs_free_device(device);
 			mutex_unlock(&fs_devices->device_list_mutex);
@@ -1137,11 +1147,19 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	/* We have held the volume lock, it is safe to get the devices. */
 	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
 		struct rcu_string *name;
+		unsigned int nofs_flag;
 
+		/*
+		 * Setup nofs context because we are holding the device list
+		 * mutex, which is required for a transaction commit.
+		 */
+		nofs_flag = memalloc_nofs_save();
 		device = btrfs_alloc_device(NULL, &orig_dev->devid,
 					    orig_dev->uuid);
-		if (IS_ERR(device))
+		if (IS_ERR(device)) {
+			memalloc_nofs_restore(nofs_flag);
 			goto error;
+		}
 
 		/*
 		 * This is ok to do without rcu read locked because we hold the
@@ -1151,12 +1169,14 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 			name = rcu_string_strdup(orig_dev->name->str,
 					GFP_KERNEL);
 			if (!name) {
+				memalloc_nofs_restore(nofs_flag);
 				btrfs_free_device(device);
 				goto error;
 			}
 			rcu_assign_pointer(device->name, name);
 		}
 
+		memalloc_nofs_restore(nofs_flag);
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
@@ -1262,6 +1282,7 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 	struct btrfs_fs_devices *fs_devices = device->fs_devices;
 	struct btrfs_device *new_device;
 	struct rcu_string *name;
+	unsigned int nofs_flag;
 
 	if (device->bdev)
 		fs_devices->open_devices--;
@@ -1277,17 +1298,23 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 
 	btrfs_close_bdev(device);
 
+	/*
+	 * Setup nofs context because we are holding the device list
+	 * mutex, which is required for a transaction commit.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	new_device = btrfs_alloc_device(NULL, &device->devid,
 					device->uuid);
 	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
 
 	/* Safe because we are under uuid_mutex */
 	if (device->name) {
-		name = rcu_string_strdup(device->name->str, GFP_NOFS);
+		name = rcu_string_strdup(device->name->str, GFP_KERNEL);
 		BUG_ON(!name); /* -ENOMEM */
 		rcu_assign_pointer(new_device->name, name);
 	}
 
+	memalloc_nofs_restore(nofs_flag);
 	list_replace_rcu(&device->dev_list, &new_device->dev_list);
 	new_device->fs_devices = device->fs_devices;
 
-- 
2.11.0

