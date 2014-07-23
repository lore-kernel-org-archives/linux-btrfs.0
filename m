Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225AbaGWU4Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 16:56:16 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7D67BAB5D
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 20:56:14 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: wait until all subvolumes are cleaned
Date: Wed, 23 Jul 2014 22:56:13 +0200
Message-Id: <1406148973-23162-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance the 'subvolume' subcommand to wait until a given list of
subvolumes or all currently scheduled for deletion are cleaned
completely from the filesystem.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

'wait' seemed too generic, 'sync' is not completely accurate but IMHO better,
I'm open to other suggestions

 cmds-subvolume.c | 231 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 231 insertions(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 5e821c712e74..07485acbc1bd 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1035,6 +1035,236 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_subvol_sync_usage[] = {
+	"btrfs subvolume sync <path> [<subvol-id>...]",
+	"Wait until given subvolume(s) are completely cleaned",
+	"Wait until given subvolume(s) are completely cleaned after deletion.",
+	"If no subvolume id is given, wait until there are no more snapshots",
+	"to be cleaned. This may take long if new deleted subvolumes appear",
+	"during the sleep interval.",
+	"",
+	"-s <N>       sleep N seconds between checks (default: 1)",
+	NULL
+};
+
+static int is_subvolume_cleaned(int fd, u64 subvolid)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	sk->min_objectid = subvolid;
+	sk->max_objectid = subvolid;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_offset = 0;
+	sk->max_offset = (u64)-1;
+	sk->min_transid = 0;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 1;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0)
+		return -errno;
+
+	if (sk->nr_items == 0)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * If we're looking for any dead subvolume, take a shortcut and look
+ * for any ORPHAN_ITEMs in the tree root
+ */
+static int fs_has_dead_subvolumes(int fd)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header sh;
+	u64 min_subvolid = 0;
+
+again:
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	sk->min_objectid = BTRFS_ORPHAN_OBJECTID;
+	sk->max_objectid = BTRFS_ORPHAN_OBJECTID;
+	sk->min_type = BTRFS_ORPHAN_ITEM_KEY;
+	sk->max_type = BTRFS_ORPHAN_ITEM_KEY;
+	sk->min_offset = min_subvolid;
+	sk->max_offset = (u64)-1;
+	sk->min_transid = 0;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 1;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0)
+		return -errno;
+
+	if (!sk->nr_items)
+		return 0;
+
+	memcpy(&sh, args.buf, sizeof(sh));
+	min_subvolid = sh.offset;
+
+	/*
+	 * Verify that the root item is really there and we haven't hit
+	 * a stale orphan
+	 */
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	sk->min_objectid = min_subvolid;
+	sk->max_objectid = min_subvolid;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_offset = 0;
+	sk->max_offset = (u64)-1;
+	sk->min_transid = 0;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 1;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0)
+		return -errno;
+
+	/*
+	 * Stale orphan, try the next one
+	 */
+	if (!sk->nr_items) {
+		min_subvolid++;
+		goto again;
+	}
+
+	return 1;
+}
+
+static int cmd_subvol_sync(int argc, char **argv)
+{
+	int fd = -1;
+	int i;
+	int ret = 1;
+	DIR *dirstream = NULL;
+	u64 *ids = NULL;
+	int id_count;
+	int remaining;
+	int sleep_interval = 1;
+
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "s:");
+
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 's':
+			sleep_interval = atoi(argv[optind]);
+			if (sleep_interval < 1) {
+				fprintf(stderr,
+					"ERROR: invalid sleep interval %s\n",
+					argv[optind]);
+				ret = 1;
+				goto out;
+			}
+			break;
+		default:
+			usage(cmd_subvol_sync_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1))
+		usage(cmd_subvol_sync_usage);
+
+	fd = open_file_or_dir(argv[optind], &dirstream);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind]);
+		ret = 1;
+		goto out;
+	}
+	optind++;
+
+	id_count = argc - optind;
+
+	/*
+	 * Wait for all
+	 */
+	if (!id_count) {
+		while (1) {
+			ret = fs_has_dead_subvolumes(fd);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR: can't perform the search - %s\n",
+						strerror(-ret));
+				ret = 1;
+				goto out;
+			}
+			if (!ret)
+				goto out;
+			sleep(sleep_interval);
+		}
+	}
+
+	/*
+	 * Wait only for the requested ones
+	 */
+	ids = (u64*)malloc(sizeof(u64) * id_count);
+
+	if (!ids) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		ret = 1;
+		goto out;
+	}
+
+	for (i = 0; i < id_count; i++) {
+		u64 id;
+		const char *arg;
+
+		arg = argv[optind + i];
+		errno = 0;
+		id = strtoull(arg, NULL, 10);
+		if (errno < 0) {
+			fprintf(stderr, "ERROR: unrecognized subovlume id %s\n",
+				arg);
+			ret = 1;
+			goto out;
+		}
+		if (id < BTRFS_FIRST_FREE_OBJECTID || id > BTRFS_LAST_FREE_OBJECTID) {
+			fprintf(stderr, "ERROR: subovlume id %s out of range\n",
+				arg);
+			ret = 1;
+			goto out;
+		}
+		ids[i] = id;
+	}
+
+	remaining = id_count;
+	while (1) {
+		for (i = 0; i < id_count; i++) {
+			if (!ids[i])
+				continue;
+			ret = is_subvolume_cleaned(fd, ids[i]);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR: can't perform the search - %s\n",
+						strerror(-ret));
+				goto out;
+			}
+			if (ret) {
+				printf("Subvolume id %llu is gone\n", ids[i]);
+				ids[i] = 0;
+				remaining--;
+			}
+		}
+		if (!remaining)
+			break;
+		sleep(sleep_interval);
+	}
+
+out:
+	free(ids);
+	close_file_or_dir(fd, dirstream);
+
+	return !!ret;
+}
+
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -1047,6 +1277,7 @@ const struct cmd_group subvolume_cmd_group = {
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
 		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
+		{ "sync", cmd_subvol_sync, cmd_subvol_sync_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
1.8.4.5

