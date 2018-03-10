Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41064 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbeCJODQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 09:03:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2AE2LV1182946
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Mar 2018 14:03:15 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2gmgh4r0yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Mar 2018 14:03:15 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2ADrEF4031878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Mar 2018 13:53:14 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2ADrDtL020203
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Mar 2018 13:53:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: dump-tree: add degraded option
Date: Sat, 10 Mar 2018 21:54:49 +0800
Message-Id: <20180310135449.16072-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs inspect dump-tree cli picks the disk with the largest generation
to read the root tree, even when all the devices were not provided in
the cli. But in 2 disks RAID1 you may need to know what's in the disks
individually, so this option -x | --noscan indicates to use only the
given disk to dump.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: rename --degraded to --noscan

 cmds-inspect-dump-tree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index df44bb635c9c..d2676ce55af7 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -198,6 +198,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	"-u|--uuid              print only the uuid tree",
 	"-b|--block <block_num> print info from the specified block only",
 	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
+	"-x|--noscan            use the disk in the arg, do not scan for the disks (for raid1)",
 	NULL
 };
 
@@ -234,10 +235,11 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			{ "uuid", no_argument, NULL, 'u'},
 			{ "block", required_argument, NULL, 'b'},
 			{ "tree", required_argument, NULL, 't'},
+			{ "noscan", no_argument, NULL, 'x'},
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "deb:rRut:", long_options, NULL);
+		c = getopt_long(argc, argv, "deb:rRut:x", long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -286,6 +288,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			}
 			break;
 			}
+		case 'x':
+			open_ctree_flags |= OPEN_CTREE_NO_DEVICES;
+			break;
 		default:
 			usage(cmd_inspect_dump_tree_usage);
 		}
-- 
2.15.0

