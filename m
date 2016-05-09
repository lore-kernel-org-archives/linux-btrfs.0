Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:42727 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbcEIHUr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 03:20:47 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id BDB4FAC00CD
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 16:20:39 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: prop: convert error messages to use error()
Message-ID: <57303A21.9070308@jp.fujitsu.com>
Date: Mon, 9 May 2016 16:20:01 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

props.c uses 'fprintf(stderr, "ERROR: ...")' as its error messages,
however we have generic error() function.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 props.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/props.c b/props.c
index 5b74932..5b4e26e 100644
--- a/props.c
+++ b/props.c
@@ -48,7 +48,7 @@ static int prop_read_only(enum prop_object_type type,
 	fd = open(object, O_RDONLY);
 	if (fd < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: open %s failed. %s\n",
+		error("open %s failed. %s",
 				object, strerror(-ret));
 		goto out;
 	}
@@ -56,7 +56,7 @@ static int prop_read_only(enum prop_object_type type,
 	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
 	if (ret < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: failed to get flags for %s. %s\n",
+		error("failed to get flags for %s. %s",
 				object, strerror(-ret));
 		goto out;
 	}
@@ -76,14 +76,14 @@ static int prop_read_only(enum prop_object_type type,
 		flags = flags & ~BTRFS_SUBVOL_RDONLY;
 	} else {
 		ret = -EINVAL;
-		fprintf(stderr, "ERROR: invalid value for property.\n");
+		error("invalid value for property.");
 		goto out;
 	}

 	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &flags);
 	if (ret < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: failed to set flags for %s. %s\n",
+		error("failed to set flags for %s. %s",
 				object, strerror(-ret));
 		goto out;
 	}
@@ -130,8 +130,7 @@ static int prop_compression(enum prop_object_type type,
 	fd = open_file_or_dir3(object, &dirstream, open_flags);
 	if (fd == -1) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: open %s failed. %s\n",
-			object, strerror(-ret));
+		error("open %s failed. %s", object, strerror(-ret));
 		goto out;
 	}

@@ -151,9 +150,8 @@ static int prop_compression(enum prop_object_type type,
 	if (sret < 0) {
 		ret = -errno;
 		if (ret != -ENOATTR)
-			fprintf(stderr,
-				"ERROR: failed to %s compression for %s. %s\n",
-				value ? "set" : "get", object, strerror(-ret));
+			error("failed to %s compression for %s. %s",
+			      value ? "set" : "get", object, strerror(-ret));
 		else
 			ret = 0;
 		goto out;
@@ -169,9 +167,8 @@ static int prop_compression(enum prop_object_type type,
 		sret = fgetxattr(fd, xattr_name, buf, len);
 		if (sret < 0) {
 			ret = -errno;
-			fprintf(stderr,
-				"ERROR: failed to get compression for %s. %s\n",
-				object, strerror(-ret));
+			error("failed to get compression for %s. %s",
+			      object, strerror(-ret));
 			goto out;
 		}
 		fprintf(stdout, "compression=%.*s\n", (int)len, buf);
-- 
2.5.5
