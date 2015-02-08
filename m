Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46155 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833AbbBIH6i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:38 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 18/24] Btrfs: sysfs: make btrfs_sysfs_add_device() non static
Date: Mon,  9 Feb 2015 07:56:19 +0800
Message-Id: <1423439785-10260-19-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index aaff124..ac06b5c 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -76,4 +76,5 @@ int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
                 struct btrfs_device *one_device);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 				struct kobject *parent);
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
 #endif /* _BTRFS_SYSFS_H_ */
-- 
2.0.0.153.g79dcccc

