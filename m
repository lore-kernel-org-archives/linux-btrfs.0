Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:56437 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752169AbcGXLDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 07:03:36 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/5] new command btrfs inspect physical-dump
Date: Sun, 24 Jul 2016 13:03:27 +0200
Message-Id: <1469358209-9427-4-git-send-email-kreijack@libero.it>
In-Reply-To: <1469358209-9427-1-git-send-email-kreijack@libero.it>
References: <1469358209-9427-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

The aim of this command, is to dump the disk content of a file bypassing the
btrfs filesystem. This could help to test the btrfs filesystem.
The dump size is a page (4k) (even if the file is shorter). It is possible
to set an offset for the file portion to read, but even this offset must be
multiple of 4k.

With the switch -c , it is possible to select whch copy will be
dumped (RAID1/RAID10/DUP).
With the switch -p, it is possible to select which parity will
be dumped (RAID5/RAID6)
With the switch -s, it is possible to dump the other elemnt of the
stripe (RAID5, RAID6)

# btrfs insp physical-dump /bin/ls 8192 | xxd
/bin/ls: 8192
file: /dev/sda3 off=16600629248
00000000: b0e2 6100 0000 0000 0700 0000 5200 0000  ..a.........R...
00000010: 0000 0000 0000 0000 b8e2 6100 0000 0000  ..........a.....
00000020: 0700 0000 5300 0000 0000 0000 0000 0000  ....S...........
00000030: c0e2 6100 0000 0000 0700 0000 5400 0000  ..a.........T...
[...]


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-inspect.c | 342 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 342 insertions(+)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index dd0570b..48243ec 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -1171,6 +1171,346 @@ out:
 	return ret;
 }
 
