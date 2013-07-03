Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38887 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab3GCRdF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 13:33:05 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so6509297wid.3
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 10:33:03 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2 3/3] Btrfs-progs: remove unused code
Date: Wed,  3 Jul 2013 18:32:41 +0100
Message-Id: <1372872761-18077-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

V2: removed unused statement in
    extent-cache.c:tree_insert() too.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-cache.c |    1 -
 volumes.c      |    2 --
 2 files changed, 3 deletions(-)

diff --git a/extent-cache.c b/extent-cache.c
index 3dd6434..a8bab59 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -44,7 +44,6 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 			return parent;
 	}
 
-	entry = rb_entry(parent, struct cache_extent, rb_node);
 	rb_link_node(node, parent, p);
 	rb_insert_color(node, root);
 	return NULL;
diff --git a/volumes.c b/volumes.c
index ea1d401..9d5e97e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -223,7 +223,6 @@ int btrfs_scan_one_device(int fd, const char *path,
 	char *buf;
 	int ret;
 	u64 devid;
-	char uuidbuf[37];
 
 	buf = malloc(4096);
 	if (!buf) {
@@ -241,7 +240,6 @@ int btrfs_scan_one_device(int fd, const char *path,
 		*total_devs = 1;
 	else
 		*total_devs = btrfs_super_num_devices(disk_super);
-	uuid_unparse(disk_super->fsid, uuidbuf);
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 
-- 
1.7.9.5

