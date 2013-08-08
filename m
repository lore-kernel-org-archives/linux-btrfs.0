Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab3HHIDl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:03:41 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7883erv006487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:41 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7883djM015963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:40 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7883dhN015888
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: scan /dev/mapper in filesystem show and device scan
Date: Thu,  8 Aug 2013 16:09:28 +0800
Message-Id: <1375949368-23798-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1375949368-23798-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1375949368-23798-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, btrsf fi show and btrfs dev scan uses
/proc/partitions (by default) (which gives priority
to dm-<x> over sd<y> paths) and with --all-devices it
will scan /dev only (where it skips links under /dev/mapper).

However using /dev/mapper paths are in common practice
with mount, fstab, and lvm, so its better to be consistent
with them.

This patch adds --mapper option to btrfs device scan and
btrfs filesystem show cli, when used will look for btrfs
devs under /dev/mapper and will use the links provided
under the /dev/mapper.

eg:
btrfs fi show --mapper
Label: none  uuid: 0a621111-ad84-4d80-842a-dd9c1c60bf51
        Total devices 2 FS bytes used 1.17MB
        devid    1 size 44.99GB used 2.04GB path /dev/mapper/mpathe
        devid    2 size 48.23GB used 2.03GB path /dev/mapper/mpathd

Label: none  uuid: bad9105f-bdc6-4626-9ba7-80bd97aebe19
        Total devices 1 FS bytes used 28.00KB
        devid    1 size 15.00GB used 2.04GB path /dev/mapper/mpathbp1

In the long run mapper path when present (along with /proc/partitions)
can be the default option to scan for the btrfs devs.
(/proc/partitions must be scanned as well because to
include the mapper blacklisted (from mapper) devs.)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |  8 +++++++-
 cmds-filesystem.c |  7 +++++--
 man/btrfs.8.in    | 22 ++++++++++++----------
 utils.c           |  3 +++
 utils.h           |  1 +
 5 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index be2aaff..6d1b378 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -186,7 +186,7 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<--all-devices>|<device> [<device>...]]",
+	"btrfs device scan [<--all-devices>|<--mapper>|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
 	NULL
 };
@@ -203,6 +203,12 @@ static int cmd_scan_dev(int argc, char **argv)
 
 		where = BTRFS_SCAN_DEV;
 		devstart += 1;
+	} else if( argc > 1 && !strcmp(argv[1],"--mapper")){
+		if (check_argc_max(argc, 2))
+			usage(cmd_scan_dev_usage);
+
+		where = BTRFS_SCAN_MAPPER;
+		devstart += 1;
 	}
 
 	if(argc<=devstart){
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 74ad30b..88cace3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -371,7 +371,7 @@ static int btrfs_scan_kernel(void *input, int type)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices|--mapper|--kernel|<uuid>]",
+	"btrfs filesystem show [--all-devices|--mapper|--kernel] [<uuid>|<path>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -388,9 +388,12 @@ static int cmd_show(int argc, char **argv)
 	int searchstart = 1;
 	u8 processed[PATH_MAX];
 
-	if( argc > 1 && !strcmp(argv[1], "--all-devices")){
+	if (argc > 1 && !strcmp(argv[1], "--all-devices")){
 		where = BTRFS_SCAN_DEV;
 		searchstart += 1;
+	} else if (argc > 1 && !strcmp(argv[1], "--mapper")) {
+		where = BTRFS_SCAN_MAPPER;
+		searchstart += 1;
 	} else if (argc > 1 && !strcmp(argv[1], "--kernel")) {
 		where = 0;
 		searchstart += 1;
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 6383469..821f138 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,7 +25,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem df\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|--kernel] [\fI<uuid>|<path>]\fP\fP
+\fBbtrfs\fP \fBfilesystem show [\fP\fI--all-devices\fP|\fI--mapper\fP|\fI--kernel\fP] [\fI<uuid>\fP|\fI<path>\fP]
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
@@ -51,7 +51,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBdevice scan\fP [--all-devices|\fI<device> \fP[\fI<device>...\fP]
+\fBbtrfs\fP \fBdevice scan\fP [\fI--all-devices\fP|\fI--mapper\fP|\fI<device>\fP [\fI<device>...\fP]
 .PP
 \fBbtrfs\fP \fBdevice ready\fP\fI <device>\fP
 .PP
@@ -254,12 +254,13 @@ Show information of a given subvolume in the \fI<path>\fR.
 Show space usage information for a mount point.
 .TP
 
-\fBfilesystem show\fR [--all-devices|--kernel] [\fI<uuid>|<path>]\fP\fP
-Show the btrfs filesystem with some additional info. If no \fIUUID\fP or
-\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
+\fBfilesystem show\fR [\fI--all-devices\fP|\fI--mapper\fP|\fI--kernel\fP] [\fI<uuid>\fP|\fI<path>\fP]\fP
+Show the btrfs filesystem with some additional info. If no \fIuuid\fP
+is passed, it will show info of all the btrfs filesystem.
+If \fI--all-devices\fP is passed, all the devices under /dev are scanned;
+If \fI--mapper\fP is passed, the devices under /dev/mapper are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
-The --kernel will scan the btrfs kernel for the mounted btrfs.
+The \fI--kernel\fP will scan the btrfs kernel for the mounted btrfs.
 .TP
 
 \fBfilesystem sync\fR\fI <path> \fR
@@ -390,11 +391,12 @@ Add device(s) to the filesystem identified by \fI<path>\fR.
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .TP
 
-\fBdevice scan\fR [--all-devices|\fI<device> \fP[\fI<device>...\fP]\fR
+\fBdevice scan\fR [\fI--all-devices\fP|\fI--mapper\fP|\fI<device>\fP...]\fR
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
-If no devices are passed, \fBbtrfs\fR scans all the block devices listed
+If no devices are passed, then it will scans all the block devices listed
 in the /proc/partitions file.
-Finally, if \fB--all-devices\fP is passed, all the devices under /dev are 
+If \fI--mapper\fP is passed, all the devices under /dev/mapper are scanned
+Finally, if \fI--all-devices\fP is passed, all the devices under /dev are 
 scanned.
 .TP
 
diff --git a/utils.c b/utils.c
index 038e599..382d102 100644
--- a/utils.c
+++ b/utils.c
@@ -1923,6 +1923,9 @@ int scan_for_btrfs(int where, int update_kernel)
 	case BTRFS_SCAN_DEV:
 		ret = btrfs_scan_one_dir("/dev", update_kernel);
 		break;
+	case BTRFS_SCAN_MAPPER:
+		ret = btrfs_scan_one_dir("/dev/mapper", update_kernel);
+		break;
 	}
 	return ret;
 }
diff --git a/utils.h b/utils.h
index 6419c3e..13e2fd5 100644
--- a/utils.h
+++ b/utils.h
@@ -27,6 +27,7 @@
 
 #define BTRFS_SCAN_PROC	1
 #define BTRFS_SCAN_DEV		2
+#define BTRFS_SCAN_MAPPER	3
 
 #define BTRFS_ERR_STR_LEN	100
 
-- 
1.8.1.191.g414c78c

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
