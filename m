Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaJOIjn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 04:39:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/1] btrfs-progs: introduce a proper structure on which cli will call register-device ioctl
Date: Wed, 15 Oct 2014 08:46:14 +0800
Message-Id: <1413333974-25579-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now commands mentioned below (with in [..]) are calling call register-device
ioctl BTRFS_IOC_SCAN_DEV for all the devices in the system.
Some issues with it:
 BTRFS_IOC_SCAN_DEV: ioctl is a write operation, we don't want command like
 btrfs-debug-tree threads to do that..
   eg:
   ----
   $ cat /proc/fs/btrfs/devlist  | egrep fsid | wc -l
   0
   $ btrfs-debug-tree /dev/sde  (num_device > 1)
   $ cat /proc/fs/btrfs/devlist  | egrep fsid | wc -l
   5
   ----

 btrfs_scan_fs_devices() ends up calling this ioctl only when num_device > 1.
 That's inconsistency with in feature/bug.

 We don't have to register _all_ the btrfs devices (again) in the system
 without user consent.

Why its inconsistent:
 function btrfs_scan_fs_devices() calls btrfs_scan_lblkid only when
 num_devices is > 1, which in turn calls BTRFS_IOC_SCAN_DEV ioctl, if
 conditions are met.

 But main issue is we have too many consumers of btrfs_scan_fs_devices()
 the names below with in [] is the cli leading to this function.

 open_ctree_broken()  [btrfs-find-root]
 recover_prepare()    [btrfs rescue super-recover]
 __open_ctree_fd
 (updates always except when flag OPEN_CTREE_RECOVER_SUPER is set and
 flag OPEN_CTREE_RECOVER_SUPER is set only by 'btrfs rescue super-
 recover' but still this thread sneaks through the open_ctree function
 to call register-device-ioctl as show below).
	open_ctree_fs_info
		[btrfs-debug-tree]
		[btrfs-image -r]
		[btrfs check]
		open_fs
			[btrfs restore]
		open_ctree
			[calc-size]
			[btrfs-corrupt-block]
			[btrfs-image] (create)
			[btrfs-map-logical]
			[btrfs-select-super]
			[btrfstune]
			[btrfs-zero-log]
			[tester]
			[mkfs]
			[quick-test.c]
			[btrfs label set unmounted]
			[btrfs get label unmounted]
			[btrfs rescue super-recover]

	open_ctree_fd
		[btrfs-convert]

Fix:
 In an effort to make register-device consistent, all calls to
 btrfs_scan_fs_devices() will have 5th parameter set to 0. that means
 we don't need 5th parameter at all. And with this function not calling
 the register ioctl at all, finally we will have following two cli to call
 the ioctl BTRFS_IOC_SCAN_DEV.
    btrfs dev scan and
    mkfs.btrfs
 Threads needing to update kernel about a device would have to use
 btrfs_register_one_device() separately.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-find-root.c | 2 +-
 chunk-recover.c   | 2 +-
 disk-io.c         | 5 ++---
 disk-io.h         | 2 +-
 super-recover.c   | 2 +-
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 6fe4b7b..caf21ce 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -82,7 +82,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 		return NULL;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1, 1);
+	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1);
 	if (ret)
 		goto out;
 
diff --git a/chunk-recover.c b/chunk-recover.c
index b4c62a8..7bae4f9 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1372,7 +1372,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto fail_free_sb;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1, 1);
+	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1);
 	if (ret)
 		goto fail_free_sb;
 
diff --git a/disk-io.c b/disk-io.c
index f9dbc85..7ef5ac4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -994,7 +994,7 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices,
-			  u64 sb_bytenr, int run_ioctl, int super_recover)
+			  u64 sb_bytenr, int super_recover)
 {
 	u64 total_devs;
 	int ret;
@@ -1013,7 +1013,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_lblkid(run_ioctl);
+		ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
 		if (ret)
 			return ret;
 	}
@@ -1094,7 +1094,6 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fs_info->on_restoring = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
-				    !(flags & OPEN_CTREE_RECOVER_SUPER),
 				    (flags & OPEN_CTREE_RECOVER_SUPER));
 	if (ret)
 		goto out;
diff --git a/disk-io.h b/disk-io.h
index c296055..4818109 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -68,7 +68,7 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr,
-			  int run_ioctl, int super_recover);
+			  int super_recover);
 int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
diff --git a/super-recover.c b/super-recover.c
index 419b86a..adb2c44 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -282,7 +282,7 @@ int btrfs_recover_superblocks(const char *dname,
 	}
 	init_recover_superblock(&recover);
 
-	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 0, 1);
+	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 1);
 	close(fd);
 	if (ret) {
 		ret = 1;
-- 
2.0.0.153.g79dcccc

