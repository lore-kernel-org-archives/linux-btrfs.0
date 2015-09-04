Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7682 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933089AbbIDNZ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:25:58 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DPkHZ030022
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:25:46 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/5] btrfs-progs: Introduce --extra-dev option
Date: Fri, 4 Sep 2015 21:24:15 +0800
Message-ID: <5ece0f3a4712a1ba0538e61bd4f45121da62a217.1441357933.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
References: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some command in current tools can't support filesystem with multiple
loop device, for example:
 # truncate -s 200M ./1.img
 # truncate -s 200M ./2.img
 # mkfs.btrfs -f ./1.img ./2.img
 #
 # btrfs rescue chunk-recover -v ./1.img
 All Devices:
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue super-recover -v ./1.img
 All Devices:
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue zero-log ./1.img
 warning devid 2 not found already
 Clearing log on ./1.img, previous log_root 0, level 0
 ...

As a workaround, we can bind all of above image files to loop device,
but to make things simple, this patch introduce --extra-dev option,
to specify non-block-device manually, as:
 # btrfs rescue chunk-recover -v --extra-device=./2.img ./1.img
 All Devices:
        Device: id = 2, name = ./2.img
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue super-recover --extra-dev=./2.img -v ./1.img
 All Devices:
        Device: id = 2, name = ./2.img
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue zero-log --extra-dev=./2.img ./1.img
 Clearing log on ./1.img, previous log_root 0, level 0

We can add multiple extra-dev by:
 --extra-dev="1.img,2.img"
 or
 --extra-dev=1.img --extra-dev=2.img

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  5 +++++
 2 files changed, 75 insertions(+)

diff --git a/utils.c b/utils.c
index 52791b5..ed1fb13 100644
--- a/utils.c
+++ b/utils.c
@@ -56,6 +56,8 @@ static int btrfs_scan_done = 0;
 
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
+char btrfs_extra_devs[1024][PATH_MAX];
+
 const char *get_argv0_buf(void)
 {
 	return argv0_buf;
@@ -2560,6 +2562,7 @@ int btrfs_scan_lblkid()
 	blkid_dev dev = NULL;
 	blkid_cache cache = NULL;
 	char path[PATH_MAX];
+	int i;
 
 	if (btrfs_scan_done)
 		return 0;
@@ -2596,6 +2599,29 @@ int btrfs_scan_lblkid()
 	blkid_dev_iterate_end(iter);
 	blkid_put_cache(cache);
 
+	for (i = 0; i < ARRAY_SIZE(btrfs_extra_devs); i++) {
+		if (btrfs_extra_devs[i][0] == 0)
+			break;
+
+		fd = open(btrfs_extra_devs[i], O_RDONLY);
+		if (fd < 0) {
+			printf("ERROR: could not open %s\n",
+			       btrfs_extra_devs[i]);
+			continue;
+		}
+		ret = btrfs_scan_one_device(fd, btrfs_extra_devs[i],
+					    &tmp_devices, &num_devices,
+					    BTRFS_SUPER_INFO_OFFSET, 0);
+		if (ret) {
+			printf("ERROR: could not scan %s\n",
+			       btrfs_extra_devs[i]);
+			close(fd);
+			continue;
+		}
+
+		close(fd);
+	}
+
 	btrfs_scan_done = 1;
 
 	return 0;
@@ -3069,3 +3095,47 @@ unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode)
 
 	return unit_mode;
 }
+
+int set_extra_dev_from_arg(int *argc, char *argv[])
+{
+	int arg_i;
+	int arg_end;
+	int extra_dev_cnt = 0;
+
+	static const char opt_head[] = "--extra-dev=";
+
+	for (arg_i = 1; arg_i < *argc; arg_i++) {
+		if (strncmp(argv[arg_i], opt_head, strlen(opt_head)))
+			continue;
+
+		char *val_begin = argv[arg_i] + strlen(opt_head);
+		char *val_end;
+
+		while (1) {
+			val_end = strchrnul(val_begin, ',');
+			if (val_end != val_begin) {
+				memcpy(btrfs_extra_devs[extra_dev_cnt],
+				       val_begin, val_end - val_begin);
+				btrfs_extra_devs[extra_dev_cnt]
+						[val_end - val_begin] = 0;
+				extra_dev_cnt++;
+			}
+			if (*val_end == 0)
+				break;
+			val_begin = val_end + 1;
+		}
+		argv[arg_i] = NULL;
+	}
+	btrfs_extra_devs[extra_dev_cnt][0] = 0;
+
+	for (arg_i = 0, arg_end = 0; arg_i < *argc; arg_i++) {
+		if (!argv[arg_i])
+			continue;
+		argv[arg_end] = argv[arg_i];
+		arg_end++;
+	}
+
+	*argc = arg_end;
+
+	return 0;
+}
diff --git a/utils.h b/utils.h
index dce0a47..4070a1f 100644
--- a/utils.h
+++ b/utils.h
@@ -269,4 +269,9 @@ const char *get_argv0_buf(void);
 
 unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
 
+#define HELPINFO_EXTRA_DEV \
+	"--extra-dev        set extra device to search"
+
+int set_extra_dev_from_arg(int *argc, char *argv[]);
+
 #endif
-- 
1.8.5.1

