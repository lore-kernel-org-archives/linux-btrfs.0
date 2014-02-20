Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaBTCqs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 21:46:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K2kfHg012838
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 10:46:43 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/4] Btrfs-progs: new helper to parse string to u64 for btrfs
Date: Thu, 20 Feb 2014 10:29:51 +0800
Message-Id: <1392863391-20492-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
Changelog v2->v3:
        1.make output more clear addressed by Eric.
	2.use a more nature way to check whether we have passed a
	  valid numeric value.(pointed by Christian Robert!)

The next three patches can be applied cleanly, so i don't resend them.
---
 utils.c | 34 ++++++++++++++++++++++++++++++++++
 utils.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/utils.c b/utils.c
index 97e23d5..31092b3 100644
--- a/utils.c
+++ b/utils.c
@@ -1520,6 +1520,40 @@ scan_again:
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
+
+	/*
+	 * if we pass a negative number to strtoull,
+	 * it will return an unexpected number to us,
+	 * so let's do the check ourselves firstly.
+	 */
+	if (str[0] == '-') {
+		fprintf(stderr, "ERROR: %s: negative value is invalid.\n",
+			str);
+		exit(1);
+	}
+
+	value = strtoull(str, &ptr_parse_end, 0);
+	if (ptr_parse_end && *ptr_parse_end != '\0') {
+		fprintf(stderr, "ERROR: %s is not a valid numeric value.\n",
+			str);
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

