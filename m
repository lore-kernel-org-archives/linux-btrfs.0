Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28073 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847AbbELXbq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 19:31:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: clm@fb.com, jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] btrfs: use after free when closing devices
Date: Tue, 12 May 2015 19:31:37 -0400
Message-Id: <1431473498-15773-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_close_devices() would call_rcu to free the device, which is racy with
list_for_each_entry() accessing the memory to retrieve the next device on the
list.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8e8d1d1..253b349 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -693,13 +693,13 @@ static void free_device(struct rcu_head *head)
 
 static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
-	struct btrfs_device *device;
+	struct btrfs_device *device, *tmp;
 
 	if (--fs_devices->opened > 0)
 		return 0;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
 		struct btrfs_device *new_device;
 		struct rcu_string *name;
 
-- 
1.7.10.4

