Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43990 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3BNCxh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 21:53:37 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id CDCD73EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 11:53:35 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id B544D45DE58
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 11:53:35 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id A028145DE55
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 11:53:35 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 8E5691DB8049
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 11:53:35 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3D5A11DB8043
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 11:53:35 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 0AF2A9F7C38
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 11:53:35 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.82])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id CC6E19F7BF8
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 11:53:33 +0900 (JST)
Message-Id: <201302140253.AA00020@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 14 Feb 2013 11:53:11 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs-progs: check out if the swap device
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the following commands succeed.

 # cat /proc/swaps
 Filename                                Type            Size    Used    Priority
 /dev/sda3                               partition       8388604 0       -1
 /dev/sdc8                               partition       9765884 0       -2
 # mkfs.btrfs /dev/sdc8
 
 WARNING! - Btrfs v0.20-rc1-165-g82ac345 IS EXPERIMENTAL
 WARNING! - see http://btrfs.wiki.kernel.org before using
 
 fs created label (null) on /dev/sdc8
         nodesize 4096 leafsize 4096 sectorsize 4096 size 9.31GB
 Btrfs v0.20-rc1-165-g82ac345
 # btrfs fi sh /dev/sdc8
 Label: none  uuid: fc0bdbd0-7eed-460f-b4e9-131273b66df2
         Total devices 1 FS bytes used 28.00KB
         devid    1 size 9.31GB used 989.62MB path /dev/sdc8
 
 Btrfs v0.20-rc1-165-g82ac345
 #

But we should check out the swap device. Fixed it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
(this patch is based on Chris's raid56-experimental branch)
v1 -> v2:
	- O_EXCL is specified at open(), as a last safety check
	- check when the swap device is a file is added
	- translate '\nnn'(octal) to character
	Thank you Eric, David, Zach and others.
---
 mkfs.c  | 30 ++++++++++++++++++++++----
 utils.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  1 +
 3 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2d3c2af..e981517 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1366,6 +1366,16 @@ int main(int ac, char **av)
 
 	if (source_dir == 0) {
 		file = av[optind++];
+		ret = is_swap_device(file);
+		if (ret < 0) {
+			fprintf(stderr, "error checking %s status: %s\n", file,
+				strerror(-ret));
+			exit(1);
+		}
+		if (ret == 1) {
+			fprintf(stderr, "%s is a swap device\n", file);
+			exit(1);
+		}
 		ret = check_mounted(file);
 		if (ret < 0) {
 			fprintf(stderr, "error checking %s mount status\n", file);
@@ -1376,9 +1386,10 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		ac--;
-		fd = open(file, O_RDWR);
+		fd = open(file, O_RDWR|O_EXCL);
 		if (fd < 0) {
-			fprintf(stderr, "unable to open %s\n", file);
+			fprintf(stderr, "unable to open %s: %s\n", file,
+				strerror(errno));
 			exit(1);
 		}
 		first_file = file;
@@ -1461,6 +1472,16 @@ int main(int ac, char **av)
 		int old_mixed = mixed;
 
 		file = av[optind++];
+		ret = is_swap_device(file);
+		if (ret < 0) {
+			fprintf(stderr, "error checking %s status: %s\n", file,
+				strerror(-ret));
+			exit(1);
+		}
+		if (ret == 1) {
+			fprintf(stderr, "%s is a swap device\n", file);
+			exit(1);
+		}
 		ret = check_mounted(file);
 		if (ret < 0) {
 			fprintf(stderr, "error checking %s mount status\n",
@@ -1471,9 +1492,10 @@ int main(int ac, char **av)
 			fprintf(stderr, "%s is mounted\n", file);
 			exit(1);
 		}
-		fd = open(file, O_RDWR);
+		fd = open(file, O_RDWR|O_EXCL);
 		if (fd < 0) {
-			fprintf(stderr, "unable to open %s\n", file);
+			fprintf(stderr, "unable to open %s: %s\n", file,
+				strerror(errno));
 			exit(1);
 		}
 		ret = btrfs_device_already_in_root(root, fd,
diff --git a/utils.c b/utils.c
index f9ee812..891edcc 100644
--- a/utils.c
+++ b/utils.c
@@ -1386,3 +1386,78 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 
 	return 0;
 }
+
+#define isoctal(c)	(((c) & ~7) == '0')
+
+static inline void translate(char *f, char *t)
+{
+	while (*f != '\0') {
+		if (*f == '\\' &&
+		    isoctal(f[1]) && isoctal(f[2]) && isoctal(f[3])) {
+			*t++ = 64*(f[1] & 7) + 8*(f[2] & 7) + (f[3] & 7);
+			f += 4;
+		} else
+			*t++ = *f++;
+	}
+	*t = '\0';
+	return;
+}
+
+/*
+ * Checks if the swap device.
+ * Returns 1 if swap device, < 0 on error or 0 if not swap device.
+ */
+int is_swap_device(const char *file)
+{
+	FILE	*f;
+	struct stat	st_buf;
+	dev_t	dev;
+	ino_t	ino = 0;
+	char	tmp[PATH_MAX];
+	char	buf[PATH_MAX];
+	char	*cp;
+	int	ret = 0;
+
+	if (stat(file, &st_buf) < 0)
+		return -errno;
+	if (S_ISBLK(st_buf.st_mode))
+		dev = st_buf.st_rdev;
+	else if (S_ISREG(st_buf.st_mode)) {
+		dev = st_buf.st_dev;
+		ino = st_buf.st_ino;
+	} else
+		return 0;
+
+	if ((f = fopen("/proc/swaps", "r")) == NULL)
+		return 0;
+
+	/* skip the first line */
+	if (fgets(tmp, sizeof(tmp), f) == NULL)
+		goto out;
+
+	while (fgets(tmp, sizeof(tmp), f) != NULL) {
+		if ((cp = strchr(tmp, ' ')) != NULL)
+			*cp = '\0';
+		if ((cp = strchr(tmp, '\t')) != NULL)
+			*cp = '\0';
+		translate(tmp, buf);
+		if (stat(buf, &st_buf) != 0)
+			continue;
+		if (S_ISBLK(st_buf.st_mode)) {
+			if (dev == st_buf.st_rdev) {
+				ret = 1;
+				break;
+			}
+		} else if (S_ISREG(st_buf.st_mode)) {
+			if (dev == st_buf.st_dev && ino == st_buf.st_ino) {
+				ret = 1;
+				break;
+			}
+		}
+	}
+
+out:
+	fclose(f);
+
+	return ret;
+}
diff --git a/utils.h b/utils.h
index bbcaf6a..60a0fea 100644
--- a/utils.h
+++ b/utils.h
@@ -55,6 +55,7 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
+int is_swap_device(const char *file);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 

