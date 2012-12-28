Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37535 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2L1DGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:06:52 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS36ppV010054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:52 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS36pXd005880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:51 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36oAx027225
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:50 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/8] Btrfs-progs: move open_file_or_dir() to utils.c
Date: Fri, 28 Dec 2012 11:12:55 +0800
Message-Id: <1356664382-24423-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

The definition of the function open_file_or_dir() is moved from common.c
to utils.c in order to be able to share some common code between scrub
and the device stats in the following step. That common code uses
open_file_or_dir(). Since open_file_or_dir() makes use of the function
dirfd(3), the required XOPEN version was raised from 6 to 7.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Original-Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 Makefile         |    4 ++--
 btrfsctl.c       |    7 ++++---
 cmds-balance.c   |    1 +
 cmds-inspect.c   |    1 +
 cmds-qgroup.c    |    1 +
 cmds-quota.c     |    1 +
 cmds-subvolume.c |    1 +
 commands.h       |    3 ---
 common.c         |   46 ----------------------------------------------
 utils.c          |   30 ++++++++++++++++++++++++++++--
 utils.h          |    3 +++
 11 files changed, 42 insertions(+), 56 deletions(-)
 delete mode 100644 common.c

diff --git a/Makefile b/Makefile
index 4894903..8576d90 100644
--- a/Makefile
+++ b/Makefile
@@ -41,8 +41,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
-	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
+btrfs: $(objects) btrfs.o help.o $(cmds_objects)
+	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
diff --git a/btrfsctl.c b/btrfsctl.c
index 518684c..049a5f3 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -63,7 +63,7 @@ static void print_usage(void)
 	exit(1);
 }
 
-static int open_file_or_dir(const char *fname)
+static int btrfsctl_open_file_or_dir(const char *fname)
 {
 	int ret;
 	struct stat st;
@@ -91,6 +91,7 @@ static int open_file_or_dir(const char *fname)
 	}
 	return fd;
 }
+
 int main(int ac, char **av)
 {
 	char *fname = NULL;
@@ -128,7 +129,7 @@ int main(int ac, char **av)
 			snap_location = strdup(fullpath);
 			snap_location = dirname(snap_location);
 
-			snap_fd = open_file_or_dir(snap_location);
+			snap_fd = btrfsctl_open_file_or_dir(snap_location);
 
 			name = strdup(fullpath);
 			name = basename(name);
@@ -238,7 +239,7 @@ int main(int ac, char **av)
 		}
 		name = fname;
 	 } else {
-		fd = open_file_or_dir(fname);
+		fd = btrfsctl_open_file_or_dir(fname);
 	 }
 
 	if (name) {
diff --git a/cmds-balance.c b/cmds-balance.c
index 38a7426..6268b61 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -28,6 +28,7 @@
 #include "volumes.h"
 
 #include "commands.h"
+#include "utils.h"
 
 static const char * const balance_cmd_group_usage[] = {
 	"btrfs [filesystem] balance <command> [options] <path>",
diff --git a/cmds-inspect.c b/cmds-inspect.c
index edabff5..79e069b 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -22,6 +22,7 @@
 
 #include "kerncompat.h"
 #include "ioctl.h"
+#include "utils.h"
 
 #include "commands.h"
 #include "btrfs-list.h"
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 1525c11..cafc284 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -24,6 +24,7 @@
 #include "ioctl.h"
 
 #include "commands.h"
+#include "utils.h"
 
 static const char * const qgroup_cmd_group_usage[] = {
 	"btrfs qgroup <command> [options] <path>",
diff --git a/cmds-quota.c b/cmds-quota.c
index cf9ad97..8481514 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -23,6 +23,7 @@
 #include "ioctl.h"
 
 #include "commands.h"
+#include "utils.h"
 
 static const char * const quota_cmd_group_usage[] = {
 	"btrfs quota <command> [options] <path>",
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ac39f7b..e3cdb1e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -32,6 +32,7 @@
 #include "ctree.h"
 #include "commands.h"
 #include "btrfs-list.h"
+#include "utils.h"
 
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
diff --git a/commands.h b/commands.h
index bb6d2dd..8114a73 100644
--- a/commands.h
+++ b/commands.h
@@ -79,9 +79,6 @@ void help_ambiguous_token(const char *arg, const struct cmd_group *grp);
 
 void help_command_group(const struct cmd_group *grp, int argc, char **argv);
 
-/* common.c */
-int open_file_or_dir(const char *fname);
-
 extern const struct cmd_group subvolume_cmd_group;
 extern const struct cmd_group filesystem_cmd_group;
 extern const struct cmd_group balance_cmd_group;
diff --git a/common.c b/common.c
deleted file mode 100644
index 03f6570..0000000
--- a/common.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <dirent.h>
-#include <fcntl.h>
-
-int open_file_or_dir(const char *fname)
-{
-	int ret;
-	struct stat st;
-	DIR *dirstream;
-	int fd;
-
-	ret = stat(fname, &st);
-	if (ret < 0) {
-		return -1;
-	}
-	if (S_ISDIR(st.st_mode)) {
-		dirstream = opendir(fname);
-		if (!dirstream) {
-			return -2;
-		}
-		fd = dirfd(dirstream);
-	} else {
-		fd = open(fname, O_RDWR);
-	}
-	if (fd < 0) {
-		return -3;
-	}
-	return fd;
-}
diff --git a/utils.c b/utils.c
index 205e667..774f81d 100644
--- a/utils.c
+++ b/utils.c
@@ -16,8 +16,9 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 600
-#define __USE_XOPEN2K
+#define _XOPEN_SOURCE 700
+#define __USE_XOPEN2K8
+#define __XOPEN2K8 /* due to an error in dirent.h, to get dirfd() */
 #include <stdio.h>
 #include <stdlib.h>
 #ifndef __CHECKER__
@@ -1220,3 +1221,28 @@ scan_again:
 	return 0;
 }
 
+int open_file_or_dir(const char *fname)
+{
+	int ret;
+	struct stat st;
+	DIR *dirstream;
+	int fd;
+
+	ret = stat(fname, &st);
+	if (ret < 0) {
+		return -1;
+	}
+	if (S_ISDIR(st.st_mode)) {
+		dirstream = opendir(fname);
+		if (!dirstream) {
+			return -2;
+		}
+		fd = dirfd(dirstream);
+	} else {
+		fd = open(fname, O_RDWR);
+	}
+	if (fd < 0) {
+		return -3;
+	}
+	return fd;
+}
diff --git a/utils.h b/utils.h
index 3a0368b..6975f10 100644
--- a/utils.h
+++ b/utils.h
@@ -19,6 +19,8 @@
 #ifndef __UTILS__
 #define __UTILS__
 
+#include "ctree.h"
+
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
 int make_btrfs(int fd, const char *device, const char *label,
@@ -46,4 +48,5 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+int open_file_or_dir(const char *fname);
 #endif
-- 
1.7.1

