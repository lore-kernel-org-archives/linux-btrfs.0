Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbcFVR0Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 13:26:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CBBBBAC92
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 17:26:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, David Sterba <dsterba@suse.com>
Subject: [RFC][PATCH] btrfs-progs: inspect: new subcommand to dump chunks
Date: Wed, 22 Jun 2016 19:26:46 +0200
Message-Id: <1466616406-28087-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

Hi,

the chunk dump is a useful thing, for debugging or balance filters.

Example output:

Chunks on device id: 1
PNumber            Type        PStart        Length          PEnd     Age         LStart  Usage
-----------------------------------------------------------------------------------------------
      0   System/RAID1        1.00MiB      32.00MiB      33.00MiB      47        1.40TiB   0.06
      1 Metadata/RAID1       33.00MiB       1.00GiB       1.03GiB      31        1.36TiB  64.03
      2 Metadata/RAID1        1.03GiB      32.00MiB       1.06GiB      36        1.36TiB  77.28
      3     Data/single       1.06GiB       1.00GiB       2.06GiB      12      422.30GiB  78.90
      4     Data/single       2.06GiB       1.00GiB       3.06GiB      11      420.30GiB  78.47
...

(full output is at http://susepaste.org/view/raw/089a9877)

This patch does the basic output, not filtering or sorting besides physical and
logical offset. There are possiblities to do more or enhance the output (eg.
starting with logical chunk and list the related physcial chunks together).
Or filter by type/profile, or understand the balance filters format.

As it is now, it's per-device dump of physical layout, which was the original
idea.

Printing 'usage' is not default as it's quite slow, it uses the search ioctl
and probably not in the best way, or there's some other issue in the
implementation.

I'll add the patch to devel branch but will not add it for any particular
release yet, I'd like some feedback first. Thanks.

-------------
New command 'btrfs inspect-internal dump-chunks' will dump layout of
chunks as stored on the devices. This corresponds to the physical
layout, sorted by the physical offset. The block group usage can be
shown as well, but the search is too slow so it's off by default.

If the physical offset sorting is selected, the empty space between
chunks is also shown.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-inspect.c | 364 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 364 insertions(+)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index dd7b9dd278f2..4eace63d8517 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -623,6 +623,368 @@ static int cmd_inspect_min_dev_size(int argc, char **argv)
 	return !!ret;
 }
 
