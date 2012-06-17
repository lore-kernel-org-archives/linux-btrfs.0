Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56136 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757850Ab2FQSmR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jun 2012 14:42:17 -0400
Message-ID: <1339958534.1424.6.camel@apu.local>
Subject: Patch: Add subvol current-generation command
From: Fabian Deutsch <fabian.deutsch@gmx.de>
To: linux-btrfs@vger.kernel.org
Date: Sun, 17 Jun 2012 20:42:14 +0200
Content-Type: multipart/mixed; boundary="=-1dQ+4lg2volhID9WDtmE"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-1dQ+4lg2volhID9WDtmE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hey,

this is my first patch against something related to btrfs. The attached
patch adds the subvol current-generation command to retrieve the current
generation of the given subvol. This is inteded to be used with the
subvol find-new command.

After writing this patch I noticed that Sean Reifschneider already
sugested something similar in 2010 [1]. His patch reminded me of adding
a part to the manpage.

Thanks and Greetings
fabian

--
[1] http://markmail.org/thread/iztosuxysjt4zx2b

--=-1dQ+4lg2volhID9WDtmE
Content-Disposition: attachment;
	filename="0001-btrfs-Add-subvol-current-generation-command.patch"
Content-Type: text/x-patch;
	name="0001-btrfs-Add-subvol-current-generation-command.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 8bit

>From d7fd192b7e013701560e9abba7a01bb7dbaade18 Mon Sep 17 00:00:00 2001
From: Fabian Deutsch <fabian.deutsch@gmx.de>
Date: Sat, 16 Jun 2012 22:50:57 +0200
Subject: [PATCH] btrfs: Add subvol current-generation command

Add a command (current-generation) to get the current generation of a subvolume. This is useful in combination with find-new.

Signed-off-by: Fabian Deutsch <fabian.deutsch@gmx.de>
---
 btrfs-list.c     |    7 +++++++
 cmds-subvolume.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in   |    8 ++++++++
 3 Dateien geändert, 58 Zeilen hinzugefügt(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index 5f4a9be..ccbaf44 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -799,6 +799,13 @@ static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
 	return 0;
 }
 
+u64 current_generation(int fd, u64 root_id)
+{
+	u64 max_found = 0;
+	max_found = find_root_gen(fd);
+	return max_found;
+}
+
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 {
 	int ret;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 950fa8f..2a185b1 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -31,6 +31,7 @@
 
 /* btrfs-list.c */
 int list_subvols(int fd, int print_parent, int get_default);
+u64 current_generation(int fd, u64 root_id);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 
 static const char * const subvolume_cmd_group_usage[] = {
@@ -512,6 +513,47 @@ static int cmd_find_new(int argc, char **argv)
 	return 0;
 }
 
+
+static const char * const cmd_current_generation_usage[] = {
+	"btrfs subvolume current-generation <path>",
+	"Get the current generation of the filesystem",
+	NULL
+};
+
+static int cmd_current_generation(int argc, char **argv)
+{
+	int fd;
+	int ret;
+	char *subvol;
+	u64 current_gen;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_current_generation_usage);
+
+	subvol = argv[1];
+
+	ret = test_issubvolume(subvol);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		return 13;
+	}
+
+	fd = open_file_or_dir(subvol);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		return 12;
+	}
+	current_gen = current_generation(fd, 0);
+
+	fprintf(stdout, "%llu\n", current_gen);
+
+	return 0;
+}
+
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -523,6 +565,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "set-default", cmd_subvol_set_default,
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
+		{ "current-generation", cmd_current_generation, cmd_current_generation_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..3c71f57 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,6 +25,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
 .PP
+\fBbtrfs\fP \fBsubvolume current-generation\fP\fI <subvolume>\fP
+.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
@@ -154,6 +156,12 @@ The start position and the number of bytes to deframention can be specified by \
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't 
 use it if you use snapshots, have de-duplicated your data or made copies with 
 \fBcp --reflink\fP.
+.TP
+
+\fBsubvolume current-generation\fR\fI <subvolume>\fR
+Return the current generation used in subvolume \fI<subvolume>\fR. This number can be used with the \fBsubvolume find-new\fR command.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
-- 
1.7.10.4


--=-1dQ+4lg2volhID9WDtmE--

