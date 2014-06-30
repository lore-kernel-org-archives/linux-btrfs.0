Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38133 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754042AbaF3D7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 23:59:44 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: move the check_argc_* functions into utils.c
Date: Mon, 30 Jun 2014 11:54:11 +0800
Message-ID: <1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <20140627123528.GC1553@twin.jikos.cz>
References: <20140627123528.GC1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To let the independent tools(e.g. btrfs-image, btrfs-convert, etc.)
share the convenience of check_argc_* functions, just move it into
utils.c.
Also add a new function "set_argv0" to set the correct tool name:
	*btrfs-image*: too few arguments

The original btrfs* tools work as before.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs.c | 41 +----------------------------------------
 utils.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  7 +++++++
 3 files changed, 55 insertions(+), 40 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 25257b6..685455f 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -22,6 +22,7 @@
 #include "crc32c.h"
 #include "commands.h"
 #include "version.h"
+#include "utils.h"
 
 static const char * const btrfs_cmd_group_usage[] = {
 	"btrfs [--help] [--version] <group> [<group>...] <command> [<args>]",
@@ -31,8 +32,6 @@ static const char * const btrfs_cmd_group_usage[] = {
 static const char btrfs_cmd_group_info[] =
 	"Use --help as an argument for information on a specific group or command.";
 
-static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
-
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
 	size_t len = strlen(prefix);
@@ -125,14 +124,6 @@ static void handle_help_options_next_level(const struct cmd_struct *cmd,
 	}
 }
 
-static void fixup_argv0(char **argv, const char *token)
-{
-	int len = strlen(argv0_buf);
-
-	snprintf(argv0_buf + len, sizeof(argv0_buf) - len, " %s", token);
-	argv[0] = argv0_buf;
-}
-
 int handle_command_group(const struct cmd_group *grp, int argc,
 			 char **argv)
 
@@ -154,36 +145,6 @@ int handle_command_group(const struct cmd_group *grp, int argc,
 	return cmd->fn(argc, argv);
 }
 
-int check_argc_exact(int nargs, int expected)
-{
-	if (nargs < expected)
-		fprintf(stderr, "%s: too few arguments\n", argv0_buf);
-	if (nargs > expected)
-		fprintf(stderr, "%s: too many arguments\n", argv0_buf);
-
-	return nargs != expected;
-}
-
-int check_argc_min(int nargs, int expected)
-{
-	if (nargs < expected) {
-		fprintf(stderr, "%s: too few arguments\n", argv0_buf);
-		return 1;
-	}
-
-	return 0;
-}
-
-int check_argc_max(int nargs, int expected)
-{
-	if (nargs > expected) {
-		fprintf(stderr, "%s: too many arguments\n", argv0_buf);
-		return 1;
-	}
-
-	return 0;
-}
-
 static const struct cmd_group btrfs_cmd_group;
 
 static const char * const cmd_help_usage[] = {
diff --git a/utils.c b/utils.c
index 8ce3be9..fd59f58 100644
--- a/utils.c
+++ b/utils.c
@@ -50,11 +50,58 @@
 #include "volumes.h"
 #include "ioctl.h"
 #include "btrfs-list.h"
+#include "commands.h"
 
 #ifndef BLKDISCARD
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
+static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
+
+void fixup_argv0(char **argv, const char *token)
+{
+	int len = strlen(argv0_buf);
+
+	snprintf(argv0_buf + len, sizeof(argv0_buf) - len, " %s", token);
+	argv[0] = argv0_buf;
+}
+
+void set_argv0(char **argv)
+{
+	sprintf(argv0_buf, "%s", argv[0]);
+}
+
+int check_argc_exact(int nargs, int expected)
+{
+	if (nargs < expected)
+		fprintf(stderr, "%s: too few arguments\n", argv0_buf);
+	if (nargs > expected)
+		fprintf(stderr, "%s: too many arguments\n", argv0_buf);
+
+	return nargs != expected;
+}
+
+int check_argc_min(int nargs, int expected)
+{
+	if (nargs < expected) {
+		fprintf(stderr, "%s: too few arguments\n", argv0_buf);
+		return 1;
+	}
+
+	return 0;
+}
+
+int check_argc_max(int nargs, int expected)
+{
+	if (nargs > expected) {
+		fprintf(stderr, "%s: too many arguments\n", argv0_buf);
+		return 1;
+	}
+
+	return 0;
+}
+
+
 /*
  * Discard the given range in one go
  */
diff --git a/utils.h b/utils.h
index ad772c2..f05477a 100644
--- a/utils.h
+++ b/utils.h
@@ -47,6 +47,13 @@
 #define UNITS_DECIMAL			(3)
 #define UNITS_HUMAN			UNITS_BINARY
 
+int check_argc_exact(int nargs, int expected);
+int check_argc_min(int nargs, int expected);
+int check_argc_max(int nargs, int expected);
+
+void fixup_argv0(char **argv, const char *token);
+void set_argv0(char **argv);
+
 int make_btrfs(int fd, const char *device, const char *label,
 	       char *fs_uuid, u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features);
-- 
1.8.1.4

