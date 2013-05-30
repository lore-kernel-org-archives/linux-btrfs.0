Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967432Ab3E3DhP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:37:15 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4U3bENO002466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:15 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3bD0Z007289
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:14 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3bDfb006848
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6 v2] btrfs-progs: scan /dev/mapper in filesystem show and device scan
Date: Thu, 30 May 2013 11:40:26 +0800
Message-Id: <1369885226-3640-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
 <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, btrsf fi show and btrfs dev scan uses
/proc/partitions (by default) (which gives priority
to dm-<x> over sd<y> paths) and with --all-devices it
will scan /dev only (when it skips links under /dev/mapper).

However using /dev/mapper paths are in common practice
with mount, fstab, and lvm, so its better to be consistent
with them.

This patch adds --mapper option to device scan and
filesystem show cli, when used will look for btrfs
dev under /dev/mapper and will use the links provided
under /dev/mapper.

eg:
btrfs fi show --mapper
Label: none  uuid: 0a621111-ad84-4d80-842a-dd9c1c60bf51
        Total devices 2 FS bytes used 1.17MB
        devid    1 size 44.99GB used 2.04GB path /dev/mapper/mpathe
        devid    2 size 48.23GB used 2.03GB path /dev/mapper/mpathd

Label: none  uuid: bad9105f-bdc6-4626-9ba7-80bd97aebe19
        Total devices 1 FS bytes used 28.00KB
        devid    1 size 15.00GB used 2.04GB path /dev/mapper/mpathbp1

In the long run I want the usage of /dev/mapper path
along with /proc/partitions be the default option to
scan for the btrfs devs. /proc/partitions must be scanned
as well because to include the mapper blacklisted devs.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |  8 +++++++-
 cmds-filesystem.c |  7 +++++--
 man/btrfs.8.in    | 12 +++++++-----
 utils.c           |  3 +++
 utils.h           |  5 +++--
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index b6ecb3b..ef6bc60 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -178,7 +178,7 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<--all-devices>|<device> [<device>...]]",
+	"btrfs device scan [<--all-devices>|<--mapper>|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
 	NULL
 };
@@ -195,6 +195,12 @@ static int cmd_scan_dev(int argc, char **argv)
 
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
index 0d76d58..9b7bcf1 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -232,7 +232,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices|<uuid>]",
+	"btrfs filesystem show [--all-devices|--mapper|<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -248,9 +248,12 @@ static int cmd_show(int argc, char **argv)
 	int where = BTRFS_SCAN_PROC;
 	int searchstart = 1;
 
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
+	if (argc > 1 && !strcmp(argv[1],"--all-devices")) {
 		where = BTRFS_SCAN_DEV;
 		searchstart += 1;
+	} else if (argc > 1 && !strcmp(argv[1],"--mapper")) {
+		where = BTRFS_SCAN_MAPPER;
+		searchstart += 1;
 	}
 
 	if (check_argc_max(argc, searchstart + 1))
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index ae984f8..8988b16 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,11 +31,11 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>]\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|--mapper|<uuid>]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
+\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|--mapper|<device> [<device>...]]\fP
 .PP
 \fBbtrfs\fP \fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
 .PP
@@ -282,10 +282,11 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [--all-devices|<uuid>]\fR
+\fBfilesystem show\fR [--all-devices|--mapper|<uuid>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP
 is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
+If \fB--mapper\fP is passed, all the devices under /dev/mapper are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
 
@@ -314,11 +315,12 @@ Add device(s) to the filesystem identified by \fI<path>\fR.
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .TP
 
-\fBdevice scan\fR \fI[--all-devices|<device> [<device>...]\fR
+\fBdevice scan\fR \fI[--all-devices|--mapper|<device> [<device>...]\fR
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
 If no devices are passed, \fBbtrfs\fR scans all the block devices listed
 in the /proc/partitions file.
-Finally, if \fB--all-devices\fP is passed, all the devices under /dev are 
+If \fB--all-devices\fP is passed, all the devices under /dev are 
+Finally, if \fB--mapper\fP is passed, all the devices under /dev/mapper are 
 scanned.
 .TP
 
diff --git a/utils.c b/utils.c
index 6ac7c73..afec980 100644
--- a/utils.c
+++ b/utils.c
@@ -1825,6 +1825,9 @@ int scan_for_btrfs(int where, int update_kernel)
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
index 78f3a65..733d13b 100644
--- a/utils.h
+++ b/utils.h
@@ -24,8 +24,9 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
-#define BTRFS_SCAN_PROC	1
-#define BTRFS_SCAN_DEV	2
+#define BTRFS_SCAN_PROC      1
+#define BTRFS_SCAN_DEV       2
+#define BTRFS_SCAN_MAPPER    3
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
-- 
1.8.1.227.g44fe835

