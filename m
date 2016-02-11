Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbcBKQ5R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:57:17 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EB666AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:57:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 7/9] btrfs: device add and remove: use GFP_KERNEL
Date: Thu, 11 Feb 2016 17:57:15 +0100
Message-Id: <78f2c9e6dbb144f0000c9cbb79bdf19410e4007b.1455208920.git.dsterba@suse.com>
In-Reply-To: <cover.1455208920.git.dsterba@suse.com>
References: <cover.1455208920.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can safely use GFP_KERNEL in the functions called from the ioctl
handlers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335946fa..64c59795220e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -138,7 +138,7 @@ static struct btrfs_fs_devices *__alloc_fs_devices(void)
 {
 	struct btrfs_fs_devices *fs_devs;
 
-	fs_devs = kzalloc(sizeof(*fs_devs), GFP_NOFS);
+	fs_devs = kzalloc(sizeof(*fs_devs), GFP_KERNEL);
 	if (!fs_devs)
 		return ERR_PTR(-ENOMEM);
 
@@ -220,7 +220,7 @@ static struct btrfs_device *__alloc_device(void)
 {
 	struct btrfs_device *dev;
 
-	dev = kzalloc(sizeof(*dev), GFP_NOFS);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -733,7 +733,8 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		 * uuid mutex so nothing we touch in here is going to disappear.
 		 */
 		if (orig_dev->name) {
-			name = rcu_string_strdup(orig_dev->name->str, GFP_NOFS);
+			name = rcu_string_strdup(orig_dev->name->str,
+					GFP_KERNEL);
 			if (!name) {
 				kfree(device);
 				goto error;
@@ -2287,7 +2288,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		goto error;
 	}
 
-	name = rcu_string_strdup(device_path, GFP_NOFS);
+	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
 		kfree(device);
 		ret = -ENOMEM;
-- 
2.7.1

