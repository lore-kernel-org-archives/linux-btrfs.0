Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752266AbbJLNYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:52 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOL0f026206
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:21 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 07/11] btrfs-progs: qgroup: use btrfs_open_dir for btrfs qgroup command
Date: Mon, 12 Oct 2015 21:23:00 +0800
Message-ID: <2b77db10ce6818718b4877df8f8ca04ba11760bc.1444655800.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
References: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can use btrfs_open_dir() to check whether target dir is
in btrfs's mount point before open, instead of checking it in
kernel space of ioctl, and return fuzzy error message.

Before patch:
  # ./btrfs qgroup create 1/5  /mnt/tmp1
  ERROR: unable to create quota group: Inappropriate ioctl for device
  #
  # ./btrfs qgroup assign 1/5 2/5 /mnt/tmp1
  ERROR: unable to assign quota group: Inappropriate ioctl for device
  #
  # ./btrfs qgroup show /mnt/tmp1
  ERROR: can't perform the search - Inappropriate ioctl for device
  ERROR: can't list qgroups: Inappropriate ioctl for device
  #
  # ./btrfs qgroup limit 1G 1/5  /mnt/tmp1
  ERROR: unable to limit requested quota group: Inappropriate ioctl for device

After patch:
  # ./btrfs qgroup create 1/5 /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs qgroup assign 1/5 2/5 /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs qgroup show /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs qgroup limit 1G 1/5 /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-qgroup.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 48c1733..0ad99f4 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -79,11 +79,9 @@ static int qgroup_assign(int assign, int argc, char **argv)
 		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
 		return 1;
 	}
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
 	e = errno;
@@ -137,11 +135,9 @@ static int qgroup_create(int create, int argc, char **argv)
 	args.create = create;
 	args.qgroupid = parse_qgroupid(argv[1]);
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_CREATE, &args);
 	e = errno;
@@ -351,11 +347,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 		usage(cmd_qgroup_show_usage);
 
 	path = argv[optind];
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	if (filter_flag) {
 		qgroupid = btrfs_get_path_rootid(fd);
@@ -460,11 +454,9 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	} else
 		usage(cmd_qgroup_limit_usage);
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_LIMIT, &args);
 	e = errno;
-- 
1.8.5.1

