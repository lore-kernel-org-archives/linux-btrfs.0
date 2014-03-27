Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaC0CzP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 22:55:15 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2R2tBvn021461
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 10:55:11 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: add btrfs resize unit t/p/e support
Date: Thu, 27 Mar 2014 10:51:12 +0800
Message-Id: <1395888673-28433-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For Btrfs with 16E fs size support, resize by unit t/p/e is desired.
The request comes from redhat bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=1058608.

Originally,
	# btrfs resize -1T <path> 	: prompt 'invalid argument'
while,
	# btrfs resize -1024G <path>	: will work

We add t/p/e support by replacing lib/cmdline.c:memparse
with btrfs_memparse. The btrfs_memparse copies memparse's code
and add unit t/p/e parsing.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e174770..357b706 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1448,6 +1448,47 @@ out_ra:
 	return ret;
 }
 
+/*
+ * The memparse only supports k/m/g suffixes
+ * For Btrfs with 16E fs size support, t/p/e support is desired
+ * This function copies the memparse and adds t/p/e suffixes parsing
+ */
+static int btrfs_memparse(const char *ptr, u64 *retval)
+{
+	int ret = 0;
+	char *endptr;	/* local pointer to end of parsed string */
+
+	*retval = simple_strtoull(ptr, &endptr, 0);
+	if (*(endptr + 1) != '\0')
+		return -EINVAL;
+
+	switch (*endptr) {
+	case 'E':
+	case 'e':
+		*retval <<= 10;
+	case 'P':
+	case 'p':
+		*retval <<= 10;
+	case 'T':
+	case 't':
+		*retval <<= 10;
+	case 'G':
+	case 'g':
+		*retval <<= 10;
+	case 'M':
+	case 'm':
+		*retval <<= 10;
+	case 'K':
+	case 'k':
+		*retval <<= 10;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static noinline int btrfs_ioctl_resize(struct file *file,
 					void __user *arg)
 {
@@ -1526,8 +1567,8 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			mod = 1;
 			sizestr++;
 		}
-		new_size = memparse(sizestr, NULL);
-		if (new_size == 0) {
+		ret = btrfs_memparse(sizestr, &new_size);
+		if (ret < 0 || new_size == 0) {
 			ret = -EINVAL;
 			goto out_free;
 		}
-- 
1.8.1.4

