Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaAMNFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 08:05:43 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s0DD5gZZ015204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 13:05:43 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0DD5f3g003236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 13:05:42 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0DD5fam026863
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 13:05:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] btrfs-progs: btrfsck operations should be exclusive
Date: Mon, 13 Jan 2014 21:14:55 +0800
Message-Id: <1389618895-24460-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

this patch will make btrfsck operations to open disk in exclusive mode,
so that mount will fail when btrfsck is running

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 cmds-check.c |  3 ++-
 disk-io.c    | 10 ++++++++--
 disk-io.h    |  1 +
 volumes.c    |  2 +-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1569d6f..ac456bb 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6382,7 +6382,8 @@ int cmd_check(int argc, char **argv)
 	int option_index = 0;
 	int init_csum_tree = 0;
 	int init_extent_tree = 0;
-	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_PARTIAL;
+	enum btrfs_open_ctree_flags ctree_flags =
+				OPEN_CTREE_PARTIAL|OPEN_CTREE_O_EXCL;
 
 	while(1) {
 		int c;
diff --git a/disk-io.c b/disk-io.c
index bd90417..44d6f6f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1062,6 +1062,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	struct btrfs_fs_devices *fs_devices = NULL;
 	struct extent_buffer *eb;
 	int ret;
+	int oflags;
 
 	if (sb_bytenr == 0)
 		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
@@ -1085,9 +1086,14 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	fs_info->fs_devices = fs_devices;
 	if (flags & OPEN_CTREE_WRITES)
-		ret = btrfs_open_devices(fs_devices, O_RDWR);
+		oflags = O_RDWR;
 	else
-		ret = btrfs_open_devices(fs_devices, O_RDONLY);
+		oflags = O_RDONLY;
+
+	if (flags & OPEN_CTREE_O_EXCL)
+		oflags |= O_EXCL;
+
+	ret = btrfs_open_devices(fs_devices, oflags);
 	if (ret)
 		goto out_devices;
 
diff --git a/disk-io.h b/disk-io.h
index ca6af2d..594deba 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -32,6 +32,7 @@ enum btrfs_open_ctree_flags {
 	OPEN_CTREE_RECOVER_SUPER	= 8,
 	OPEN_CTREE_RESTORE		= 16,
 	OPEN_CTREE_NO_BLOCK_GROUPS	= 32,
+	OPEN_CTREE_O_EXCL		= 64,
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
diff --git a/volumes.c b/volumes.c
index 65be5f0..8c45851 100644
--- a/volumes.c
+++ b/volumes.c
@@ -214,7 +214,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 		if (device->devid == fs_devices->lowest_devid)
 			fs_devices->lowest_bdev = fd;
 		device->fd = fd;
-		if (flags == O_RDWR)
+		if (flags & O_RDWR)
 			device->writeable = 1;
 	}
 	return 0;
-- 
1.8.4.2

