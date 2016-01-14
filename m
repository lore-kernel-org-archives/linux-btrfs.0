Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23533 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbcANXMZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 18:12:25 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: [PATCH] Btrfs-progs: add check-only option for balance
Date: Thu, 14 Jan 2016 15:12:12 -0800
Message-Id: <1452813132-18878-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously I did the same thing to btrfs-debugfs, it works good,
but since it's python script, and if your system doesn't have
python installed, then you need a binary.

This aims to decide whether a balance can reduce the number of
data block groups and if it is, this shows the '-dvrange' block
group's objectid.

With this, you can run
'btrfs balance start -c mnt' or 'btrfs balance start --check-only mnt'

--------------------------------------------------------------
$ btrfs balance start -c /mnt/btrfs
Checking data block group...
block_group        12582912 (len     8388608 used      786432)
block_group      1103101952 (len  1073741824 used   536870912)
block_group      2176843776 (len  1073741824 used  1073741824)
total_free 544473088 min_used bg 12582912 has (min_used 786432 free 7602176)
run btrfs balance start -dvrange=12582912..12582913 your_mnt

$ btrfs balance start -dvrange=12582912..12582913 /mnt/btrfs
Done, had to relocate 1 out of 5 chunks

$ btrfs balance start -c /mnt/btrfs
Checking data block group...
block_group      1103101952 (len  1073741824 used   537395200)
block_group      2176843776 (len  1073741824 used  1073741824)
total_free 536346624 min_used bg 1103101952 has (min_used 537395200 free 536346624)
--------------------------------------------------------------

So you now know how to babysit your btrfs in a smart way.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-balance.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 1 deletion(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 9f647cd..fc5c0e8 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -437,6 +437,106 @@ out:
 	return ret;
 }
 
+/* return 0 if balance remove data a block group, return 1 if it does not */
+static int search_data_bgs(const char *path)
+{
+	struct btrfs_ioctl_search_args_v2 *args;
+	struct btrfs_ioctl_search_key *sk;
+	struct btrfs_ioctl_search_header *header;
+	struct btrfs_block_group_item *bg;
+	DIR *dirstream = NULL;
+	int e;
+	int args_size = 65536;
+	int fd;
+	int i;
+	char buf[args_size];
+	u64 total_free = 0;
+	u64 min_used = (u64)-1;
+	u64 free_of_min_used = 0;
+	u64 bg_of_min_used = 0;
+	u64 flags;
+	u64 used;
+	int ret = 0;
+	char *p;
+
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
+		return 1;
+
+	memset(buf, 0, args_size);
+	args = (struct btrfs_ioctl_search_args_v2 *)buf;
+	sk = &(args->key);
+
+	sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
+	sk->min_objectid = sk->min_offset = sk->min_transid = 0;
+	sk->max_objectid = sk->max_offset = sk->max_transid = (u64)-1;
+	sk->max_type = sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	sk->nr_items = 65536;
+	args->buf_size = args_size - sizeof(struct btrfs_ioctl_search_args_v2);
+
+	while (1) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, args);
+		e = errno;
+		if (ret != 0) {
+			fprintf(stderr, "ret %d error '%s'\n", ret, strerror(e));
+			return ret;
+		}
+
+		// it should not happen.
+		if (sk->nr_items == 0)
+			break;
+
+		/*
+		 * BTRFS_IOC_TREE_SEARCH_V2: args->buf is in fact __u64 buf[0]
+		 * instead of char buf[0]
+		 */
+		p = (char *)args->buf;
+
+		for (i = 0; i < sk->nr_items; i++) {
+			header = (struct btrfs_ioctl_search_header *)p;
+
+			p += sizeof(*header);
+			if (header->type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+				bg = (struct btrfs_block_group_item *)p;
+				flags = btrfs_block_group_flags(bg);
+				used = btrfs_block_group_used(bg);
+				if (flags & BTRFS_BLOCK_GROUP_DATA) {
+					printf("block_group %15llu (len %11llu used %11llu)\n",
+						header->objectid, header->offset,
+						btrfs_block_group_used(bg));
+					total_free += header->offset - used;
+					if (min_used >= used) {
+						min_used = used;
+						free_of_min_used = header->offset - used;
+						bg_of_min_used = header->objectid;
+					}
+				}
+			}
+
+			p += header->len;
+			sk->min_objectid = header->objectid;
+		}
+
+		if (sk->min_objectid < sk->max_objectid)
+			sk->min_objectid += 1;
+		else
+			break;
+	}
+
+	printf("total_free %llu min_used bg %llu has (min_used %llu free %llu)\n",
+		total_free, bg_of_min_used, min_used, free_of_min_used);
+	if (total_free - free_of_min_used > min_used) {
+		printf("run 'btrfs balance start -dvrange=%llu..%llu your_mnt'\n",
+			bg_of_min_used, bg_of_min_used + 1);
+		ret = 0;
+	} else {
+		printf("Please do not balance data block groups, it won't work\n");
+		ret = 1;
+	}
+
+	return ret;
+}
+
 static const char * const cmd_balance_start_usage[] = {
 	"btrfs balance start [options] <path>",
 	"Balance chunks across the devices",
@@ -450,6 +550,7 @@ static const char * const cmd_balance_start_usage[] = {
 	"-m[filters]    act on metadata chunks",
 	"-s[filters]    act on system chunks (only under -f)",
 	"-v             be verbose",
+	"-c             only check if balance would make sense, not doing real job",
 	"-f             force reducing of metadata integrity",
 	NULL
 };
@@ -462,6 +563,7 @@ static int cmd_balance_start(int argc, char **argv)
 	int force = 0;
 	int verbose = 0;
 	int nofilters = 1;
+	int check_data_bgs = 0;
 	int i;
 
 	memset(&args, 0, sizeof(args));
@@ -473,11 +575,12 @@ static int cmd_balance_start(int argc, char **argv)
 			{ "metadata", optional_argument, NULL, 'm' },
 			{ "system", optional_argument, NULL, 's' },
 			{ "force", no_argument, NULL, 'f' },
+			{ "check-only", no_argument, NULL, 'c' },
 			{ "verbose", no_argument, NULL, 'v' },
 			{ NULL, 0, NULL, 0 }
 		};
 
-		int opt = getopt_long(argc, argv, "d::s::m::fv", longopts, NULL);
+		int opt = getopt_long(argc, argv, "d::s::m::fvc", longopts, NULL);
 		if (opt < 0)
 			break;
 
@@ -509,6 +612,9 @@ static int cmd_balance_start(int argc, char **argv)
 		case 'v':
 			verbose = 1;
 			break;
+		case 'c':
+			check_data_bgs = 1;
+			break;
 		default:
 			usage(cmd_balance_start_usage);
 		}
@@ -517,6 +623,14 @@ static int cmd_balance_start(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_balance_start_usage);
 
+	if (check_data_bgs) {
+		if (verbose)
+			dump_ioctl_balance_args(&args);
+
+		printf("Checking data block group...\n");
+		return search_data_bgs(argv[optind]);
+	}
+
 	/*
 	 * allow -s only under --force, otherwise do with system chunks
 	 * the same thing we were ordered to do with meta chunks
-- 
2.5.0

