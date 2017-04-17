Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24203 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932464AbdDQD0v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:51 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 4/9] btrfs-progs: help: Unbind short help description from btrfs
Date: Mon, 17 Apr 2017 11:26:37 +0800
Message-ID: <20170417032642.30770-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

usage_command_group_short() always binds its description to 'btrfs',
making us unable to this function in other progs.

This patch makes the short description independent, so callers need to
pass the short description by themselves.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs.c | 12 +++++++++++-
 help.c  | 14 +++++++-------
 help.h  |  3 ++-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index f096e780..b3686c4b 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -24,6 +24,15 @@
 #include "utils.h"
 #include "help.h"
 
+static const char * const btrfs_short_desc[] = {
+	"For an overview of a given command use 'btrfs command --help'",
+	"or 'btrfs [command...] --help --full' to print all available options.",
+	"Any command name can be shortened as far as it stays unambiguous,",
+	"however it is recommended to use full command names in scripts.",
+	"All command groups have their manual page named 'btrfs-<group>'.",
+	NULL
+};
+
 static const char * const btrfs_cmd_group_usage[] = {
 	"btrfs [--help] [--version] <group> [<group>...] <command> [<args>]",
 	NULL
@@ -126,7 +135,8 @@ int main(int argc, char **argv)
 			if (!prefixcmp(argv[0], "--"))
 				argv[0] += 2;
 		} else {
-			usage_command_group_short(&btrfs_cmd_group);
+			usage_command_group_short(&btrfs_cmd_group,
+						  btrfs_short_desc);
 			exit(1);
 		}
 	}
diff --git a/help.c b/help.c
index 19b0d357..13c45ffd 100644
--- a/help.c
+++ b/help.c
@@ -262,7 +262,8 @@ static void usage_command_group_internal(const struct cmd_group *grp, int full,
 	}
 }
 
-void usage_command_group_short(const struct cmd_group *grp)
+void usage_command_group_short(const struct cmd_group *grp,
+			       const char * const *short_desc)
 {
 	const char * const *usagestr = grp->usagestr;
 	FILE *outf = stdout;
@@ -298,12 +299,11 @@ void usage_command_group_short(const struct cmd_group *grp)
 		fprintf(outf, "  %-16s  %s\n", cmd->token, cmd->usagestr[1]);
 	}
 
-	fputc('\n', outf);
-	fprintf(stderr, "For an overview of a given command use 'btrfs command --help'\n");
-	fprintf(stderr, "or 'btrfs [command...] --help --full' to print all available options.\n");
-	fprintf(stderr, "Any command name can be shortened as far as it stays unambiguous,\n");
-	fprintf(stderr, "however it is recommended to use full command names in scripts.\n");
-	fprintf(stderr, "All command groups have their manual page named 'btrfs-<group>'.\n");
+	if (short_desc) {
+		fputc('\n', outf);
+		while (*short_desc && **short_desc)
+			fprintf(outf, "%s\n", *short_desc++);
+	}
 }
 
 void usage_command_group(const struct cmd_group *grp, int full, int err)
diff --git a/help.h b/help.h
index 7458e745..9b190fb1 100644
--- a/help.h
+++ b/help.h
@@ -58,7 +58,8 @@ struct cmd_group;
 void usage(const char * const *usagestr) __attribute__((noreturn));
 void usage_command(const struct cmd_struct *cmd, int full, int err);
 void usage_command_group(const struct cmd_group *grp, int all, int err);
-void usage_command_group_short(const struct cmd_group *grp);
+void usage_command_group_short(const struct cmd_group *grp,
+			       const char * const *short_desc);
 
 void help_unknown_token(const char *arg, const struct cmd_group *grp) __attribute__((noreturn));
 void help_ambiguous_token(const char *arg, const struct cmd_group *grp) __attribute__((noreturn));
-- 
2.12.2



