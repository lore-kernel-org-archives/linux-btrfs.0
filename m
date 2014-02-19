Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaBSLTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 06:19:41 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1JBJZI7025819
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 19:19:35 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] Btrfs-progs: new helper to parse string to u64 for btrfs
Date: Wed, 19 Feb 2014 19:17:51 +0800
Message-Id: <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many places that need parse string to u64 for btrfs commands,
in fact, we do such things *too casually*, using atoi/atol/atoll..is not
right at all, and even we don't check whether it is a valid string.

Let's do everything more gracefully, we introduce a new helper
btrfs_strtoull() which will do all the necessary checks.If we fail to
parse string to u64, we will output message and exit directly, this is
something like what usage() is doing. It is ok to not return erro to
it's caller, because this function should be called when parsing arg
(just like usage!)

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c | 19 +++++++++++++++++++
 utils.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/utils.c b/utils.c
index 97e23d5..0698d8d 100644
--- a/utils.c
+++ b/utils.c
@@ -1520,6 +1520,25 @@ scan_again:
 	return 0;
 }
 
+u64 btrfs_strtoull(char *str, int base)
+{
+	u64 value;
+	char *ptr_parse_end = NULL;
+	char *ptr_str_end = str + strlen(str);
+
+	value = strtoull(str, &ptr_parse_end, base);
+	if (ptr_parse_end != ptr_str_end) {
+		fprintf(stderr, "ERROR: %s is not an invalid unsigned long long integer.\n",
+				str);
+		exit(1);
+	}
+	if (value == ULONG_MAX) {
+		fprintf(stderr, "ERROR: %s is out of range.\n", str);
+		exit(1);
+	}
+	return value;
+}
+
 u64 parse_size(char *s)
 {
 	int i;
diff --git a/utils.h b/utils.h
index 04b8c45..094f41d 100644
--- a/utils.h
+++ b/utils.h
@@ -71,6 +71,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
+u64 btrfs_strtoull(char *str, int base);
 int open_file_or_dir(const char *fname, DIR **dirstream);
 void close_file_or_dir(int fd, DIR *dirstream);
 int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
-- 
1.8.3.1

