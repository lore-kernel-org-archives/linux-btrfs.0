Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27523 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBTBcp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 20:32:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K1Wg0Y006794
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 09:32:43 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/4] Btrfs-progs: new helper to parse string to u64 for btrfs
Date: Thu, 20 Feb 2014 09:30:49 +0800
Message-Id: <1392859852-15829-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many places that need parse string to u64 for btrfs commands,
in fact, we do such things *too casually*, using atoi/atol/atoll..is not
right at all, and even we don't check whether it is a valid string.

Let's do everything more gracefully, we introduce a new helper
arg_strtou64() which will do all the necessary checks.If we fail to
parse string to u64, we will output message and exit directly, this is
something like what usage() is doing. It is ok to not return erro to
it's caller, because this function should be called when parsing arg
(just like usage!)

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c | 33 +++++++++++++++++++++++++++++++++
 utils.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/utils.c b/utils.c
index 97e23d5..d570967 100644
--- a/utils.c
+++ b/utils.c
@@ -1520,6 +1520,39 @@ scan_again:
 	return 0;
 }
 
+/*
+ * This function should be only used when parsing
+ * command arg, it won't return error to it's
+ * caller and rather exit directly just like usage().
+ */
+u64 arg_strtou64(const char *str)
+{
+	u64 value;
+	char *ptr_parse_end = NULL;
+	char *ptr_str_end = (char *)str + strlen(str);
+
+	/*
+	 * if we pass a negative number to strtoull,
+	 * it will return an unexpected number to us,
+	 * so let's do the check ourselves firstly.
+	 */
+	if (str[0] == '-') {
+		fprintf(stderr, "ERROR: %s may be negative value.\n", str);
+		exit(1);
+	}
+
+	value = strtoull(str, &ptr_parse_end, 0);
+	if (ptr_parse_end != ptr_str_end) {
+		fprintf(stderr, "ERROR: %s is not valid value.\n", str);
+		exit(1);
+	}
+	if (value == ULLONG_MAX) {
+		fprintf(stderr, "ERROR: %s is too large.\n", str);
+		exit(1);
+	}
+	return value;
+}
+
 u64 parse_size(char *s)
 {
 	int i;
diff --git a/utils.h b/utils.h
index 04b8c45..a201085 100644
--- a/utils.h
+++ b/utils.h
@@ -71,6 +71,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
+u64 arg_strtou64(const char *str);
 int open_file_or_dir(const char *fname, DIR **dirstream);
 void close_file_or_dir(int fd, DIR *dirstream);
 int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
-- 
1.8.3.1

