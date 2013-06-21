Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23832 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161368Ab3FUHyD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:54:03 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7s1wO017461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:02 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s0Oq003647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:00 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7rxIL020380
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:53:59 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/13] btrfs-progs: function to release a specific fsid from the list
Date: Fri, 21 Jun 2013 15:58:01 +0800
Message-Id: <1371801485-14571-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>

this is preparatory so that fsid found in the kernel can be
added

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 volumes.c | 20 +++++++++++++++++++-
 volumes.h |  3 +++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index aa1c3dd..81904c6 100644
--- a/volumes.c
+++ b/volumes.c
@@ -87,7 +87,7 @@ static struct btrfs_fs_devices *find_fsid(u8 *fsid)
 	return NULL;
 }
 
-static int device_list_add(const char *path,
+int device_list_add(const char *path,
 			   struct btrfs_super_block *disk_super,
 			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
 {
@@ -154,6 +154,24 @@ static int device_list_add(const char *path,
 	return 0;
 }
 
+void device_list_fini(u8 *fsid)
+{
+	struct list_head *fsids;
+	struct list_head *cur_fsid;
+	struct btrfs_fs_devices *fs_devices;
+
+	fsids = btrfs_scanned_uuids();
+	list_for_each(cur_fsid, fsids) {
+		fs_devices = list_entry(cur_fsid, struct btrfs_fs_devices,
+				list);
+		if (!memcmp(fs_devices->fsid, fsid, BTRFS_FSID_SIZE)) {
+			list_del(&fs_devices->devices);
+			list_del(&fs_devices->list);
+			break;
+		}
+	}
+}
+
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_fs_devices *seed_devices;
diff --git a/volumes.h b/volumes.h
index 911f788..6286d83 100644
--- a/volumes.h
+++ b/volumes.h
@@ -190,4 +190,7 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
                                                 u64 devid, int instance);
+int device_list_add(const char *path, struct btrfs_super_block *disk_super,
+			   u64 devid, struct btrfs_fs_devices **fs_devices_ret);
+void device_list_fini(u8 *fsid);
 #endif
-- 
1.8.1.227.g44fe835

