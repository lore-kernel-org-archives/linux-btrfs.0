Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbeEPVjE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 17:39:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E4315AF45
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 21:39:02 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 11/18] btrfs-progs: filesystem balance: split out special handling
Date: Wed, 16 May 2018 17:38:44 -0400
Message-Id: <20180516213851.10196-12-jeffm@suse.com>
In-Reply-To: <20180516213851.10196-1-jeffm@suse.com>
References: <20180516213851.10196-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

In preparation to use cmd_struct as the command entry point, we need
to split out the 'filesystem balance' handling to not call cmd_balance
directly.  The reason is that the flags that indicate a command is
hidden are a part of cmd_struct and so we can use a cmd_struct as a
direct alias in another command group and ALSO have it be hidden
without declaring another cmd_struct.

This change has no immediate impact since cmd_balance will still
use its usage information directly from cmds-balance.c.  It will
take effect once we start passing cmd_structs around for usage
information.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-filesystem.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 30a50bf5..01d639e3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1177,6 +1177,18 @@ static int cmd_filesystem_label(int argc, char **argv)
 	}
 }
 
+static const char * const cmd_filesystem_balance_usage[] = {
+	"btrfs filesystem balance [args...] (alias of \"btrfs balance\")",
+	"Please see \"btrfs balance --help\" for more information.",
+	NULL
+};
+
+/* Compatible old "btrfs filesystem balance" command */
+static int cmd_filesystem_balance(int argc, char **argv)
+{
+	return cmd_balance(argc, argv);
+}
+
 static const char filesystem_cmd_group_info[] =
 "overall filesystem tasks and information";
 
@@ -1190,8 +1202,9 @@ const struct cmd_group filesystem_cmd_group = {
 			0 },
 		{ "defragment", cmd_filesystem_defrag,
 			cmd_filesystem_defrag_usage, NULL, 0 },
-		{ "balance", cmd_balance, NULL, &balance_cmd_group,
-			CMD_HIDDEN },
+		{ "balance", cmd_filesystem_balance,
+		   cmd_filesystem_balance_usage, &balance_cmd_group,
+		   CMD_HIDDEN },
 		{ "resize", cmd_filesystem_resize, cmd_filesystem_resize_usage,
 			NULL, 0 },
 		{ "label", cmd_filesystem_label, cmd_filesystem_label_usage,
-- 
2.15.1

