Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44646 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BLBZv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 20:25:51 -0500
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D6A833EE0BC
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 10:25:49 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id B842445DEBF
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 10:25:49 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 9582745DEB2
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 10:25:49 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 605DCE18002
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 10:25:49 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id EC8DE1DB803F
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 10:25:48 +0900 (JST)
Message-Id: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 12 Feb 2013 10:25:23 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs-progs: check out if the swap device
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

But we should check out the swap device. So fixed it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
(this patch is based on Chris's raid56-experimental branch)
---
 mkfs.c  | 18 ++++++++++++++++++
 utils.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  1 +
 3 files changed, 68 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index 2d3c2af..fdc3373 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1366,6 +1366,15 @@ int main(int ac, char **av)
 
 	if (source_dir == 0) {
 		file = av[optind++];
+		ret = is_swap_device(file);
+		if (ret < 0) {
+			fprintf(stderr, "error checking %s status\n", file);
+			exit(1);
+		}
+		if (ret == 1) {
+			fprintf(stderr, "%s is a swap device\n", file);
+			exit(1);
+		}
 		ret = check_mounted(file);
 		if (ret < 0) {
 			fprintf(stderr, "error checking %s mount status\n", file);
@@ -1461,6 +1470,15 @@ int main(int ac, char **av)
 		int old_mixed = mixed;
 
 		file = av[optind++];
+		ret = is_swap_device(file);
+		if (ret < 0) {
+			fprintf(stderr, "error checking %s status\n", file);
+			exit(1);
+		}
+		if (ret == 1) {
+			fprintf(stderr, "%s is a swap device\n", file);
+			exit(1);
+		}
 		ret = check_mounted(file);
 		if (ret < 0) {
 			fprintf(stderr, "error checking %s mount status\n",
diff --git a/utils.c b/utils.c
index f9ee812..0c551a0 100644
--- a/utils.c
+++ b/utils.c
@@ -1386,3 +1386,52 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 
 	return 0;
 }
+
+/*
+ * Checks if the swap device or not.
+ * Returns 1 if the swap device, < 0 on error or 0 if not the swap device.
+ */
+int is_swap_device(const char *file)
+{
+	FILE	*f;
+	struct stat	st_buf;
+	char	buf[1024];
+	char	*cp;
+	dev_t	rdev;
+	int	ret = 0;
+
+	if (stat(file, &st_buf) < 0)
+		return -errno;
+	if (!S_ISBLK(st_buf.st_mode))
+		return 0;
+
+	rdev = st_buf.st_rdev;
+
+	if ((f = fopen("/proc/swaps", "r")) == NULL)
+		return -errno;
+
+	/* skip the first line */
+	if (fgets(buf, sizeof(buf), f) == NULL)
+		goto out;
+
+	while (fgets(buf, sizeof(buf), f) != NULL) {
+		if ((cp = strchr(buf, ' ')) != NULL)
+			*cp = 0;
+		if ((cp = strchr(buf, '\t')) != NULL)
+			*cp = 0;
+		if (strcmp(file, buf) == 0) {
+			ret = 1;
+			break;
+		}
+		if ((stat(buf, &st_buf) == 0) && S_ISBLK(st_buf.st_mode) &&
+		    rdev == st_buf.st_rdev) {
+			ret = 1;
+			break;
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
 

