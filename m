Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38078 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab2KBKPB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:15:01 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1719924eek.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:15:00 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/8] Move open_file_or_dir() in utils.c
Date: Fri,  2 Nov 2012 11:15:34 +0100
Message-Id: <1351851339-19150-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Due to the moving of the scrub_fs_info() and scrub_device_info() in utils.h
the function open_file_or_dir() is moved in utils.c too, in order to avoid
the including of "commands.h".
Moreover in btrfsctl.c the function open_file_or_dir() is renamed as
btrfsctl_open_file_or_dir() in order to avoid collision name because these
two functions are a bit different.
Since open_file_or_dir() makes use of the function dirfd(3), the required
XOPEN version was raised from 6 to 7.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile         |    4 ++--
 btrfsctl.c       |    6 +++---
 cmds-balance.c   |    1 +
 cmds-inspect.c   |    1 +
 cmds-qgroup.c    |    1 +
 cmds-quota.c     |    1 +
 cmds-subvolume.c |    1 +
 commands.h       |    3 ---
 common.c         |   46 ----------------------------------------------
 utils.c          |   29 +++++++++++++++++++++++++++--
 utils.h          |    1 +
 11 files changed, 38 insertions(+), 56 deletions(-)
 delete mode 100644 common.c

diff --git a/Makefile b/Makefile
index 4a9b6e0..9a45a84 100644
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
index 518684c..c1981ba 100644
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
@@ -128,7 +128,7 @@ int main(int ac, char **av)
 			snap_location = strdup(fullpath);
 			snap_location = dirname(snap_location);
 
-			snap_fd = open_file_or_dir(snap_location);
+			snap_fd = btrfsctl_open_file_or_dir(snap_location);
 
 			name = strdup(fullpath);
 			name = basename(name);
@@ -238,7 +238,7 @@ int main(int ac, char **av)
 		}
 		name = fname;
 	 } else {
-		fd = open_file_or_dir(fname);
+		fd = btrfsctl_open_file_or_dir(fname);
 	 }
 
 	if (name) {
diff --git a/cmds-balance.c b/cmds-balance.c
index 38a7426..5793b5c 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -26,6 +26,7 @@
 #include "ctree.h"
 #include "ioctl.h"
 #include "volumes.h"
+#include "utils.h"
 
 #include "commands.h"
 
diff --git a/cmds-inspect.c b/cmds-inspect.c
index edabff5..043b65b 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -21,6 +21,7 @@
 #include <errno.h>
 
 #include "kerncompat.h"
+#include "utils.h"
 #include "ioctl.h"
 
 #include "commands.h"
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 1525c11..e9f3143 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -22,6 +22,7 @@
 
 #include "ctree.h"
 #include "ioctl.h"
+#include "utils.h"
 
 #include "commands.h"
 
diff --git a/cmds-quota.c b/cmds-quota.c
index cf9ad97..ca9503a 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -21,6 +21,7 @@
 
 #include "ctree.h"
 #include "ioctl.h"
+#include "utils.h"
 
 #include "commands.h"
 
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
index fba11e0..f29745f 100644
--- a/utils.c
+++ b/utils.c
@@ -16,8 +16,9 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 600
-#define __USE_XOPEN2K
+#define _XOPEN_SOURCE 700
+#define __USE_XOPEN2K8
+#define __XOPEN2K8
 #include <stdio.h>
 #include <stdlib.h>
 #ifndef __CHECKER__
@@ -1117,6 +1118,30 @@ char *pretty_sizes(u64 size)
 	return pretty;
 }
 
+int open_file_or_dir(const char *fname)
+{
+	int ret;
+	struct stat st;
+	DIR *dirstream;
+	int fd;
+
+	ret = stat(fname, &st);
+	if (ret < 0)
+		return -1;
+	if (S_ISDIR(st.st_mode)) {
+		dirstream = opendir(fname);
+		if (!dirstream)
+			return -2;
+		fd = dirfd(dirstream);
+	} else {
+		fd = open(fname, O_RDWR);
+	}
+	if (fd < 0)
+		return -3;
+
+	return fd;
+}
+
 /*
  * Checks to make sure that the label matches our requirements.
  * Returns:
diff --git a/utils.h b/utils.h
index a82b81c..f0100c2 100644
--- a/utils.h
+++ b/utils.h
@@ -45,6 +45,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
+int open_file_or_dir(const char *fname);
 int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
-- 
1.7.10.4

