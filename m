Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fau.xxx ([213.133.103.231]:54079 "EHLO om.goeswhere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab3IIWPL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 18:15:11 -0400
Date: Mon, 9 Sep 2013 23:06:38 +0100
From: "Chris West (Faux)" <git@goeswhere.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: fix -Wmissing-noreturn
Message-ID: <20130909220638.GA10113@goeswhere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 btrfs-image.c       | 1 +
 btrfs-map-logical.c | 1 +
 btrfs-zero-log.c    | 1 +
 commands.h          | 6 +++---
 mkfs.c              | 3 +++
 5 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 3ea3730..b76f467 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -142,6 +142,7 @@ struct mdrestore_struct {
 	struct btrfs_fs_info *info;
 };
 
+static void print_usage(void) __attribute__((noreturn));
 static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 				   u64 search, u64 cluster_bytenr);
 static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size);
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index ea0a1ba..51179a3 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -90,6 +90,7 @@ static struct extent_buffer * debug_read_block(struct btrfs_root *root,
 	return eb;
 }
 
+static void print_usage(void) __attribute__((noreturn));
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-map-logical [options] device\n");
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index f249aec..735c139 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -32,6 +32,7 @@
 #include "version.h"
 #include "utils.h"
 
+static void print_usage(void) __attribute__((noreturn));
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-zero-log dev\n");
diff --git a/commands.h b/commands.h
index 65d5fea..fa7a8ce 100644
--- a/commands.h
+++ b/commands.h
@@ -72,12 +72,12 @@ int handle_command_group(const struct cmd_group *grp, int argc,
 /* help.c */
 extern const char * const generic_cmd_help_usage[];
 
-void usage(const char * const *usagestr);
+void usage(const char * const *usagestr) __attribute__((noreturn));
 void usage_command(const struct cmd_struct *cmd, int full, int err);
 void usage_command_group(const struct cmd_group *grp, int all, int err);
 
-void help_unknown_token(const char *arg, const struct cmd_group *grp);
-void help_ambiguous_token(const char *arg, const struct cmd_group *grp);
+void help_unknown_token(const char *arg, const struct cmd_group *grp) __attribute__((noreturn));
+void help_ambiguous_token(const char *arg, const struct cmd_group *grp) __attribute__((noreturn));
 
 void help_command_group(const struct cmd_group *grp, int argc, char **argv);
 
diff --git a/mkfs.c b/mkfs.c
index 1701783..002dd94 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -251,6 +251,8 @@ static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+
+static void print_usage(void) __attribute__((noreturn));
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: mkfs.btrfs [options] dev [ dev ... ]\n");
@@ -273,6 +275,7 @@ static void print_usage(void)
 	exit(1);
 }
 
+static void print_version(void) __attribute__((noreturn));
 static void print_version(void)
 {
 	fprintf(stderr, "mkfs.btrfs, part of %s\n", BTRFS_BUILD_VERSION);
-- 
1.8.4.rc3

