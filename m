Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51689 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2HaFmW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:42:22 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7V5gLfe028433
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:42:22 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7V5gLgD000447
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:42:21 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7V5gL5A029745
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 00:42:21 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs-progs: add options to change bufsize in logical to inode translation
Date: Fri, 31 Aug 2012 13:40:44 +0800
Message-Id: <1346391644-4450-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add an option 's' to set bufsize in logical to inode transition, then we are able
to read all the refs to the logical address.
Meanwhile, set a max value 64k for the bufsize.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2->v3: - use 64k as the upper limit
        - document command's options

 cmds-inspect.c |   23 +++++++++++++++++------
 man/btrfs.8.in |    7 +++++--
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 2f0228f..42f16fc 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -115,8 +115,13 @@ static int cmd_inode_resolve(int argc, char **argv)
 }
 
 static const char * const cmd_logical_resolve_usage[] = {
-	"btrfs inspect-internal logical-resolve [-Pv] <logical> <path>",
+	"btrfs inspect-internal logical-resolve [-Pv] [-s bufsize] <logical> <path>",
 	"Get file system paths for the given logical address",
+	"-P          skip the path resolving and print the inodes instead",
+	"-v          verbose mode",
+	"-s bufsize  set inode container's size. This is used to increase inode",
+	"            container's size in case it is not enough to read all the ",
+	"            resolved results. The max value one can set is 64k",
 	NULL
 };
 
@@ -130,12 +135,13 @@ static int cmd_logical_resolve(int argc, char **argv)
 	int bytes_left;
 	struct btrfs_ioctl_logical_ino_args loi;
 	struct btrfs_data_container *inodes;
+	u64 size = 4096;
 	char full_path[4096];
 	char *path_ptr;
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "Pv");
+		int c = getopt(argc, argv, "Pvs:");
 		if (c < 0)
 			break;
 
@@ -146,6 +152,9 @@ static int cmd_logical_resolve(int argc, char **argv)
 		case 'v':
 			verbose = 1;
 			break;
+		case 's':
+			size = atoll(optarg);
+			break;
 		default:
 			usage(cmd_logical_resolve_usage);
 		}
@@ -154,12 +163,13 @@ static int cmd_logical_resolve(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_logical_resolve_usage);
 
-	inodes = malloc(4096);
+	size = min(size, 64 * 1024);
+	inodes = malloc(size);
 	if (!inodes)
 		return 1;
 
 	loi.logical = atoll(argv[optind]);
-	loi.size = 4096;
+	loi.size = size;
 	loi.inodes = (u64)inodes;
 
 	fd = open_file_or_dir(argv[optind+1]);
@@ -176,8 +186,9 @@ static int cmd_logical_resolve(int argc, char **argv)
 	}
 
 	if (verbose)
-		printf("ioctl ret=%d, bytes_left=%lu, bytes_missing=%lu, "
-			"cnt=%d, missed=%d\n", ret,
+		printf("ioctl ret=%d, total_size=%llu, bytes_left=%lu, "
+			"bytes_missing=%lu, cnt=%d, missed=%d\n",
+			ret, size,
 			(unsigned long)inodes->bytes_left,
 			(unsigned long)inodes->bytes_missing,
 			inodes->elem_cnt, inodes->elem_missed);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4b0a9f9..941efd0 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -50,7 +50,7 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBinspect-internal logical-resolve\fP
-[-Pv] \fI<logical>\fP \fI<path>\fP
+[-Pv] [-s size] \fI<logical>\fP \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
 .PP
@@ -307,7 +307,7 @@ verbose mode. print count of returned paths and ioctl() return value
 .RE
 .TP
 
-\fBinspect-internal logical-resolve\fP [-Pv] \fI<logical>\fP \fI<path>\fP
+\fBinspect-internal logical-resolve\fP [-Pv] [-s bufsize] \fI<logical>\fP \fI<path>\fP
 Resolves a <logical> address in the filesystem mounted at <path> to all inodes.
 By default, each inode is then resolved to a file system path (similar to the
 \fBinode-resolve\fP subcommand).
@@ -318,6 +318,9 @@ By default, each inode is then resolved to a file system path (similar to the
 skip the path resolving and print the inodes instead
 .IP -v 5
 verbose mode. print count of returned paths and all ioctl() return values
+.IP -s bufsize 5
+set inode container's size. This is used to increase inode container's size in case it is
+not enough to read all the resolved results. The max value one can set is 64k.
 .RE
 
 .SH EXIT STATUS
-- 
1.7.7.6

