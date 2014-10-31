Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42517 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422652AbaJaC1l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 22:27:41 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2 v4] btrfs-progs: introduce btrfs_register_all_device()
Date: Fri, 31 Oct 2014 12:11:19 +0800
Message-Id: <1414728680-25468-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is to register all devices found after scanning
the system. Before we had this functionality with in the
btrfs_scan_lblkid(), however scanning and registering are two
different distinct operation its better keep them separate.
Also we want to optimize btrfs_scan_lblkid and avoid multiple
system scans unless needed. As of now device scan uses this function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1-v3: nothing changed, match version with its partner patch
   v4: changes per review comments. moved func to utils.c
       tested as below:
        cat /proc/fs/btrfs/devlist | egrep fsid
	btrfs dev scan
	cat /proc/fs/btrfs/devlist | egrep fsid
	[fsid: 2440b569-02d7-45a3-966c-8277f0c43f6a]
	[fsid: 6c5e1019-db9e-4a60-affd-4de88db14b04]
	[fsid: 7ddbe346-f50e-42fc-89c7-a60297772b1f]


 utils.c | 27 +++++++++++++++++++++++++++
 utils.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/utils.c b/utils.c
index 90e228b..aef0e5e 100644
--- a/utils.c
+++ b/utils.c
@@ -1266,6 +1266,33 @@ int btrfs_register_one_device(char *fname)
 	return ret;
 }
 
+/*
+ * Register all devices in the fs_uuid list created in the user
+ * space. Ensure btrfs_scan_lblkid() is called before this func.
+ */
+int btrfs_register_all_devices(void)
+{
+	int err;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+	struct list_head *all_uuids;
+
+	all_uuids = btrfs_scanned_uuids();
+
+	list_for_each_entry(fs_devices, all_uuids, list) {
+		list_for_each_entry(device, &fs_devices->devices, dev_list) {
+			if (strlen(device->name) != 0) {
+				err = btrfs_register_one_device(device->name);
+				if (err < 0)
+					return err;
+				if (err > 0)
+					return -err;
+			}
+		}
+	}
+	return 0;
+}
+
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset)
 {
diff --git a/utils.h b/utils.h
index fea26ef..65df2e4 100644
--- a/utils.h
+++ b/utils.h
@@ -82,6 +82,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(int run_ioctls);
 int btrfs_register_one_device(char *fname);
+int btrfs_register_all_devices(void);
 char *canonicalize_dm_name(const char *ptname);
 char *canonicalize_path(const char *path);
 int check_mounted(const char *devicename);
-- 
2.0.0.153.g79dcccc

