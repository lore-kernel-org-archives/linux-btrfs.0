Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14787 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753723AbaKMBh7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 20:37:59 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAD1biIk026712
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 09:37:45 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: use canonical name for device in btrfs fi show when mounted
Date: Thu, 13 Nov 2014 09:36:20 +0800
Message-ID: <1415842580-2430-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using lvm volumes to check fstests: btrfs/006, it fails like:
     Label: 'TestLabel.006'  uuid: <UUID>
     	Total devices <EXACTNUM> FS bytes used <SIZE>
     	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
    +	devid <DEVID> size <SIZE> used <SIZE> path /dev/dm-4
    +	devid <DEVID> size <SIZE> used <SIZE> path /dev/dm-5
    +	devid <DEVID> size <SIZE> used <SIZE> path /dev/dm-6

The /dev/dm-* points to lvm volumes, use @canonicalize_path() to convert them
and we will make it through. Of course we should do the same thing for dev stat.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-device.c     | 16 +++++++++++-----
 cmds-filesystem.c |  7 ++++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 9323986..6cd41e1 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -408,31 +408,37 @@ static int cmd_dev_stats(int argc, char **argv)
 				path, strerror(errno));
 			err = 1;
 		} else {
+			char *canonical_path;
+
+			canonical_path = canonicalize_path((char *)path);
+
 			if (args.nr_items >= BTRFS_DEV_STAT_WRITE_ERRS + 1)
 				printf("[%s].write_io_errs   %llu\n",
-				       path,
+				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_WRITE_ERRS]);
 			if (args.nr_items >= BTRFS_DEV_STAT_READ_ERRS + 1)
 				printf("[%s].read_io_errs    %llu\n",
-				       path,
+				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_READ_ERRS]);
 			if (args.nr_items >= BTRFS_DEV_STAT_FLUSH_ERRS + 1)
 				printf("[%s].flush_io_errs   %llu\n",
-				       path,
+				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_FLUSH_ERRS]);
 			if (args.nr_items >= BTRFS_DEV_STAT_CORRUPTION_ERRS + 1)
 				printf("[%s].corruption_errs %llu\n",
-				       path,
+				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_CORRUPTION_ERRS]);
 			if (args.nr_items >= BTRFS_DEV_STAT_GENERATION_ERRS + 1)
 				printf("[%s].generation_errs %llu\n",
-				       path,
+				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_GENERATION_ERRS]);
+
+			free(canonical_path);
 		}
 	}
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index e4b2785..cd6b3c6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -510,7 +510,10 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 			pretty_size(calc_used_bytes(space_info)));
 
 	for (i = 0; i < fs_info->num_devices; i++) {
+		char *canonical_path;
+
 		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
+		canonical_path = canonicalize_path((char *)tmp_dev_info->path);
 
 		/* Add check for missing devices even mounted */
 		fd = open((char *)tmp_dev_info->path, O_RDONLY);
@@ -523,7 +526,9 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 			tmp_dev_info->devid,
 			pretty_size(tmp_dev_info->total_bytes),
 			pretty_size(tmp_dev_info->bytes_used),
-			tmp_dev_info->path);
+			canonical_path);
+
+		free(canonical_path);
 	}
 
 	if (missing)
-- 
1.8.1.4

