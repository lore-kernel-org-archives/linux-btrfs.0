Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37967 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeAZSlh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:37 -0500
Received: by mail-pg0-f66.google.com with SMTP id y27so790192pgc.5
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:37 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 15/26] btrfs-progs: use libbtrfsutil for read-only property
Date: Fri, 26 Jan 2018 10:41:03 -0800
Message-Id: <68d46bceaaa3f6e7310f7672d50d5875c92bf9ea.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 props.c | 69 ++++++++++++++++++++++++-----------------------------------------
 1 file changed, 25 insertions(+), 44 deletions(-)

diff --git a/props.c b/props.c
index cddbd927..e4edba06 100644
--- a/props.c
+++ b/props.c
@@ -21,6 +21,8 @@
 #include <fcntl.h>
 #include <unistd.h>
 
+#include <btrfsutil.h>
+
 #include "ctree.h"
 #include "commands.h"
 #include "utils.h"
@@ -41,56 +43,35 @@ static int prop_read_only(enum prop_object_type type,
 			  const char *name,
 			  const char *value)
 {
-	int ret = 0;
-	int fd = -1;
-	u64 flags = 0;
-
-	fd = open(object, O_RDONLY);
-	if (fd < 0) {
-		ret = -errno;
-		error("failed to open %s: %s", object, strerror(-ret));
-		goto out;
-	}
+	enum btrfs_util_error err;
+	bool read_only;
 
-	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
-	if (ret < 0) {
-		ret = -errno;
-		error("failed to get flags for %s: %s", object,
-				strerror(-ret));
-		goto out;
-	}
-
-	if (!value) {
-		if (flags & BTRFS_SUBVOL_RDONLY)
-			fprintf(stdout, "ro=true\n");
-		else
-			fprintf(stdout, "ro=false\n");
-		ret = 0;
-		goto out;
-	}
+	if (value) {
+		if (!strcmp(value, "true")) {
+			read_only = true;
+		} else if (!strcmp(value, "false")) {
+			read_only = false;
+		} else {
+			error("invalid value for property: %s", value);
+			return -EINVAL;
+		}
 
-	if (!strcmp(value, "true")) {
-		flags |= BTRFS_SUBVOL_RDONLY;
-	} else if (!strcmp(value, "false")) {
-		flags = flags & ~BTRFS_SUBVOL_RDONLY;
+		err = btrfs_util_set_subvolume_read_only(object, read_only);
+		if (err) {
+			error_btrfs_util(err);
+			return -errno;
+		}
 	} else {
-		ret = -EINVAL;
-		error("invalid value for property: %s", value);
-		goto out;
-	}
+		err = btrfs_util_get_subvolume_read_only(object, &read_only);
+		if (err) {
+			error_btrfs_util(err);
+			return -errno;
+		}
 
-	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &flags);
-	if (ret < 0) {
-		ret = -errno;
-		error("failed to set flags for %s: %s", object,
-				strerror(-ret));
-		goto out;
+		printf("ro=%s\n", read_only ? "true" : "false");
 	}
 
-out:
-	if (fd != -1)
-		close(fd);
-	return ret;
+	return 0;
 }
 
 static int prop_label(enum prop_object_type type,
-- 
2.16.1

