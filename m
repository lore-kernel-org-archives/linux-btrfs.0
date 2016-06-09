Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23453 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbcFIVqv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 17:46:51 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u59Lkmhr011873
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jun 2016 21:46:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u59Lkmkc001808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jun 2016 21:46:48 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u59Lkmnb001328
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jun 2016 21:46:48 GMT
From: Ashish Samant <ashish.samant@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
Subject: [PATCH] Btrfs-progs: add check-only option for balance
Date: Thu,  9 Jun 2016 14:46:41 -0700
Message-Id: <1465508801-14163-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <bo.li.lu@oracle.com>

This aims to decide whether a balance can reduce the number of
data block groups and if it can, this shows the '-dvrange' block
group's objectid.

With this, you can run
'btrfs balance start -c mnt' or 'btrfs balance start --check-only mnt'

 --------------------------------------------------------------
$ btrfs balance start -c /mnt/btrfs
Checking data block groups...
block_group        12582912 (len     8388608 used      786432)
block_group      1103101952 (len  1073741824 used   536870912)
block_group      2176843776 (len  1073741824 used  1073741824)
total bgs 3 total_free 544473088 min_used bg 12582912 has (min_used 786432 free 7602176)
run 'btrfs balance start -dvrange=12582912..12582913 your_mnt'

$ btrfs balance start -dvrange=12582912..12582913 /mnt/btrfs
Done, had to relocate 1 out of 5 chunks

$ btrfs balance start -c /mnt/btrfs
Checking data block groups...
block_group      1103101952 (len  1073741824 used   537395200)
block_group      2176843776 (len  1073741824 used  1073741824)
total bgs 2 total_free 536346624 min_used bg 1103101952 has (min_used 537395200 free 536346624)
 --------------------------------------------------------------

So you now know how to babysit your btrfs in a smart way.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
---
 cmds-balance.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 126 insertions(+), 1 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 8f3bf5b..e2aab6c 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -493,6 +493,116 @@ out:
 	return ret;
 }
 
+/* return 0 if balance can remove a data block group, otherwise return 1 */
+static int search_data_bgs(const char *path)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk;
+	struct btrfs_ioctl_search_header *header;
+	struct btrfs_block_group_item *bg;
+	unsigned long off = 0;
+	DIR *dirstream = NULL;
+	int e;
+	int fd;
+	int i;
+	u64 total_free = 0;
+	u64 min_used = (u64)-1;
+	u64 free_of_min_used = 0;
+	u64 bg_of_min_used = 0;
+	u64 flags;
+	u64 used;
+	int ret = 0;
+	int nr_data_bgs = 0;
+
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
+		return 1;
+
+	memset(&args, 0, sizeof(args));
+	sk = &args.key;
+
+	sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
+	sk->min_objectid = sk->min_offset = sk->min_transid = 0;
+	sk->max_objectid = sk->max_offset = sk->max_transid = (u64)-1;
+	sk->max_type = sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	sk->nr_items = 65536;
+
+	while (1) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr, "ret %d error '%s'\n", ret,
+				strerror(e));
+			return ret;
+		}
+		/*
+		 * it should not happen.
+		 */
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		for (i = 0; i < sk->nr_items; i++) {
+			header = (struct btrfs_ioctl_search_header *)(args.buf
+								      + off);
+
+			off += sizeof(*header);
+			if (header->type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+				bg = (struct btrfs_block_group_item *)
+					(args.buf + off);
+				flags = btrfs_block_group_flags(bg);
+				if (flags & BTRFS_BLOCK_GROUP_DATA) {
+					nr_data_bgs++;
+					used = btrfs_block_group_used(bg);
+					printf(
+					"block_group %15llu (len %11llu used %11llu)\n",
+							header->objectid,
+							header->offset, used);
+					total_free += header->offset - used;
+					if (min_used >= used) {
+						min_used = used;
+						free_of_min_used =
+							header->offset - used;
+						bg_of_min_used =
+							header->objectid;
+					}
+				}
+			}
+
+			off += header->len;
+			sk->min_objectid = header->objectid;
+			sk->min_type = header->type;
+			sk->min_offset = header->offset;
+		}
+		sk->nr_items = 65536;
+
+		if (sk->min_objectid < sk->max_objectid)
+			sk->min_objectid += 1;
+		else
+			break;
+	}
+
+	if (nr_data_bgs <= 1) {
+		printf("Data block groups in fs = %d, no need to do balance.\n",
+				nr_data_bgs);
+		return 1;
+	}
+
+	printf("total bgs %d total_free %llu min_used bg %llu has (min_used %llu free %llu)\n",
+			nr_data_bgs, total_free, bg_of_min_used, min_used,
+			free_of_min_used);
+	if (total_free - free_of_min_used > min_used) {
+		printf("run 'btrfs balance start -dvrange=%llu..%llu <mountpoint>'\n",
+				bg_of_min_used, bg_of_min_used + 1);
+		ret = 0;
+	} else {
+		printf("Please don't balance data block groups, it won't work.\n");
+		ret = 1;
+	}
+
+	return ret;
+}
+
 static const char * const cmd_balance_start_usage[] = {
 	"btrfs balance start [options] <path>",
 	"Balance chunks across the devices",
@@ -508,6 +618,7 @@ static const char * const cmd_balance_start_usage[] = {
 	"-m[filters]    act on metadata chunks",
 	"-s[filters]    act on system chunks (only under -f)",
 	"-v             be verbose",
+	"-c             only check if balance would make sense, not doing real job",
 	"-f             force reducing of metadata integrity",
 	"--full-balance do not print warning and do not delay start",
 	NULL
@@ -521,6 +632,7 @@ static int cmd_balance_start(int argc, char **argv)
 	int force = 0;
 	int verbose = 0;
 	unsigned start_flags = 0;
+	int check_data_bgs = 0;
 	int i;
 
 	memset(&args, 0, sizeof(args));
@@ -534,12 +646,14 @@ static int cmd_balance_start(int argc, char **argv)
 			{ "system", optional_argument, NULL, 's' },
 			{ "force", no_argument, NULL, 'f' },
 			{ "verbose", no_argument, NULL, 'v' },
+			{ "check-only", no_argument, NULL, 'c' },
 			{ "full-balance", no_argument, NULL,
 				GETOPT_VAL_FULL_BALANCE },
 			{ NULL, 0, NULL, 0 }
 		};
 
-		int opt = getopt_long(argc, argv, "d::s::m::fv", longopts, NULL);
+		int opt = getopt_long(argc, argv, "d::s::m::fvc", longopts,
+				      NULL);
 		if (opt < 0)
 			break;
 
@@ -571,6 +685,9 @@ static int cmd_balance_start(int argc, char **argv)
 		case 'v':
 			verbose = 1;
 			break;
+		case 'c':
+			check_data_bgs = 1;
+			break;
 		case GETOPT_VAL_FULL_BALANCE:
 			start_flags |= BALANCE_START_NOWARN;
 			break;
@@ -582,6 +699,14 @@ static int cmd_balance_start(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_balance_start_usage);
 
+	if (check_data_bgs) {
+		if (verbose)
+			dump_ioctl_balance_args(&args);
+
+		printf("Checking data block groups...\n");
+		return search_data_bgs(argv[optind]);
+	}
+
 	/*
 	 * allow -s only under --force, otherwise do with system chunks
 	 * the same thing we were ordered to do with meta chunks
-- 
1.7.1

