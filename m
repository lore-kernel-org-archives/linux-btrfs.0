Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48895 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2HWI7D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 04:59:03 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7N8x012024078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 08:59:01 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7N8x0WO007044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 08:59:00 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7N8wxIL023376
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 03:58:59 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add options to change size in logical to inode transition
Date: Thu, 23 Aug 2012 16:56:28 +0800
Message-Id: <1345712189-6455-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add an option 's' to set size in logical to inode transition, then we are able
to read all the refs to the logical address.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-inspect.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 2f0228f..be5e588 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -115,7 +115,7 @@ static int cmd_inode_resolve(int argc, char **argv)
 }
 
 static const char * const cmd_logical_resolve_usage[] = {
-	"btrfs inspect-internal logical-resolve [-Pv] <logical> <path>",
+	"btrfs inspect-internal logical-resolve [-Pv] [-s size] <logical> <path>",
 	"Get file system paths for the given logical address",
 	NULL
 };
@@ -130,12 +130,13 @@ static int cmd_logical_resolve(int argc, char **argv)
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
 
@@ -146,6 +147,9 @@ static int cmd_logical_resolve(int argc, char **argv)
 		case 'v':
 			verbose = 1;
 			break;
+		case 's':
+			size = atoll(optarg);
+			break;
 		default:
 			usage(cmd_logical_resolve_usage);
 		}
@@ -154,12 +158,13 @@ static int cmd_logical_resolve(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_logical_resolve_usage);
 
-	inodes = malloc(4096);
+	size = max(size, 4096);
+	inodes = malloc(size);
 	if (!inodes)
 		return 1;
 
 	loi.logical = atoll(argv[optind]);
-	loi.size = 4096;
+	loi.size = size;
 	loi.inodes = (u64)inodes;
 
 	fd = open_file_or_dir(argv[optind+1]);
@@ -176,8 +181,9 @@ static int cmd_logical_resolve(int argc, char **argv)
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
-- 
1.7.7.6

