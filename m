Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaBGKfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 05:35:45 -0500
From: David Disseldorp <ddiss@suse.de>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH v3 2/3] src/cloner: use btrfs/ioctl.h header if present
Date: Fri,  7 Feb 2014 11:35:40 +0100
Message-Id: <1391769341-20688-3-git-send-email-ddiss@suse.de>
In-Reply-To: <1391769341-20688-1-git-send-email-ddiss@suse.de>
References: <1391769341-20688-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check for the btrfsprogs-devel ioctl.h header at configure time. Use it
in src/cloner if present, otherwise fall back to using the copied clone
ioctl definitions.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 configure.ac | 1 +
 src/cloner.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/configure.ac b/configure.ac
index bd48fd9..6fba3ad 100644
--- a/configure.ac
+++ b/configure.ac
@@ -30,6 +30,7 @@ AC_HEADER_STDC
     AC_CHECK_HEADERS([	sys/fs/xfs_fsops.h	\
 			sys/fs/xfs_itable.h	\
 			xfs/platform_defs.h	\
+			btrfs/ioctl.h		\
     ])
 
 AC_PACKAGE_NEED_UUIDCOMPARE
diff --git a/src/cloner.c b/src/cloner.c
index dfce837..ccc2354 100644
--- a/src/cloner.c
+++ b/src/cloner.c
@@ -30,6 +30,9 @@
 #include <stdio.h>
 #include <string.h>
 #include <errno.h>
+#ifdef HAVE_BTRFS_IOCTL_H
+#include <btrfs/ioctl.h>
+#else
 
 struct btrfs_ioctl_clone_range_args {
 	int64_t src_fd;
@@ -42,6 +45,7 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_CLONE       _IOW(BTRFS_IOCTL_MAGIC, 9, int)
 #define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
 				   struct btrfs_ioctl_clone_range_args)
+#endif
 
 static void
 usage(char *name, const char *msg)
-- 
1.8.4.5

