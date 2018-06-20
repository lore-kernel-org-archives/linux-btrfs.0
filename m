Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751337AbeFTAir (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 20:38:47 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Paul Jones <paul@pauljones.id.au>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v2 1/2] btrfs-progs: Fix wrong optind re-initialization to allow mixed option and non-option
Date: Wed, 20 Jun 2018 08:38:38 +0800
Message-Id: <20180620003839.10629-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function handle_global_options(), we reset @optind to 1.
However according to man page of getopt(3) NOTES section, if we need to
rescan options later, @optind should be reset to 0 to initialize the
internal variables correctly.

This explains the reason why in cmd_check(), getopt_long() doesn't
handle the following command correctly:
"btrfs check /dev/data/btrfs --check-data-csum"

While mkfs.btrfs handles mixed non-option and option correctly:
"mkfs.btrfs -f /dev/data/disk1 --data raid1 /dev/data/disk2"

Cc: Paul Jones <paul@pauljones.id.au>
Cc: Hugo Mills <hugo@carfax.org.uk>
Fixes: 010ceab56e06 ("btrfs-progs: rework option parser to use getopt for global options")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Instead of resetting @optind at handle_global_options(), reset @optind
  before each later getopt() call. Since there are cases uses @optind and
  expects it to be starting from 1.
---
 cmds-balance.c            | 2 ++
 cmds-device.c             | 3 +++
 cmds-fi-du.c              | 1 +
 cmds-fi-usage.c           | 1 +
 cmds-filesystem.c         | 2 ++
 cmds-inspect-dump-tree.c  | 1 +
 cmds-inspect-tree-stats.c | 1 +
 cmds-inspect.c            | 3 +++
 cmds-qgroup.c             | 3 +++
 cmds-quota.c              | 1 +
 cmds-receive.c            | 1 +
 cmds-replace.c            | 3 +++
 cmds-rescue.c             | 2 ++
 cmds-restore.c            | 1 +
 cmds-send.c               | 1 +
 cmds-subvolume.c          | 6 ++++++
 16 files changed, 32 insertions(+)

diff --git a/cmds-balance.c b/cmds-balance.c
index 0c91bdf13ada..6cc26c358f95 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -528,6 +528,7 @@ static int cmd_balance_start(int argc, char **argv)
 
 	memset(&args, 0, sizeof(args));
 
