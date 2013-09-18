Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3IRQTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 12:19:35 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1C7D1A535B
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 18:19:34 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: look up the containing tree root id
Date: Wed, 18 Sep 2013 18:19:30 +0200
Message-Id: <1379521170-9258-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Find the tree id of the containing subvolume for a given file or
directory. For subvolume return it's own id.

$ btrfs inspect-internal rootid <path>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-inspect.c |   38 ++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in |    9 +++++++++
 utils.c        |   30 ++++++++++++++++++++++++++++++
 utils.h        |    2 ++
 4 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index bdebf7d..f0c8e3d 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -301,6 +301,43 @@ out:
 	return ret ? 1 : 0;
 }
 
+static const char* const cmd_rootid_usage[] = {
+	"btrfs inspect-internal rootid <path>",
+	"Get tree ID of the containing subvolume of path.",
+	NULL
+};
+
+static int cmd_rootid(int argc, char **argv)
+{
+	int ret;
+	int fd = -1;
+	u64 rootid;
+	DIR *dirstream = NULL;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_rootid_usage);
+
+	fd = open_file_or_dir(argv[1], &dirstream);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", argv[1]);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = lookup_ino_rootid(fd, &rootid);
+	if (ret) {
+		fprintf(stderr, "%s: rootid failed with ret=%d\n",
+			argv[0], ret);
+		goto out;
+	}
+
+	printf("%llu\n", (unsigned long long)rootid);
+out:
+	close_file_or_dir(fd, dirstream);
+
+	return !!ret;
+}
+
 const struct cmd_group inspect_cmd_group = {
 	inspect_cmd_group_usage, NULL, {
 		{ "inode-resolve", cmd_inode_resolve, cmd_inode_resolve_usage,
@@ -309,6 +346,7 @@ const struct cmd_group inspect_cmd_group = {
 			cmd_logical_resolve_usage, NULL, 0 },
 		{ "subvolid-resolve", cmd_subvolid_resolve,
 			cmd_subvolid_resolve_usage, NULL, 0 },
+		{ "rootid", cmd_rootid, cmd_rootid_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 0b69ce2..be4a6b2 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -80,6 +80,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBinspect-internal subvolid-resolve\fP \fI<subvolid>\fP \fI<path>\fP
 .PP
+\fBbtrfs\fP \fBinspect-internal rootid\fP \fI<path>\fP
+.PP
 .PP
 \fBbtrfs\fP \fBsend\fP [-v] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP
 .PP
@@ -582,6 +584,13 @@ not enough to read all the resolved results. The max value one can set is 64k.
 Get file system paths for the given subvolume ID.
 .TP
 
+\fBinspect-internal rootid\fP \fI<path>\fP
+For a given file or directory, return the containing tree root id. For a
+subvolume return it's own tree id.
+
+The result is undefined for the so-called empty subvolumes (identified by inode number 2).
+.TP
+
 \fBsend\fP [-v] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP
 Send the subvolume to stdout.
 Sends the subvolume specified by \fI<subvol>\fR to stdout.
diff --git a/utils.c b/utils.c
index 5fa193b..8aecc4a 100644
--- a/utils.c
+++ b/utils.c
@@ -1975,3 +1975,33 @@ int ask_user(char *question)
 	       (answer = strtok_r(buf, " \t\n\r", &saveptr)) &&
 	       (!strcasecmp(answer, "yes") || !strcasecmp(answer, "y"));
 }
+
+/*
+ * For a given:
+ * - file or directory return the containing tree root id
+ * - subvolume return it's own tree id
+ * - BTRFS_EMPTY_SUBVOL_DIR_OBJECTID (directory with ino == 2) the result is
+ *   undefined and function returns -1
+ */
+int lookup_ino_rootid(int fd, u64 *rootid)
+{
+	struct btrfs_ioctl_ino_lookup_args args;
+	int ret;
+	int e;
+
+	memset(&args, 0, sizeof(args));
+	args.treeid = 0;
+	args.objectid = BTRFS_FIRST_FREE_OBJECTID;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
+	e = errno;
+	if (ret) {
+		fprintf(stderr, "ERROR: Failed to lookup root id - %s\n",
+			strerror(e));
+		return ret;
+	}
+
+	*rootid = args.treeid;
+
+	return 0;
+}
diff --git a/utils.h b/utils.h
index fdef3f0..19f028f 100644
--- a/utils.h
+++ b/utils.h
@@ -81,4 +81,6 @@ int is_vol_small(char *file);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
 int ask_user(char *question);
+int lookup_ino_rootid(int fd, u64 *rootid);
+
 #endif
-- 
1.7.9

