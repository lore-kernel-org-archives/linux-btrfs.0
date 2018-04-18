Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeDRJbw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 05:31:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I9Vc8K123071
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:31:52 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2hdrxp1s6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:31:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I9Vpjp032231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:31:51 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I9VpCX006522
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:31:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs-progs: dump-tree: add degraded option
Date: Wed, 18 Apr 2018 17:33:57 +0800
Message-Id: <20180418093357.8528-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

btrfs inspect dump-tree picks the disk with the largest generation
to read the root tree by scanning for the required devices by default.

But in 2 or more disks RAID1/5/6 you may need to know what's in the
disks individually, so this option --noscan indicates to use only the
given disk to dump.

For example:

 mkfs.btrfs -fq -draid1 -mraid1 /dev/sd[b-d]
 btrfs in dump-tree --noscan /dev/sdb /dev/sdc

 However as usual without noscan option it works as it scans for the
 devices by its own. And if minimum required number of devices are
 not provided then when --noscan option is used, it errors out as
 shown below.

 btrfs in dump-tree --noscan /dev/sdb
 check arg type : /dev/sdbbtrfs-progs v4.14.1
 warning, device 3 is missing
 warning, device 2 is missing
 bytenr mismatch, want=22036480, have=0
 ERROR: cannot read chunk root
 ERROR: unable to open /dev/sdb

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: make it scalable for more than two disks in noscan mode
v1->v2: rename --degraded to --noscan

 cmds-inspect-dump-tree.c | 60 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 0802b31e9596..8625cd608ad0 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -21,6 +21,7 @@
 #include <unistd.h>
 #include <uuid/uuid.h>
 #include <getopt.h>
+#include <fcntl.h>
 
 #include "kerncompat.h"
 #include "radix-tree.h"
@@ -183,6 +184,46 @@ static u64 treeid_from_string(const char *str, const char **end)
 	return id;
 }
 
+static int scan_args(char **argv, int argc, int tmpind, int noscan)
+{
+	int fd;
+	int ret;
+	u64 num_devices;
+	struct btrfs_fs_devices *tmp_devices;
+
+	while (tmpind < argc) {
+		ret = check_arg_type(argv[tmpind]);
+		if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
+			error("not a block device or regular file: %s",
+			      argv[tmpind]);
+			return -EINVAL;
+		}
+
+		if (!noscan) {
+			tmpind++;
+			continue;
+		}
+
+		fd = open(argv[tmpind], O_RDONLY);
+		if (fd < 0) {
+			error("cannot open %s: %m", argv[tmpind]);
+			return -EINVAL;
+		}
+		ret = btrfs_scan_one_device(fd, argv[tmpind],
+					    &tmp_devices, &num_devices,
+					    BTRFS_SUPER_INFO_OFFSET,
+					    SBREAD_DEFAULT);
+		close(fd);
+		if (ret) {
+			error("cannot scan %s: %s",
+			      argv[tmpind], strerror(-ret));
+			return ret;
+		}
+		tmpind++;
+	}
+	return 0;
+}
+
 const char * const cmd_inspect_dump_tree_usage[] = {
 	"btrfs inspect-internal dump-tree [options] device",
 	"Dump tree structures from a given device",
@@ -199,6 +240,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	"-b|--block <block_num> print info from the specified block only",
 	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
 	"--follow               use with -b, to show all children tree blocks of <block_num>",
+	"--noscan               only uses the devices provided as the argument",
 	NULL
 };
 
@@ -213,7 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key found_key;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
-	int ret;
+	int ret = 0;
 	int slot;
 	int extent_only = 0;
 	int device_only = 0;
@@ -225,10 +267,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
 	bool follow = false;
+	bool noscan = false;
 
 	while (1) {
 		int c;
-		enum { GETOPT_VAL_FOLLOW = 256 };
+		enum { GETOPT_VAL_FOLLOW = 256,
+		       GETOPT_VAL_NOSCAN = 257};
 		static const struct option long_options[] = {
 			{ "extents", no_argument, NULL, 'e'},
 			{ "device", no_argument, NULL, 'd'},
@@ -238,6 +282,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			{ "block", required_argument, NULL, 'b'},
 			{ "tree", required_argument, NULL, 't'},
 			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
+			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -293,19 +338,20 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		case GETOPT_VAL_FOLLOW:
 			follow = true;
 			break;
+		case GETOPT_VAL_NOSCAN:
+			open_ctree_flags |= OPEN_CTREE_NO_DEVICES;
+			noscan = true;
+			break;
 		default:
 			usage(cmd_inspect_dump_tree_usage);
 		}
 	}
 
-	if (check_argc_exact(argc - optind, 1))
+	if (check_argc_min(argc - optind, 1))
 		usage(cmd_inspect_dump_tree_usage);
 
-	ret = check_arg_type(argv[optind]);
-	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
-		error("not a block device or regular file: %s", argv[optind]);
+	if (scan_args(argv, argc, optind, noscan))
 		goto out;
-	}
 
 	printf("%s\n", PACKAGE_STRING);
 
-- 
2.15.0

