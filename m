Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32088 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdGLWkn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:40:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH V2] btrfs-progs: add support to search subvolume by rootid and uuid
Date: Thu, 13 Jul 2017 06:47:11 +0800
Message-Id: <20170712224711.5771-1-anand.jain@oracle.com>
In-Reply-To: <20170712072050.2531-1-anand.jain@oracle.com>
References: <20170712072050.2531-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unless the top level is mounted there is no way to know the
details of all the subvolume.  For example:

mount -o subvol=sv1/newsv1 /dev/sdb /btrfs

btrfs su list /btrfs
ID 257 gen 12 top level 5 path sv1
ID 258 gen 9 top level 257 path sv1/snap
ID 259 gen 11 top level 257 path sv1/newsv1

You can't subvol show for sv1 and sv1/snap as its paths aren't
accessible to the user unless the its top level is mounted.

This patch adds two new options to the existing btrfs subvol show
cli. They are --rootid/-r or --uuid/-u, with this now the user will
be able to look for a subvolume using the rootid OR the uuid.

./btrfs su show -r 257 /btrfs
sv1
	Name: 			sv1
	UUID: 			30129358-c69d-3e4a-a662-29509cc69c95
	Parent UUID: 		-
	Received UUID: 		-
	Creation time: 		2017-07-11 20:32:57 +0800
	Subvolume ID: 		257
	Generation: 		12
	Gen at creation: 	7
	Parent ID: 		5
	Top level ID: 		5
	Flags: 			-
	Snapshot(s):
				sv1/snap

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Check if both -u and -r are set by the user and fail if so.

 btrfs-list.c     |  4 +++-
 cmds-subvolume.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 utils.c          | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h          |  5 ++++-
 4 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 8eec05ea797f..92a537f425f3 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1582,7 +1582,9 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 			rbn = rb_next(rbn);
 			continue;
 		}
-		if (!comp_entry_with_rootid(the_ri, ri, 0)) {
+
+		if (!comp_entry_with_rootid(the_ri, ri, 0) ||
+			!uuid_compare(the_ri->uuid, ri->uuid)) {
 			memcpy(the_ri, ri, offsetof(struct root_info, path));
 			the_ri->path = strdup_or_null(ri->path);
 			the_ri->name = strdup_or_null(ri->name);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index de6204eabeaf..de5e0da0ff48 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -891,8 +891,11 @@ static int cmd_subvol_find_new(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_show_usage[] = {
-	"btrfs subvolume show <subvol-path>",
+	"btrfs subvolume show [options] <subvol-path>|<mnt>",
 	"Show more information of the subvolume",
+	"-r|--rootid   rootid of the subvol to show",
+	"-u|--uuid     uuid of the subvol to show",
+	"If no option is specified <subvol-path> will be shown.",
 	NULL
 };
 
@@ -907,12 +910,43 @@ static int cmd_subvol_show(int argc, char **argv)
 	int fd = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL;
+	int by_rootid = 0;
+	int by_uuid = 0;
+	u64 rootid_arg;
+	u8 uuid_arg[BTRFS_UUID_SIZE];
 
-	clean_args_no_options(argc, argv, cmd_subvol_show_usage);
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "rootid", required_argument, NULL, 'r'},
+			{ "uuid", required_argument, NULL, 'u'},
+			{ NULL, 0, NULL, 0 }
+		};
+
+		c = getopt_long(argc, argv, "r:u:", long_options, NULL);
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'r':
+			rootid_arg = arg_strtou64(optarg);
+			by_rootid = 1;
+			break;
+		case 'u':
+			uuid_parse(optarg, uuid_arg);
+			by_uuid = 1;
+			break;
+		default:
+			usage(cmd_subvol_show_usage);
+		}
+	}
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_subvol_show_usage);
 
+	if (by_rootid && by_uuid)
+		usage(cmd_subvol_show_usage);
+
 	memset(&get_ri, 0, sizeof(get_ri));
 	fullpath = realpath(argv[optind], NULL);
 	if (!fullpath) {
@@ -921,7 +955,14 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	ret = get_subvol_info(fullpath, &get_ri);
+	if (by_rootid) {
+		ret = get_subvol_info_by_rootid(fullpath, &get_ri, rootid_arg);
+	} else if (by_uuid) {
+		ret = get_subvol_info_by_uuid(fullpath, &get_ri, uuid_arg);
+	} else {
+		ret = get_subvol_info(fullpath, &get_ri);
+	}
+
 	if (ret) {
 		if (ret < 0) {
 			error("Failed to get subvol info %s: %s",
diff --git a/utils.c b/utils.c
index d2489e70f8d8..250e6cc76cbc 100644
--- a/utils.c
+++ b/utils.c
@@ -2432,6 +2432,58 @@ out:
 	return ret;
 }
 
+int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri, u64 r_id)
+{
+	int fd;
+	int ret;
+	DIR *dirstream = NULL;
+
+	fd = btrfs_open_dir(mnt, &dirstream, 1);
+	if (fd < 0)
+		return -EINVAL;
+
+	memset(get_ri, 0, sizeof(*get_ri));
+	get_ri->root_id = r_id;
+
+	if (r_id == BTRFS_FS_TREE_OBJECTID)
+		ret = btrfs_get_toplevel_subvol(fd, get_ri);
+	else
+		ret = btrfs_get_subvol(fd, get_ri);
+
+	if (ret)
+		error("can't find rootid '%llu' on '%s': %d", r_id, mnt, ret);
+
+	close_file_or_dir(fd, dirstream);
+
+	return ret;
+}
+
+int get_subvol_info_by_uuid(const char *mnt, struct root_info *get_ri, u8 *uuid_arg)
+{
+	int fd;
+	int ret;
+	DIR *dirstream = NULL;
+
+	fd = btrfs_open_dir(mnt, &dirstream, 1);
+	if (fd < 0)
+		return -EINVAL;
+
+	memset(get_ri, 0, sizeof(*get_ri));
+	uuid_copy(get_ri->uuid, uuid_arg);
+
+	ret = btrfs_get_subvol(fd, get_ri);
+	if (ret) {
+		char uuid_parsed[BTRFS_UUID_UNPARSED_SIZE];
+		uuid_unparse(uuid_arg, uuid_parsed);
+		error("can't find uuid '%s' on '%s': %d",
+					uuid_parsed, mnt, ret);
+	}
+
+	close_file_or_dir(fd, dirstream);
+
+	return ret;
+}
+
 /* Set the seed manually */
 void init_rand_seed(u64 seed)
 {
diff --git a/utils.h b/utils.h
index 24d0a200d2b2..b5931a9b3370 100644
--- a/utils.h
+++ b/utils.h
@@ -134,7 +134,10 @@ int test_isdir(const char *path);
 
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path);
 int get_subvol_info(const char *fullpath, struct root_info *get_ri);
-
+int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri,
+							u64 rootid_arg);
+int get_subvol_info_by_uuid(const char *mnt, struct root_info *get_ri,
+							u8 *uuid_arg);
 int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
 const char* btrfs_group_type_str(u64 flag);
 const char* btrfs_group_profile_str(u64 flag);
-- 
2.13.1

