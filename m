Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924AbaGXQWX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 12:22:23 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B171CAB43
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 16:22:21 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: add zero-log to rescue subcommand
Date: Thu, 24 Jul 2014 18:22:20 +0200
Message-Id: <1406218940-8003-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy the functionality of standalone btrfs-zero-log to the main tool.
The standalone utility will be removed later.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-rescue.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index f20a2068a16b..d76a879d543a 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -19,6 +19,9 @@
 #include "kerncompat.h"
 
 #include <getopt.h>
+#include "ctree.h"
+#include "transaction.h"
+#include "disk-io.h"
 #include "commands.h"
 #include "utils.h"
 
@@ -149,11 +152,55 @@ int cmd_super_recover(int argc, char **argv)
 	return ret;
 }
 
+const char * const cmd_rescue_zero_log_usage[] = {
+	"btrfs rescue zero-log <device>",
+	"Clear the tree log. Usable if it's corrupted and prevents mount.",
+	"",
+	NULL
+};
+
+int cmd_rescue_zero_log(int argc, char **argv)
+{
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+	char *devname;
+	int ret;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_rescue_zero_log_usage);
+
+	devname = argv[optind];
+	ret = check_mounted(devname);
+	if (ret < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
+		return 1;
+	} else if (ret) {
+		fprintf(stderr, "%s is currently mounted. Aborting.\n", devname);
+		return 1;
+	}
+
+	root = open_ctree(devname, 0, OPEN_CTREE_WRITES);
+	if (!root) {
+		fprintf(stderr, "Could not open ctree\n");
+		return 1;
+	}
+
+	printf("Clearing log on %s\n", devname);
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
+	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
+	btrfs_commit_transaction(trans, root);
+	close_ctree(root);
+
+	return 0;
+}
+
 const struct cmd_group rescue_cmd_group = {
 	rescue_cmd_group_usage, NULL, {
 		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
 		{ "super-recover", cmd_super_recover, cmd_super_recover_usage, NULL, 0},
-		{ 0, 0, 0, 0, 0 }
+		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
+		NULL_CMD_STRUCT
 	}
 };
 
-- 
1.9.0

