Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16487 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaAOEPX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 23:15:23 -0500
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH v2] btrfs-progs: btrfsck operations should be exclusive
Date: Wed, 15 Jan 2014 12:15:07 +0800
Message-Id: <1389759307-10186-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1389618895-24460-1-git-send-email-anand.jain@oracle.com>
References: <1389618895-24460-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

this patch will make the btrfsck and btrfsck --repair
to work in exclusive mode, by opening the device
with the O_EXCL flag

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 v2: renamed OPEN_CTREE_O_EXCL to OPEN_CTREE_EXCLUSIVE, thanks David

 cmds-check.c |  3 ++-
 disk-io.c    | 10 ++++++++--
 disk-io.h    |  1 +
 volumes.c    |  2 +-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1569d6f..6c4a951 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6382,7 +6382,8 @@ int cmd_check(int argc, char **argv)
 	int option_index = 0;
 	int init_csum_tree = 0;
 	int init_extent_tree = 0;
-	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_PARTIAL;
+	enum btrfs_open_ctree_flags ctree_flags =
+				OPEN_CTREE_PARTIAL|OPEN_CTREE_EXCLUSIVE;
 
 	while(1) {
 		int c;
diff --git a/disk-io.c b/disk-io.c
index bd90417..fc7c645 100644
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
+	if (flags & OPEN_CTREE_EXCLUSIVE)
+		oflags |= O_EXCL;
+
+	ret = btrfs_open_devices(fs_devices, oflags);
 	if (ret)
 		goto out_devices;
 
diff --git a/disk-io.h b/disk-io.h
index ca6af2d..941a3da 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -32,6 +32,7 @@ enum btrfs_open_ctree_flags {
 	OPEN_CTREE_RECOVER_SUPER	= 8,
 	OPEN_CTREE_RESTORE		= 16,
 	OPEN_CTREE_NO_BLOCK_GROUPS	= 32,
+	OPEN_CTREE_EXCLUSIVE		= 64,
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

