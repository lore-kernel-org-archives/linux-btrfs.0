Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65523 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaHNLk5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 07:40:57 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so1492286pab.29
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 04:40:57 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: canonicalize dm device name before update kernel
Date: Thu, 14 Aug 2014 19:40:20 +0800
Message-Id: <1408016420-29221-2-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1408016420-29221-1-git-send-email-guaneryu@gmail.com>
References: <1408016420-29221-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A btrfsck or btrfs device scan -d operation could change the device
name of other mounted btrfs in kernel, if the other btrfs is on lvm
device.

Assume that we have two btrfs filesystems, kernel is 3.16.0-rc4+

[root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
        Total devices 1 FS bytes used 384.00KiB
        devid    1 size 15.00GiB used 2.04GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv1

Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
        Total devices 2 FS bytes used 112.00KiB
        devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
        devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3

Btrfs v3.14.2

And testlv1 was mounted at /mnt/btrfs

[root@hp-dl388eg8-01 btrfs-progs]# df -TP /mnt/btrfs
Filesystem                                Type  1024-blocks  Used Available Capacity Mounted on
/dev/mapper/rhel_hp--dl388eg8--01-testlv1 btrfs    15728640   512  13602560       1% /mnt/btrfs

Now run btrfsck on testlv2 or btrfs device scan -d, which will scan
all btrfs devices and somehow change the device name.

[root@hp-dl388eg8-01 btrfs-progs]# btrfsck /dev/mapper/rhel_hp--dl388eg8--01-testlv2 >/dev/null 2>&1

[root@hp-dl388eg8-01 btrfs-progs]# df -TP /mnt/btrfs
Filesystem     Type  1024-blocks  Used Available Capacity Mounted on
/dev/dm-3      btrfs    15728640   512  13602560       1% /mnt/btrfs
[root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
        Total devices 1 FS bytes used 384.00KiB
        devid    1 size 15.00GiB used 2.04GiB path /dev/dm-3

Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
        Total devices 2 FS bytes used 112.00KiB
        devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
        devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3

Btrfs v3.14.2

Now calling btrfs_register_one_device with canonicalized dm device name.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

With patch 1 applied, btrfsck won't change the device name,
but btrfs device scan -d still does.

 utils.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index f54e749..3567094 100644
--- a/utils.c
+++ b/utils.c
@@ -985,6 +985,32 @@ static int blk_file_in_dev_list(struct btrfs_fs_devices* fs_devices,
 }
 
 /*
+ * Convert dm-N device name to /dev/mapper/name
+ */
+static void canonicalize_dm_name(char *devnode, char *path, int len)
+{
+	char *buf = NULL;
+	FILE *sysfsp = NULL;
+
+	buf = malloc(PATH_MAX);
+	if (!buf)
+		return;
+
+	snprintf(buf, PATH_MAX, "/sys/block/%s/dm/name", devnode);
+	sysfsp = fopen(buf, "r");
+	if (!sysfsp)
+		goto out;
+
+	if (fgets(buf, PATH_MAX, sysfsp)) {
+		buf[strlen(buf) - 1] = '\0';
+		snprintf(path, len - 1, "/dev/mapper/%s", buf);
+	}
+	fclose(sysfsp);
+out:
+	free(buf);
+}
+
+/*
  * returns 1 if the device was mounted, < 0 on error or 0 if everything
  * is safe to continue.
  */
@@ -1189,6 +1215,9 @@ again:
 		if (fsid && memcmp(fsid, tmp_devices->fsid, BTRFS_FSID_SIZE))
 			continue;
 		if (run_ioctl > 0) {
+			if (!strncmp(fullpath, "/dev/dm-", strlen("/dev/dm-")))
+				canonicalize_dm_name(dirent->d_name,
+						     fullpath, PATH_MAX);
 			btrfs_register_one_device(fullpath);
 		}
 		close(fd);
@@ -1475,8 +1504,11 @@ int btrfs_scan_block_devices(u8 *fsid, int run_ioctl)
 	int i;
 	char buf[1024];
 	char fullpath[110];
+	char devnode[64];
+	char *dirname = "/dev/";
 	int scans = 0;
 	int special;
+	int is_dm;
 
 scan_again:
 	proc_partitions = fopen("/proc/partitions","r");
@@ -1493,9 +1525,11 @@ scan_again:
 			return -ENOENT;
 		}
 
-	strcpy(fullpath,"/dev/");
-	while(fgets(buf, 1023, proc_partitions)) {
-		i = sscanf(buf," %*d %*d %*d %99s", fullpath+5);
+	strcpy(fullpath, dirname);
+	while (fgets(buf, sizeof(buf) - 1, proc_partitions)) {
+		i = sscanf(buf, " %*d %*d %*d %99s", devnode);
+		strncpy(fullpath + strlen(dirname), devnode,
+			sizeof(fullpath) - strlen(dirname));
 
 		/*
 		 * multipath and MD devices may register as a btrfs filesystem
@@ -1504,6 +1538,7 @@ scan_again:
 		 * This scans the special entries last
 		 */
 		special = strncmp(fullpath, "/dev/dm-", strlen("/dev/dm-")) == 0;
+		is_dm = special;
 		if (!special)
 			special = strncmp(fullpath, "/dev/md", strlen("/dev/md")) == 0;
 
@@ -1538,6 +1573,9 @@ scan_again:
 		if (fsid && memcmp(fsid, tmp_devices->fsid, BTRFS_FSID_SIZE))
 			continue;
 		if (run_ioctl > 0) {
+			if (is_dm)
+				canonicalize_dm_name(devnode, fullpath,
+						     sizeof(fullpath));
 			btrfs_register_one_device(fullpath);
 		}
 	}
-- 
1.8.3.1

