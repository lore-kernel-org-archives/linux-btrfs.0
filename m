Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62719 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3KLNmO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 08:42:14 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so2014661wgg.28
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 05:42:13 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/5] Btrfs-progs: fix detection of root objects in cmds-property.c
Date: Tue, 12 Nov 2013 13:41:44 +0000
Message-Id: <1384263706-25549-4-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several fixes:

1) The function check_is_root() returns 0 if the object is root;

2) Don't treat any error from get fsid ioctl as meaning the target
   is root. Only -ENOTTY means it's a root (parent directory is
   not a btrfs fs) and a -ENOTDIR means our target object is not a
   directory, therefore it can be the root;

3) Fix the comparison of the target and target's parent fs ids. If
   they are different, it means the target is a mount point in a
   btrfs fs, therefore it's a root, otherwise it isn't.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-property.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 6699e61..3d1f18c 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -75,7 +75,7 @@ static int parse_prop(const char *arg, const struct prop_handler *props,
 	return -1;
 }
 
-static int get_fsid(const char *path, u8 *fsid)
+static int get_fsid(const char *path, u8 *fsid, int silent)
 {
 	int ret;
 	int fd;
@@ -84,7 +84,8 @@ static int get_fsid(const char *path, u8 *fsid)
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: open %s failed. %s\n", path,
+		if (!silent)
+			fprintf(stderr, "ERROR: open %s failed. %s\n", path,
 				strerror(-ret));
 		goto out;
 	}
@@ -109,7 +110,7 @@ static int check_btrfs_object(const char *object)
 	int ret;
 	u8 fsid[BTRFS_FSID_SIZE];
 
-	ret = get_fsid(object, fsid);
+	ret = get_fsid(object, fsid, 0);
 	if (ret < 0)
 		ret = 0;
 	else
@@ -134,20 +135,27 @@ static int check_is_root(const char *object)
 		strcat(tmp, "/");
 	strcat(tmp, "..");
 
-	ret = get_fsid(object, fsid);
+	ret = get_fsid(object, fsid, 0);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", object,
 				strerror(-ret));
 		goto out;
 	}
 
-	ret = get_fsid(tmp, fsid2);
-	if (ret < 0) {
+	ret = get_fsid(tmp, fsid2, 1);
+	if (ret == -ENOTTY) {
 		ret = 0;
 		goto out;
+	} else if (ret == -ENOTDIR) {
+		ret = 1;
+		goto out;
+	} else if (ret < 0) {
+		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", tmp,
+			strerror(-ret));
+		goto out;
 	}
 
-	if (!memcmp(fsid, fsid2, BTRFS_FSID_SIZE)) {
+	if (memcmp(fsid, fsid2, BTRFS_FSID_SIZE)) {
 		ret = 0;
 		goto out;
 	}
@@ -195,7 +203,7 @@ static int autodetect_object_types(const char *object, int *types_out)
 		ret = check_is_root(object);
 		if (ret < 0)
 			goto out;
-		if (ret)
+		if (!ret)
 			types |= prop_object_root;
 	}
 
-- 
1.7.9.5