+	optind = 0;
 	while (1) {
 		enum { GETOPT_VAL_FULL_BALANCE = 256,
 			GETOPT_VAL_BACKGROUND = 257 };
@@ -831,6 +832,7 @@ static int cmd_balance_status(int argc, char **argv)
 	int verbose = 0;
 	int ret;
 
+	optind = 0;
 	while (1) {
 		int opt;
 		static const struct option longopts[] = {
diff --git a/cmds-device.c b/cmds-device.c
index 86459d1b9564..cd689b5017c8 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -57,6 +57,7 @@ static int cmd_device_add(int argc, char **argv)
 	int force = 0;
 	int last_dev;
 
+	optind = 0;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
@@ -267,6 +268,7 @@ static int cmd_device_scan(int argc, char **argv)
 	int all = 0;
 	int ret = 0;
 
+	optind = 0;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
@@ -403,6 +405,7 @@ static int cmd_device_stats(int argc, char **argv)
 	__u64 flags = 0;
 	DIR *dirstream = NULL;
 
+	optind = 0;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 7e6bb7f6a570..4e639f6dc231 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -565,6 +565,7 @@ int cmd_filesystem_du(int argc, char **argv)
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
+	optind = 0;
 	while (1) {
 		static const struct option long_options[] = {
 			{ "summarize", no_argument, NULL, 's'},
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index de7ad668ba2d..cbb3cd191b3d 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -975,6 +975,7 @@ int cmd_filesystem_usage(int argc, char **argv)
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
+	optind = 0;
 	while (1) {
 		int c;
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 30a50bf55e38..06c8311bdfe3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -685,6 +685,7 @@ static int cmd_filesystem_show(int argc, char **argv)
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 0);
 
+	optind = 0;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
@@ -924,6 +925,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	defrag_global_errors = 0;
 	defrag_global_verbose = 0;
 	defrag_global_errors = 0;
+	optind = 0;
 	while(1) {
 		int c = getopt(argc, argv, "vrc::fs:l:t:");
 		if (c < 0)
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 92a2a45b267e..c8acd55a0c3a 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -235,6 +235,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	 * tree blocks as possible.
 	 */
 	open_ctree_flags = OPEN_CTREE_PARTIAL | OPEN_CTREE_NO_BLOCK_GROUPS;
+	optind = 0;
 	while (1) {
 		int c;
 		enum { GETOPT_VAL_FOLLOW = 256 };
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index eced0db9f840..dfa34c52ff5f 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -434,6 +434,7 @@ int cmd_inspect_tree_stats(int argc, char **argv)
 	int opt;
 	int ret = 0;
 
+	optind = 0;
 	while ((opt = getopt(argc, argv, "vb")) != -1) {
 		switch (opt) {
 		case 'v':
diff --git a/cmds-inspect.c b/cmds-inspect.c
index afd7fe48df5c..2fc50c1a2d90 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -94,6 +94,7 @@ static int cmd_inspect_inode_resolve(int argc, char **argv)
 	int ret;
 	DIR *dirstream = NULL;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "v");
 		if (c < 0)
@@ -148,6 +149,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 	char *path_ptr;
 	DIR *dirstream = NULL;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "Pvs:");
 		if (c < 0)
@@ -591,6 +593,7 @@ static int cmd_inspect_min_dev_size(int argc, char **argv)
 	DIR *dirstream = NULL;
 	u64 devid = 1;
 
+	optind = 0;
 	while (1) {
 		int c;
 		enum { GETOPT_VAL_DEVID = 256 };
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 93206900693d..b928edc7c408 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -46,6 +46,7 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 	DIR *dirstream = NULL;
 
 	if (assign) {
+		optind = 0;
 		while (1) {
 			enum { GETOPT_VAL_RESCAN = 256, GETOPT_VAL_NO_RESCAN };
 			static const struct option long_options[] = {
@@ -310,6 +311,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 0);
 
+	optind = 0;
 	while (1) {
 		int c;
 		enum {
@@ -429,6 +431,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	DIR *dirstream = NULL;
 	enum btrfs_util_error err;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "ce");
 		if (c < 0)
diff --git a/cmds-quota.c b/cmds-quota.c
index 745889d12523..c9ea9c0f36ec 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -119,6 +119,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 	DIR *dirstream = NULL;
 	int wait_for_completion = 0;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "sw");
 		if (c < 0)
diff --git a/cmds-receive.c b/cmds-receive.c
index 68123a31cc5c..34d51ef3f301 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1267,6 +1267,7 @@ int cmd_receive(int argc, char **argv)
 	realmnt[0] = 0;
 	fromfile[0] = 0;
 
+	optind = 0;
 	while (1) {
 		int c;
 		enum { GETOPT_VAL_DUMP = 257 };
diff --git a/cmds-replace.c b/cmds-replace.c
index 032a44fcda3c..1fa802845f0e 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -134,6 +134,7 @@ static int cmd_replace_start(int argc, char **argv)
 	u64 srcdev_size;
 	u64 dstdev_size;
 
+	optind = 0;
 	while ((c = getopt(argc, argv, "Brf")) != -1) {
 		switch (c) {
 		case 'B':
@@ -333,6 +334,7 @@ static int cmd_replace_status(int argc, char **argv)
 	int ret;
 	DIR *dirstream = NULL;
 
+	optind = 0;
 	while ((c = getopt(argc, argv, "1")) != -1) {
 		switch (c) {
 		case '1':
@@ -501,6 +503,7 @@ static int cmd_replace_cancel(int argc, char **argv)
 	char *path;
 	DIR *dirstream = NULL;
 
+	optind = 0;
 	while ((c = getopt(argc, argv, "")) != -1) {
 		switch (c) {
 		case '?':
diff --git a/cmds-rescue.c b/cmds-rescue.c
index c40088ad374e..0a1df5b8088b 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -52,6 +52,7 @@ static int cmd_rescue_chunk_recover(int argc, char *argv[])
 	int yes = 0;
 	int verbose = 0;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "yvh");
 		if (c < 0)
@@ -119,6 +120,7 @@ static int cmd_rescue_super_recover(int argc, char **argv)
 	int yes = 0;
 	char *dname;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "vy");
 		if (c < 0)
diff --git a/cmds-restore.c b/cmds-restore.c
index f228acab8276..f124e0f8ef15 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1440,6 +1440,7 @@ int cmd_restore(int argc, char **argv)
 	regex_t match_reg, *mreg = NULL;
 	char reg_err[256];
 
+	optind = 0;
 	while (1) {
 		int opt;
 		enum { GETOPT_VAL_PATH_REGEX = 256 };
diff --git a/cmds-send.c b/cmds-send.c
index c5ecdaa11999..16b9f8d2bf0b 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -508,6 +508,7 @@ int cmd_send(int argc, char **argv)
 	send.dump_fd = fileno(stdout);
 	outname[0] = 0;
 
+	optind = 0;
 	while (1) {
 		enum { GETOPT_VAL_SEND_NO_DATA = 256 };
 		static const struct option long_options[] = {
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 45363a5ab3f8..e7a884af1f5d 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -102,6 +102,7 @@ static int cmd_subvol_create(int argc, char **argv)
 	struct btrfs_qgroup_inherit *inherit = NULL;
 	DIR	*dirstream = NULL;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "c:i:");
 		if (c < 0)
@@ -248,6 +249,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	enum { COMMIT_AFTER = 1, COMMIT_EACH = 2 };
 	enum btrfs_util_error err;
 
+	optind = 0;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
@@ -466,6 +468,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	filter_set = btrfs_list_alloc_filter_set();
 	comparer_set = btrfs_list_alloc_comparer_set();
 
+	optind = 0;
 	while(1) {
 		int c;
 		static const struct option long_options[] = {
@@ -636,6 +639,7 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 	DIR *dirstream1 = NULL, *dirstream2 = NULL;
 
 	memset(&args, 0, sizeof(args));
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "c:i:r");
 		if (c < 0)
@@ -933,6 +937,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	char *subvol_path = NULL;
 	enum btrfs_util_error err;
 
+	optind = 0;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
@@ -1132,6 +1137,7 @@ static int cmd_subvol_sync(int argc, char **argv)
 	int sleep_interval = 1;
 	enum btrfs_util_error err;
 
+	optind = 0;
 	while (1) {
 		int c = getopt(argc, argv, "s:");
 
-- 
2.17.1

