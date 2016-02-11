Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36861 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbcBKNCM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 08:02:12 -0500
Received: by mail-wm0-f68.google.com with SMTP id 128so10537476wmz.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 05:02:12 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH 1/2] btrfs-progs: clean up unnecessary headers and move radix_tree_init()
Date: Thu, 11 Feb 2016 14:01:55 +0100
Message-Id: <1455195716-16282-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 btrfs-debug-tree.c       | 13 ++-----------
 cmds-inspect-dump-tree.c |  2 --
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 057a715..d6e5a69 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -16,18 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <uuid/uuid.h>
-#include <getopt.h>
-
-#include "kerncompat.h"
-#include "radix-tree.h"
-#include "ctree.h"
 #include "disk-io.h"
-#include "print-tree.h"
-#include "transaction.h"
 #include "volumes.h"
 #include "utils.h"
 #include "commands.h"
@@ -42,6 +31,8 @@ int main(int ac, char **av)
 	if (ac > 1 && !strcmp(av[1], "--help"))
 		usage(cmd_inspect_dump_tree_usage);
 
+	radix_tree_init();
+
 	ret = cmd_inspect_dump_tree(ac, av);
 
 	btrfs_close_all_devices();
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 8a3cf0b..0dab506 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -128,8 +128,6 @@ int cmd_inspect_dump_tree(int ac, char **av)
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
 
-	radix_tree_init();
-
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
-- 
2.7.1

