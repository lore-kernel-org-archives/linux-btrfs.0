Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36039 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbbHXIqp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 04:46:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7O8kbbK002344
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 16:46:37 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: Introduce btrfs_close_all_devices to close all fs_devices in fs_uuids list
Date: Mon, 24 Aug 2015 16:45:02 +0800
Message-ID: <9f0cf7c0a07faefb4f3af86f8e7c63b56a338b7a.1440405874.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If more than one fs_devices in fs_uuids list(as mkfs.btrfs), we need
close them all before exit.
This function is for above propose.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 volumes.c | 11 +++++++++++
 volumes.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/volumes.c b/volumes.c
index f7462c5..ca50f1c 100644
--- a/volumes.c
+++ b/volumes.c
@@ -198,6 +198,17 @@ again:
 	return 0;
 }
 
+void btrfs_close_all_devices(void)
+{
+	struct btrfs_fs_devices *fs_devices;
+
+	while (!list_empty(&fs_uuids)) {
+		fs_devices = list_entry(fs_uuids.next, struct btrfs_fs_devices,
+					list);
+		btrfs_close_devices(fs_devices);
+	}
+}
+
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 {
 	int fd;
diff --git a/volumes.h b/volumes.h
index 71d5d66..f776131 100644
--- a/volumes.h
+++ b/volumes.h
@@ -187,6 +187,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       int flags);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
+void btrfs_close_all_devices(void);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
-- 
1.8.5.1