+static const char * const cmd_inspect_physical_dump_usage[] = {
+	"btrfs inspect-internal physical-dump [-c <copynr>|-s <stripenr>|-p <paritynr>] <path> [<off>]",
+	"Dump the physical content of a file offset",
+	"<path>      file to dump",
+	"<off>       file offset to dump; 0 if not specified",
+	"<copynr>    number of copy to dump (for raid1,dup/raid10)",
+	"<paritynr>  number of parity to dump (for raid5/raid6)",
+	"<stripenr>  number of stripe elemnt to dump (for raid5/raid6)",
+	"This command requires root privileges",
+	NULL
+};
+
+static int dumpfile(const char *fname, u64 off)
+{
+	int fd = -1;
+	int size = 4096;
+	char buf[size];
+	int r;
+	int e = 0;
+	off_t r1;
+
+	fprintf(stderr, "file: %s off=%llu\n", fname, off);
+
+	fd = open(fname, O_RDONLY|O_APPEND);
+	if (fd < 0) {
+		int e = errno;
+
+		error("cannot open file: '%s'\n", strerror(e));
+		return -e;
+	}
+
+	r1 = lseek(fd, off, SEEK_SET);
+	if (r1 == (off_t)-1) {
+		e = -errno;
+		error("cannot seek file: '%s'\n", strerror(-e));
+		goto out;
+	}
+
+	while (size) {
+		r = read(fd, buf, size);
+		if (r < 0) {
+			e = -errno;
+			error("cannot read file: '%s'\n", strerror(-e));
+			goto out;
+		}
+
+		size -= r;
+		r = fwrite(buf, r, 1, stdout);
+		if (r < 0) {
+			e = -errno;
+			error("cannot write: '%s'\n", strerror(-e));
+			goto out;
+		}
+
+	}
+
+out:
+	if (fd != -1)
+		close(fd);
+	return e;
+}
+
+static int cmd_inspect_physical_dump(int argc, char **argv)
+{
+	int ret = 0;
+	u64 logical = 0ull;
+	int fd;
+	int last = 0;
+	char buf[16384];
+	char *fname;
+	int found = 0;
+	struct fiemap *fiemap = (struct fiemap *)buf;
+	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
+	const int count = (sizeof(buf) - sizeof(*fiemap)) /
+			sizeof(struct fiemap_extent);
+	u64 profile_type;
+	struct btrfs_ioctl_dev_info_args *disks = NULL;
+	struct btrfs_ioctl_fs_info_args fi_args = {0};
+	char btrfs_chunk_data[4096];
+	struct btrfs_chunk *chunk_item = (struct btrfs_chunk *)&btrfs_chunk_data;
+	u64 chunk_offset = 0;
+	struct stripe_info *stripes = NULL;
+	int stripes_count = 0;
+	int rc;
+	int copynr = 0;
+	int paritynr = -1;
+	int stripenr = -1;
+
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "c:p:s:");
+
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'c':
+			copynr = atoi(optarg);
+			break;
+		case 'p':
+			paritynr = atoi(optarg);
+			break;
+		case 's':
+			stripenr = atoi(optarg);
+			break;
+		default:
+			usage(cmd_inspect_physical_dump_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1) ||
+	    check_argc_max(argc - optind, 3))
+		usage(cmd_inspect_physical_dump_usage);
+
+	if (argc - optind == 2)
+		logical = strtoull(argv[optind+1], NULL, 0);
+
+	if (logical % 4096) {
+		error("<off> must be multiple of 4096 !");
+		return 11;
+	}
+
+	fname = argv[optind];
+
+	check_root_or_exit();
+	check_btrfs_or_exit(fname);
+
+	fprintf(stderr, "%s: %llu\n", fname, logical);
+
+	fd = open(fname, O_RDONLY|O_DIRECT);
+	if (fd < 0) {
+		error("Can't open '%s' for reading.\n", fname);
+		ret = -errno;
+		goto out;
+	}
+
+	do {
+
+		int rc;
+		int j;
+
+		fiemap->fm_length = ~0ULL;
+		fiemap->fm_extent_count = count;
+		fiemap->fm_flags = FIEMAP_FLAG_SYNC;
+		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
+		if (rc < 0) {
+			error("Can't do ioctl()\n");
+			ret = -errno;
+			goto out;
+		}
+
+		for (j = 0; j < fiemap->fm_mapped_extents; j++) {
+			u32 flags;
+
+			fm_ext = &fiemap->fm_extents[j];
+			flags = fm_ext->fe_flags;
+
+			fiemap->fm_start = (fm_ext->fe_logical +
+				fm_ext->fe_length);
+
+			if (flags & FIEMAP_EXTENT_LAST)
+				last = 1;
+
+			if (flags & SKIP_FLAGS)
+				continue;
+
+			if (logical > fm_ext->fe_logical +
+			    fm_ext->fe_length)
+				continue;
+
+			found = 1;
+			break;
+		}
+	} while (last == 0 || found == 0);
+
+
+	if (!found) {
+		error("Can't find the extent: the file is too short, or the file is stored in a leaf.\n");
+		ret = 10;
+		goto out;
+	}
+
+	rc = get_fs_info(fname, &fi_args, &disks);
+	if (rc < 0) {
+		error("Cannot get info for the filesystem: may be it is not a btrfs filesystem ?\n");
+		ret = 12;
+		goto out;
+	}
+
+	rc = get_chunk_offset(fd,
+		fm_ext->fe_physical + logical - fm_ext->fe_logical,
+		chunk_item, &chunk_offset);
+	if (rc < 0) {
+		error("cannot perform the search: %s", strerror(rc));
+		ret = 13;
+		goto out;
+	}
+	if (rc != 0) {
+		error("cannot find chunk\n");
+		ret = 14;
+		goto out;
+	}
+
+	dump_stripes(fi_args.num_devices, disks,
+		     chunk_item, chunk_offset,
+		     &stripes, &stripes_count);
+
+	profile_type = chunk_item->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	if (profile_type == 0 || profile_type & BTRFS_BLOCK_GROUP_RAID0) {
+
+		if (copynr != 0) {
+			error("-c <copynr> is not valid for profile '%s'\n",
+			      btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+		if (stripenr != -1) {
+			error("-s <stripenr> is not valid for profile '%s'\n",
+			      btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+		if (paritynr != -1) {
+			error("-p <paritynr> is not valid for profile '%s'\n",
+			      btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+
+		ret = dumpfile(stripes[0].dname, stripes[0].phy_start);
+
+	} else if (profile_type & BTRFS_BLOCK_GROUP_RAID1 ||
+			profile_type & BTRFS_BLOCK_GROUP_DUP ||
+			profile_type & BTRFS_BLOCK_GROUP_RAID10) {
+
+		if (stripenr != -1) {
+			error("-s <stripenr> is not valid for profile '%s'\n",
+			      btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+		if (paritynr != -1) {
+			error("-p <paritynr> is not valid for profile '%s'\n",
+			      btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+		if (copynr < 0 || copynr > 1) {
+			error("<copynr>=%d is not valid for profile '%s'\n",
+			      copynr, btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+
+		ret = dumpfile(stripes[copynr].dname, stripes[copynr].phy_start);
+
+	} else if (profile_type & BTRFS_BLOCK_GROUP_RAID5 ||
+		   profile_type & BTRFS_BLOCK_GROUP_RAID6) {
+
+		int maxparity = 0;
+		int stripeid = -1;
+
+		if (profile_type & BTRFS_BLOCK_GROUP_RAID6)
+			maxparity = 1;
+
+		if (copynr != 0) {
+			error("-c <copynr> is not valid for profile '%s'\n",
+			      btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+		if (paritynr != -1 && stripenr != -1) {
+			error("You cannot pass both -p <paritynr> and -s <stripenr> for profile '%s'\n",
+				btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+		if (paritynr < -1 || paritynr > maxparity) {
+			error("<paritynr>=%d is not valid for profile '%s'\n",
+				paritynr, btrfs_group_profile_str(profile_type));
+			ret = 16;
+			goto out;
+		}
+		if (stripenr < -1 || stripenr > (stripes_count - maxparity - 3)) {
+			error("<stripenr>=%d is not valid for profile '%s' [%d disks]\n",
+				stripenr, btrfs_group_profile_str(profile_type),
+				stripes_count);
+			ret = 16;
+			goto out;
+		}
+		if (stripenr == -1 && paritynr == -1) {
+			int i;
+
+			for (i = 0 ; i < stripes_count ; i++) {
+				if (stripes[i].type == STRIPE_INFO_RAID56_DATA) {
+					stripeid = i;
+					break;
+				}
+			}
+		} else if (paritynr != -1) {
+			int i;
+
+			for (i = 0 ; i < stripes_count ; i++) {
+				if (stripes[i].type == STRIPE_INFO_RAID56_PARITY)
+					--paritynr;
+				if (paritynr == -1) {
+					stripeid = i;
+					break;
+				}
+			}
+		} else {
+			int i;
+
+			for (i = 0 ; i < stripes_count ; i++) {
+				if (stripes[i].type == STRIPE_INFO_RAID56_OTHER)
+					--stripenr;
+				if (stripenr == -1) {
+					stripeid = i;
+					break;
+				}
+			}
+		}
+
+		assert(stripeid >= 0 && stripeid < stripes_count);
+
+		ret = dumpfile(stripes[stripeid].dname,
+			       stripes[stripeid].phy_start);
+
+	}
+
+out:
+	if (fd != -1)
+		close(fd);
+	if (disks != NULL)
+		free(disks);
+	if (stripes != NULL)
+		free(stripes);
+	return ret;
+}
+
 static const char inspect_cmd_group_info[] =
 "query various internal information";
 
@@ -1194,6 +1534,8 @@ const struct cmd_group inspect_cmd_group = {
 				cmd_inspect_tree_stats_usage, NULL, 0 },
 		{ "physical-find", cmd_inspect_physical_find,
 				cmd_inspect_physical_find_usage, NULL, 0 },
+		{ "physical-dump", cmd_inspect_physical_dump,
+				cmd_inspect_physical_dump_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.8.1

