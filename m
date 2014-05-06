Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20016 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934010AbaEFGcZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 02:32:25 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s466WLhK025172
	for <linux-btrfs@vger.kernel.org>; Tue, 6 May 2014 14:32:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 2/2] btrfs-progs: Add userspace support for kernel missing dev detection.
Date: Tue, 6 May 2014 14:33:25 +0800
Message-ID: <1399358005-9780-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1399358005-9780-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1399358005-9780-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add userspace support for kernel missing dev detection from dev_info
ioctl.

Now 'btrfs fi show' will auto detect the output format of dev_info ioctl
and use kernel missing dev detection if supported.
Also userspace missing dev detection is used as a fallback method and
when used, a info message will be printed showing 'btrfs dev del missing'
will not work.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c | 29 ++++++++++++++++++++++-------
 utils.c           |  2 ++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 306f715..0ff1ca6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -369,6 +369,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
 	int ret;
+	int new_flag = 0;
 
 	ret = add_seen_fsid(fs_info->fsid);
 	if (ret == -EEXIST)
@@ -389,13 +390,22 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	for (i = 0; i < fs_info->num_devices; i++) {
 		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
 
-		/* Add check for missing devices even mounted */
-		fd = open((char *)tmp_dev_info->path, O_RDONLY);
-		if (fd < 0) {
-			missing = 1;
-			continue;
+		new_flag = tmp_dev_info->flags & BTRFS_IOCTL_DEV_INFO_FLAG_SET;
+		if (!new_flag) {
+			/* Add check for missing devices even mounted */
+			fd = open((char *)tmp_dev_info->path, O_RDONLY);
+			if (fd < 0) {
+				missing = 1;
+				continue;
+			}
+			close(fd);
+		} else {
+			if (tmp_dev_info->flags &
+			    BTRFS_IOCTL_DEV_INFO_MISSING) {
+				missing = 1;
+				continue;
+			}
 		}
-		close(fd);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 			tmp_dev_info->devid,
 			pretty_size(tmp_dev_info->total_bytes),
@@ -403,8 +413,13 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 			tmp_dev_info->path);
 	}
 
-	if (missing)
+	if (missing) {
 		printf("\t*** Some devices missing\n");
+		if (!new_flag) {
+			printf("\tOlder kernel detected\n");
+			printf("\t'btrfs dev delete missing' may not work\n");
+		}
+	}
 	printf("\n");
 	return 0;
 }
diff --git a/utils.c b/utils.c
index 3e9c527..230471f 100644
--- a/utils.c
+++ b/utils.c
@@ -1670,6 +1670,8 @@ int get_device_info(int fd, u64 devid,
 
 	di_args->devid = devid;
 	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
+	/* Clear flags to ensure old kernel returns untouched flags */
+	memset(&di_args->flags, 0, sizeof(di_args->flags));
 
 	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
 	return ret ? -errno : 0;
-- 
1.9.2