+static const char * const cmd_dump_chunks_usage[] = {
+	"btrfs inspect-internal chunk-stats [options] <path>",
+	"Show chunks (block groups) layout",
+	"Show chunks (block groups) layout for all devices",
+	"",
+	HELPINFO_UNITS_LONG,
+	"--sort=MODE        sort by the physical or logical chunk start",
+	"                   MODE is one of pstart or lstart (default: pstart)",
+	"--usage            show usage per block group, note this can be slow",
+	NULL
+};
+
+enum {
+	CHUNK_SORT_PSTART,
+	CHUNK_SORT_LSTART,
+	CHUNK_SORT_DEFAULT = CHUNK_SORT_PSTART
+};
+
+struct dump_chunks_entry {
+	u64 devid;
+	u64 start;
+	u64 lstart;
+	u64 length;
+	u64 flags;
+	u64 age;
+	u64 used;
+	u32 pnumber;
+};
+
+struct dump_chunks_ctx {
+	unsigned length;
+	unsigned size;
+	struct dump_chunks_entry *stats;
+};
+
+int cmp_cse_devid_start(const void *va, const void *vb)
+{
+	const struct dump_chunks_entry *a = va;
+	const struct dump_chunks_entry *b = vb;
+
+	if (a->devid < b->devid)
+		return -1;
+	if (a->devid > b->devid)
+		return 1;
+
+	if (a->start < b->start)
+		return -1;
+	if (a->start == b->start) {
+		error(
+	"chunks start on same offset in the same device: devid %llu start %llu",
+		    (unsigned long long)a->devid, (unsigned long long)a->start);
+		return 0;
+	}
+	return 1;
+}
+
+int cmp_cse_devid_lstart(const void *va, const void *vb)
+{
+	const struct dump_chunks_entry *a = va;
+	const struct dump_chunks_entry *b = vb;
+
+	if (a->devid < b->devid)
+		return -1;
+	if (a->devid > b->devid)
+		return 1;
+
+	if (a->lstart < b->lstart)
+		return -1;
+	if (a->lstart == b->lstart) {
+		error(
+"chunks logically start on same offset in the same device: devid %llu start %llu",
+		    (unsigned long long)a->devid, (unsigned long long)a->lstart);
+		return 0;
+	}
+	return 1;
+}
+
+void print_dump_chunks(struct dump_chunks_ctx *ctx, unsigned sort_mode,
+		unsigned unit_mode, int with_usage)
+{
+	u64 devid;
+	struct dump_chunks_entry e;
+	int i;
+	int chidx;
+	u64 lastend = 0;
+	u64 age;
+
+	/*
+	 * Chunks are sorted logically as found by the ioctl, we need to sort
+	 * them once to find the physical ordering. This is the default mode.
+	 */
+	qsort(ctx->stats, ctx->length, sizeof(ctx->stats[0]), cmp_cse_devid_start);
+	devid = 0;
+	age = 0;
+	for (i = 0; i < ctx->length; i++) {
+		e = ctx->stats[i];
+		if (e.devid != devid) {
+			devid = e.devid;
+			age = 0;
+		}
+		ctx->stats[i].pnumber = age;
+		age++;
+	}
+
+	if (sort_mode == CHUNK_SORT_LSTART)
+		qsort(ctx->stats, ctx->length, sizeof(ctx->stats[0]), cmp_cse_devid_lstart);
+
+	devid = 0;
+	for (i = 0; i < ctx->length; i++) {
+		e = ctx->stats[i];
+		if (e.devid != devid) {
+			devid = e.devid;
+			if (i != 0)
+				putchar('\n');
+			printf("Chunks on device id: %llu\n", devid);
+			printf("PNumber            Type        PStart        Length          PEnd     Age         LStart%s\n",
+					with_usage ? "  Usage" : "");
+			printf("----------------------------------------------------------------------------------------%s\n",
+					with_usage ? "-------" : "");
+			chidx = 0;
+			lastend = 0;
+		}
+		if (sort_mode == CHUNK_SORT_PSTART && lastend > 0
+		    && e.start != lastend) {
+			printf("      .           empty             .  ");
+			printf("%12s  ",
+				pretty_size_mode(e.start - lastend, unit_mode));
+			printf("           .       .              .\n");
+		}
+
+		printf("%7u ", e.pnumber);
+		printf("%8s/%-6s  ", btrfs_group_type_str(e.flags),
+				btrfs_group_profile_str(e.flags));
+		printf("%12s  ", pretty_size_mode(e.start, unit_mode));
+		printf("%12s  ", pretty_size_mode(e.length, unit_mode));
+		printf("%12s  ",
+			pretty_size_mode(e.start + e.length - 1, unit_mode));
+		printf("%6llu ", e.age);
+		printf("%14s", pretty_size_mode(e.lstart, unit_mode));
+		if (with_usage)
+			printf("  %5.2f", (float)e.used / e.length * 100);
+		printf("\n");
+
+		lastend = e.start + e.length;
+		chidx++;
+	}
+}
+
+static u64 fill_usage(int fd, u64 lstart)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header sh;
+	struct btrfs_block_group_item *item;
+	int ret;
+
+	memset(&args, 0, sizeof(args));
+	sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
+	sk->min_objectid = lstart;
+	sk->max_objectid = lstart;
+	sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	sk->max_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	sk->min_offset = 0;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	sk->nr_items = 4096;
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0) {
+		error("cannot perform the search: %s", strerror(errno));
+		return 1;
+	}
+	if (sk->nr_items == 0) {
+		warning("blockgroup %llu not found",
+				(unsigned long long)lstart);
+		return 0;
+	}
+	if (sk->nr_items > 1) {
+		warning("found more than one blockgroup %llu",
+				(unsigned long long)lstart);
+	}
+
+	memcpy(&sh, args.buf, sizeof(sh));
+	item = (struct btrfs_block_group_item*)(args.buf + sizeof(sh));
+
+	return item->used;
+}
+
+static int cmd_dump_chunks(int argc, char **argv)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header sh;
+	unsigned long off = 0;
+	u64 *age = 0;
+	unsigned age_size = 128;
+	int ret;
+	int fd;
+	int i;
+	int e;
+	DIR *dirstream = NULL;
+	unsigned unit_mode;
+	unsigned sort_mode = 0;
+	int with_usage = 0;
+	const char *path;
+	struct dump_chunks_ctx ctx = {
+		.length = 0,
+		.size = 1024,
+		.stats = NULL
+	};
+
+	unit_mode = get_unit_mode_from_arg(&argc, argv, 0);
+
+	while (1) {
+		int c;
+		enum { GETOPT_VAL_SORT = 256, GETOPT_VAL_USAGE };
+		static const struct option long_options[] = {
+			{"sort", required_argument, NULL, GETOPT_VAL_SORT },
+			{"usage", no_argument, NULL, GETOPT_VAL_USAGE },
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "", long_options, NULL);
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case GETOPT_VAL_SORT:
+			if (strcmp(optarg, "pstart") == 0) {
+				sort_mode = CHUNK_SORT_PSTART;
+			} else if (strcmp(optarg, "lstart") == 0) {
+				sort_mode = CHUNK_SORT_LSTART;
+			} else {
+				error("unknown sort mode: %s", optarg);
+				exit(1);
+			}
+			break;
+		case GETOPT_VAL_USAGE:
+			with_usage = 1;
+			break;
+		default:
+			usage(cmd_dump_chunks_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_dump_chunks_usage);
+
+	ctx.stats = calloc(ctx.size, sizeof(ctx.stats[0]));
+	if (!ctx.stats)
+		goto out_nomem;
+
+	path = argv[optind];
+
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+	        error("cannot access '%s': %s", path, strerror(errno));
+		return 1;
+	}
+
+	memset(&args, 0, sizeof(args));
+	sk->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
+	sk->min_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	sk->max_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	sk->min_type = BTRFS_CHUNK_ITEM_KEY;
+	sk->max_type = BTRFS_CHUNK_ITEM_KEY;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+	age = calloc(age_size, sizeof(u64));
+	if (!age)
+		goto out_nomem;
+
+	while (1) {
+		sk->nr_items = 4096;
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			error("cannot perform the search: %s", strerror(e));
+			return 1;
+		}
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_chunk *item;
+			struct btrfs_stripe *stripes;
+			int sidx;
+			u64 used = (u64)-1;
+
+			memcpy(&sh, args.buf + off, sizeof(sh));
+			off += sizeof(sh);
+			item = (struct btrfs_chunk*)(args.buf + off);
+			off += sh.len;
+
+			stripes = &item->stripe;
+			for (sidx = 0; sidx < item->num_stripes; sidx++) {
+				struct dump_chunks_entry *e;
+				u64 devid;
+
+				e = &ctx.stats[ctx.length];
+				devid = stripes[sidx].devid;
+				e->devid = devid;
+				e->start = stripes[sidx].offset;
+				e->lstart = sh.offset;
+				e->length = item->length;
+				e->flags = item->type;
+				e->pnumber = -1;
+				while (devid > age_size) {
+					u64 *tmp;
+					unsigned old_size = age_size;
+
+					age_size += 128;
+					tmp = calloc(age_size, sizeof(u64));
+					if (!tmp) {
+						free(age);
+						goto out_nomem;
+					}
+					memcpy(tmp, age, sizeof(u64) * old_size);
+					age = tmp;
+				}
+				e->age = age[devid]++;
+				if (with_usage) {
+					if (used == (u64)-1)
+						used = fill_usage(fd, sh.offset);
+					e->used = used;
+				} else {
+					e->used = 0;
+				}
+
+				ctx.length++;
+
+				if (ctx.length == ctx.size) {
+					ctx.size += 1024;
+					ctx.stats = realloc(ctx.stats, ctx.size
+						* sizeof(ctx.stats[0]));
+					if (!ctx.stats)
+						goto out_nomem;
+				}
+			}
+
+			sk->min_objectid = sh.objectid;
+			sk->min_type = sh.type;
+			sk->min_offset = sh.offset;
+		}
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else
+			break;
+	}
+
+	print_dump_chunks(&ctx, sort_mode, unit_mode, with_usage);
+	free(ctx.stats);
+
+	close_file_or_dir(fd, dirstream);
+	return 0;
+
+out_nomem:
+	error("not enough memory");
+	return 1;
+}
+
 static const char inspect_cmd_group_info[] =
 "query various internal information";
 
@@ -644,6 +1006,8 @@ const struct cmd_group inspect_cmd_group = {
 				cmd_inspect_dump_super_usage, NULL, 0 },
 		{ "tree-stats", cmd_inspect_tree_stats,
 				cmd_inspect_tree_stats_usage, NULL, 0 },
+		{ "dump-chunks", cmd_dump_chunks, cmd_dump_chunks_usage, NULL,
+			0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.7.1

