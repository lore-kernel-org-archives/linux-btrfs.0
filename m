Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23176 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933941AbcJRAfv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 20:35:51 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9I0ZoVn019464
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id u9I0Zojx011389
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:50 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u9I0Zodv010073
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:50 GMT
From: Divya Indi <divya.indi@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: ashish.samant@oracle.com, bo.li.liu@oracle.com
Subject: [PATCH 3/3] btrfs-progs: Add command to check if balance op is req
Date: Mon, 17 Oct 2016 17:35:15 -0700
Message-Id: <1476750915-3105-4-git-send-email-divya.indi@oracle.com>
In-Reply-To: <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new subcommand to btrfs inspect-internal

btrfs inspect-internal balance_check <path>
Checks whether 'btrfs balance' can help creating more space (Only
considers data block groups).

Signed-off-by: Divya Indi <divya.indi@oracle.com>
Reviewed-by: Ashish Samant <ashish.samant@oracle.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-inspect.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 0e2f15a..5baaa49 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -267,6 +267,151 @@ static const char * const cmd_inspect_inode_resolve_usage[] = {
 	NULL
 };
 
+static const char * const cmd_inspect_balance_check_usage[] = {
+	"btrfs inspect-internal balance_check <path>",
+	"To check whether 'btrfs balance' can help creating more space",
+	"",
+	"",
+	NULL
+};
+
+static int cmd_inspect_balance_check(int argc, char **argv)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_args bg_args;
+	struct btrfs_ioctl_search_key *sk;
+	struct btrfs_ioctl_search_key *bg_sk;
+	struct btrfs_ioctl_search_header *header;
+	struct btrfs_ioctl_search_header *bg_header;
+	struct btrfs_block_group_item *bg;
+	struct btrfs_chunk *chunk;
+	unsigned long off = 0;
+	unsigned long bg_off = 0;
+	DIR *dirstream = NULL;
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
+	if (check_argc_exact(argc, 2))
+		usage(cmd_inspect_balance_check_usage);
+
+	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
+	if (fd < 0)
+		return 1;
+
+	memset(&args, 0, sizeof(args));
+	sk = &args.key;
+	sk->min_offset = sk->min_transid = 0;
+	sk->max_offset = sk->max_transid = (u64)-1;
+
+	printf("%20s%20s%20s\n", "Start", "Len", "Used");
+	while (1) {
+		ret = get_chunks(fd, &args);
+		if (ret < 0)
+			goto out;
+
+		/*
+		 * it should not happen.
+		 */
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		memset(&bg_args, 0, sizeof(bg_args));
+		bg_sk = &bg_args.key;
+
+		/* For every chunk, look up 1 exact match for block group in
+		 * the extent tree. */
+		bg_sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
+		bg_sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+		bg_sk->max_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+		bg_sk->min_transid =  0;
+		bg_sk->max_transid = (u64)-1;
+
+		for (i = 0; i < sk->nr_items; i++) {
+			header = (struct btrfs_ioctl_search_header *)(args.buf
+								      + off);
+			off += sizeof(*header);
+			if (header->type == BTRFS_CHUNK_ITEM_KEY) {
+				chunk = (struct btrfs_chunk *)
+					(args.buf + off);
+				ret = get_bg_info(fd, &bg_args, header->offset,
+						  chunk->length);
+				if (ret < 0)
+					goto out;
+
+				/*
+				 * it should not happen.
+				 */
+				if (bg_sk->nr_items == 0)
+					continue;
+
+				bg_off = 0;
+				bg_header = (struct btrfs_ioctl_search_header *)
+					    (bg_args.buf + bg_off);
+				bg_off += sizeof(*bg_header);
+				bg = (struct btrfs_block_group_item *)
+				     (bg_args.buf + bg_off);
+
+				flags = btrfs_block_group_flags(bg);
+				if (flags & BTRFS_BLOCK_GROUP_DATA) {
+					used = btrfs_block_group_used(bg);
+					nr_data_bgs++;
+					printf("%20llu%20s%20s\n",
+						bg_header->objectid,
+						pretty_size(bg_header->offset),
+						pretty_size(used));
+					total_free += bg_header->offset - used;
+					if (min_used >= used) {
+						min_used = used;
+						free_of_min_used =
+							bg_header->offset - used;
+						bg_of_min_used =
+							bg_header->objectid;
+					}
+				}
+			}
+
+			off += header->len;
+			sk->min_offset = header->offset + header->len;
+		}
+		sk->nr_items = 4096;
+
+	}
+
+	if (nr_data_bgs <= 1) {
+		printf("Data block groups in fs = %d, no need to do balance.\n",
+				nr_data_bgs);
+		ret = 1;
+		goto out;
+	}
+
+	printf("Total data bgs: %d\nTotal free space: %s\n"
+	       "For min used bg %llu used = %s free = %s\n",
+		nr_data_bgs, pretty_size(total_free), bg_of_min_used,
+		pretty_size(min_used), pretty_size(free_of_min_used));
+
+	if (total_free - free_of_min_used > min_used) {
+		printf("run 'btrfs balance start -dvrange=%llu..%llu <mountpoint>'\n",
+				bg_of_min_used, bg_of_min_used + 1);
+		ret = 0;
+	} else {
+		printf("Please don't balance data block groups, no free space\n");
+		ret = 1;
+	}
+
+out:
+	close_file_or_dir(fd, dirstream);
+	return ret;
+}
+
 static int cmd_inspect_inode_resolve(int argc, char **argv)
 {
 	int fd;
@@ -816,6 +961,8 @@ const struct cmd_group inspect_cmd_group = {
 			cmd_inspect_min_dev_size_usage, NULL, 0 },
 		{ "bg_analysis", cmd_inspect_bg_analysis,
 			cmd_inspect_bg_analysis_usage, NULL, 0 },
+		{ "balance_check", cmd_inspect_balance_check,
+			cmd_inspect_balance_check_usage, NULL, 0 },
 		{ "dump-tree", cmd_inspect_dump_tree,
 				cmd_inspect_dump_tree_usage, NULL, 0 },
 		{ "dump-super", cmd_inspect_dump_super,
-- 
1.7.1

