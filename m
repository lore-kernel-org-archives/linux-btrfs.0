Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33142 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2KAKmJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 06:42:09 -0400
Received: from ucsinet22.oracle.com ([156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qA1Ag8Zv031142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 10:42:09 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qA1Ag7kC016507
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 10:42:07 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qA1Ag76f012262
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 05:42:07 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/2] Btrfs-progs: add feature to label subvol and snapshot
Date: Thu,  1 Nov 2012 18:46:09 +0800
Message-Id: <1351766770-4044-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfslabel.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 btrfslabel.h      |    4 +++-
 cmds-filesystem.c |   34 +++++++++++++++++++++++++++++-----
 ioctl.h           |    2 ++
 4 files changed, 74 insertions(+), 6 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index cb142b0..90fe618 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -126,3 +126,43 @@ int set_label(char *btrfs_dev, char *nLabel)
 	change_label_unmounted(btrfs_dev, nLabel);
 	return 0;
 }
+
+int get_subvol_label(char *subvol)
+{
+	int fd, e=0;
+	char label[BTRFS_LABEL_SIZE+1];
+
+	fd = open_file_or_dir(subvol);
+
+	if(ioctl(fd, BTRFS_IOC_SUBVOL_GETLABEL, label) < 0) {
+		e = errno;
+		fprintf(stderr, "ERROR: get subvol label failed, %s\n",
+			strerror(e));
+		close(fd);
+		return -e;
+	}
+	label[BTRFS_LABEL_SIZE] = '\0';
+	printf("%s\n",label);
+	close(fd);
+	return 0;
+}
+
+int set_subvol_label(char *subvol, char *labelp)
+{
+	int fd, e=0;
+	char label[BTRFS_LABEL_SIZE];
+
+	fd = open_file_or_dir(subvol);
+
+	memset(label, 0, BTRFS_LABEL_SIZE);
+	strcpy(label, labelp);
+	if(ioctl(fd, BTRFS_IOC_SUBVOL_SETLABEL, label) < 0) {
+		e = errno;
+		fprintf(stderr, "ERROR: set subvol label failed, %s\n",
+			strerror(e));
+		close(fd);
+		return -e;
+	}
+	close(fd);	
+	return 0;
+}
diff --git a/btrfslabel.h b/btrfslabel.h
index abf43ad..3db4180 100644
--- a/btrfslabel.h
+++ b/btrfslabel.h
@@ -2,4 +2,6 @@
 
 
 int get_label(char *btrfs_dev);
-int set_label(char *btrfs_dev, char *nLabel);
\ No newline at end of file
+int set_label(char *btrfs_dev, char *nLabel);
+int get_subvol_label(char *subvol);
+int set_subvol_label(char *subvol, char *labelp);
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9c43d35..718e70b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,7 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <sys/stat.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -517,18 +518,41 @@ static int cmd_resize(int argc, char **argv)
 }
 
 static const char * const cmd_label_usage[] = {
-	"btrfs filesystem label <device> [<newlabel>]",
-	"Get or change the label of an unmounted filesystem",
-	"With one argument, get the label of filesystem on <device>.",
-	"If <newlabel> is passed, set the filesystem label to <newlabel>.",
+	"btrfs filesystem label [-t] <device>|<subvol> [<newlabel>]",
+	"Read or modify filesystem or subvol or snapshot label",
+	"-t  Read or modify label for the specified subvol or snapshot.",
 	NULL
 };
 
 static int cmd_label(int argc, char **argv)
 {
-	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
+	struct stat st;
+	char subvol[BTRFS_PATH_NAME_MAX+1];
+
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
 		usage(cmd_label_usage);
 
+	if(getopt(argc, argv, "t:") != -1) {
+		if(optarg == NULL || strlen(optarg) > BTRFS_PATH_NAME_MAX)
+			return -1;
+		else {
+			strcpy(subvol,optarg);
+			if(stat(subvol, &st) < 0) {
+				fprintf(stderr, "Error: %s\n",strerror(errno));
+				return -errno;
+			}
+			if(!S_ISDIR(st.st_mode)) {
+				fprintf(stderr, "Error: Not a dir\n");
+				return -1;
+			}
+		}
+		if (argc > 3)
+			return set_subvol_label(argv[2], argv[3]);
+		else
+			return get_subvol_label(argv[2]);
+		return 0;
+	}
+
 	if (argc > 2)
 		return set_label(argv[1], argv[2]);
 	else
diff --git a/ioctl.h b/ioctl.h
index 6fda3a1..009fa6e 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -432,4 +432,6 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 					struct btrfs_ioctl_qgroup_limit_args)
+#define BTRFS_IOC_SUBVOL_GETLABEL _IOWR(BTRFS_IOCTL_MAGIC, 55, __u64)
+#define BTRFS_IOC_SUBVOL_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 56, __u64)
 #endif
-- 
1.7.1

