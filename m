Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37981 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3GOIfw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 04:35:52 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6F8Zpph002548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 08:35:52 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F8ZoKE001999
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 08:35:51 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F8Zo24027320
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 08:35:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: close_all_devices() in btrfs-find-root.c does nothing
Date: Mon, 15 Jul 2013 16:40:41 +0800
Message-Id: <1373877641-12789-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866527-10604-3-git-send-email-anand.jain@oracle.com>
References: <1373866527-10604-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

close_all_devices() is declared once in disk-io.c and again
in btrfs-find-root.c. The one in latter is completely useless
so delete it.

This patch will fix it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-find-root.c |   17 +----------------
 disk-io.c         |    3 +--
 disk-io.h         |    1 +
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 253c200..82440f6 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -34,6 +34,7 @@
 #include "volumes.h"
 #include "utils.h"
 #include "crc32c.h"
+#include "disk-io.h"
 
 static u16 csum_size = 0;
 static u64 search_objectid = BTRFS_ROOT_TREE_OBJECTID;
@@ -65,22 +66,6 @@ int csum_block(void *buf, u32 len)
 	return ret;
 }
 
-static int close_all_devices(struct btrfs_fs_info *fs_info)
-{
-	struct list_head *list;
-	struct list_head *next;
-	struct btrfs_device *device;
-
-	return 0;
-
-	list = &fs_info->fs_devices->devices;
-	list_for_each(next, list) {
-		device = list_entry(next, struct btrfs_device, dev_list);
-		close(device->fd);
-	}
-	return 0;
-}
-
 static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 {
 	u32 sectorsize;
diff --git a/disk-io.c b/disk-io.c
index 5b84b02..d23c4d9 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -35,7 +35,6 @@
 #include "utils.h"
 #include "print-tree.h"
 
-static int close_all_devices(struct btrfs_fs_info *fs_info);
 
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
@@ -1165,7 +1164,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int close_all_devices(struct btrfs_fs_info *fs_info)
+int close_all_devices(struct btrfs_fs_info *fs_info)
 {
 	struct list_head *list;
 	struct btrfs_device *device;
diff --git a/disk-io.h b/disk-io.h
index 0158d17..c25bc07 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -89,6 +89,7 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		    int verify);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
+int close_all_devices(struct btrfs_fs_info *fs_info);
 #endif
 
 /* raid6.c */
-- 
1.7.7.6

