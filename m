Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DA6C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 13:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8538B214D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 13:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mctnGWTz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfCLNWs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 09:22:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfCLNWs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 09:22:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2CDK03V123625
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 13:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=9KkMaAVQdXkeSuSKmF9DSSEVz/qg5pXkIjlpA83umNY=;
 b=mctnGWTzYMqMAefXmpyqAr7OxoJnkc4pdVtDfntyvlbsHX87kJ1sWIGWcA3wz62tP3mu
 nrPxp+sjxRa/GpGjWNlP61Z23ux8OQ98hyW59XNfMjkndhtnRtA+A7HdHso7FjKY4wn3
 +f7r3koP/5SFp/3sOkfOkK/eZM0vr7VfcKYqXqffwRCy1+3dH69Jm8D/v2MsOGbGts4O
 hebRyX/Jya/P1eVH/rcRJVy9PuGDJAabFPr811s2Y+UFoGS/Ta1QxnM7+uKUPSNjCdAh
 o+WGP1HiCoNxB45znyBeglBK6EtmNjoGpWtBwnR+tB4L3cE5AG2VqmHkRXdbYf4+E9ob Cw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2r430en0sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 13:22:46 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2CDMk0Q003144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 13:22:46 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2CDMkqs024955
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 13:22:46 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Mar 2019 06:22:46 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5] btrfs-progs: dump-tree: add noscan option
Date:   Tue, 12 Mar 2019 21:22:50 +0800
Message-Id: <1552396970-14651-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9192 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=974 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903120095
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Anand Jain <Anand.Jain@oracle.com>

The cli 'btrfs inspect dump-tree <dev>' will scan for the partner devices
if any by default.

So as of now you can not inspect each mirrored device independently.

This patch adds noscan option, which when used won't scan the system for
the partner devices, instead it just uses the devices provided in the
argument.

For example:
  btrfs inspect dump-tree --noscan <dev> [<dev>..]

This helps to debug degraded raid1 and raid10.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4->v5: nit: use %m to print error string.
	changelog update.
v3->v4: change the patch title.
	collapse scan_args() to its only parent cmd_inspect_dump_tree()
	(it was bit confusing).
	update the change log.
	update usage.
	update man page.
v2->v3: make it scalable for more than two disks in noscan mode
v1->v2: rename --degraded to --noscan

 Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
 cmds-inspect-dump-tree.c                      | 53 +++++++++++++++++++++------
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 381497d284b8..f9d7f1c58f00 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1 and 2 and the superblock
 must be present on the device with a valid signature, can be used together with
 '--force'
 
-*dump-tree* [options] <device>::
+*dump-tree* [options] <device> [device...]::
 (replaces the standalone tool *btrfs-debug-tree*)
 +
 Dump tree structures from a given device in textual form, expand keys to human
@@ -95,6 +95,9 @@ intermixed in the output
 --bfs::::
 use breadth-first search to print trees. the nodes are printed before all
 leaves
+--noscan::::
+do not scan the system for other partner device(s), only use the device(s)
+provided in the argument
 -t <tree_id>::::
 print only the tree with the specified ID, where the ID can be numerical or
 common name in a flexible human readable form
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index ad5345b4f1db..37d9b29fa824 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -21,6 +21,7 @@
 #include <unistd.h>
 #include <uuid/uuid.h>
 #include <getopt.h>
+#include <fcntl.h>
 
 #include "kerncompat.h"
 #include "radix-tree.h"
@@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, const char **end)
 }
 
 const char * const cmd_inspect_dump_tree_usage[] = {
-	"btrfs inspect-internal dump-tree [options] device",
+	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
 	"Dump tree structures from a given device",
 	"Dump tree structures from a given device in textual form, expand keys to human",
 	"readable equivalents where possible.",
@@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	"-b|--block <block_num> print info from the specified block only",
 	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
 	"--follow               use with -b, to show all children tree blocks of <block_num>",
+	"--noscan               do not scan for the partner device(s)",
 	NULL
 };
 
@@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key found_key;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
-	int ret;
+	int ret = 0;
 	int slot;
 	int extent_only = 0;
 	int device_only = 0;
@@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	int roots_only = 0;
 	int root_backups = 0;
 	int traverse = BTRFS_PRINT_TREE_DEFAULT;
+	int dev_optind;
 	unsigned open_ctree_flags;
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
@@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	optind = 0;
 	while (1) {
 		int c;
-		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS,
-		       GETOPT_VAL_BFS };
+		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
+		       GETOPT_VAL_NOSCAN};
 		static const struct option long_options[] = {
 			{ "extents", no_argument, NULL, 'e'},
 			{ "device", no_argument, NULL, 'd'},
@@ -252,6 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
 			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
 			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
+			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -313,24 +317,49 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		case GETOPT_VAL_BFS:
 			traverse = BTRFS_PRINT_TREE_BFS;
 			break;
+		case GETOPT_VAL_NOSCAN:
+			open_ctree_flags |= OPEN_CTREE_NO_DEVICES;
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
+	dev_optind = optind;
+	while (dev_optind < argc) {
+		int fd;
+		struct btrfs_fs_devices *fs_devices;
+		u64 num_devices;
+
+		ret = check_arg_type(argv[optind]);
+		if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
+			if (ret < 0) {
+				errno = -ret;
+				error("invalid argument %s: %m", argv[dev_optind]);
+			} else {
+				error("not a block device or regular file: %s",
+				       argv[dev_optind]);
+			}
+		}
+		fd = open(argv[dev_optind], O_RDONLY);
+		if (fd < 0) {
+			error("cannot open %s: %m", argv[dev_optind]);
+			return -EINVAL;
+		}
+		ret = btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
+					    &num_devices,
+					    BTRFS_SUPER_INFO_OFFSET,
+					    SBREAD_DEFAULT);
+		close(fd);
 		if (ret < 0) {
 			errno = -ret;
-			error("invalid argument %s: %m", argv[optind]);
-		} else {
-			error("not a block device or regular file: %s",
-			      argv[optind]);
+			error("device scan %s: %m", argv[dev_optind]);
+			return ret;
 		}
-		goto out;
+		dev_optind++;
 	}
 
 	printf("%s\n", PACKAGE_STRING);
-- 
1.8.3.1

