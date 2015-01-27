Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37927 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbbA0PGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 10:06:03 -0500
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH 2/2] btrfs-progs: Add --readonly flag
Date: Tue, 27 Jan 2015 15:05:53 +0000
Message-Id: <1422371153-17355-2-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1422371153-17355-1-git-send-email-hugo@carfax.org.uk>
References: <1422371153-17355-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Particularly during support conversations, people get confused about
which options to use with btrfs check. Adding a flag, --readonly, which
implies the default read-only behaviour and which conflicts with the
read-write operations, should help make the behaviour of the tool clear.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-check.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index a1226c6..d4d2e73 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8403,11 +8403,13 @@ out:
 	return bad_roots;
 }
 
-enum { OPT_REPAIR = 257, OPT_INIT_CSUM, OPT_INIT_EXTENT, OPT_CHECK_CSUM };
+enum { OPT_REPAIR = 257, OPT_READONLY, OPT_INIT_CSUM, OPT_INIT_EXTENT,
+	   OPT_CHECK_CSUM };
 
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, OPT_REPAIR },
+	{ "readonly", 0, NULL, OPT_READONLY },
 	{ "init-csum-tree", 0, NULL, OPT_INIT_CSUM },
 	{ "init-extent-tree", 0, NULL, OPT_INIT_EXTENT },
 	{ "check-data-csum", 0, NULL, OPT_CHECK_CSUM },
@@ -8447,6 +8449,7 @@ int cmd_check(int argc, char **argv)
 	u64 num;
 	int option_index = 0;
 	int init_csum_tree = 0;
+	int readonly = 0;
 	int qgroup_report = 0;
 	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
 
@@ -8490,6 +8493,9 @@ int cmd_check(int argc, char **argv)
 				repair = 1;
 				ctree_flags |= OPEN_CTREE_WRITES;
 				break;
+			case OPT_READONLY:
+				readonly = 1;
+				break;
 			case OPT_INIT_CSUM:
 				printf("Creating a new CRC tree\n");
 				init_csum_tree = 1;
@@ -8512,6 +8518,12 @@ int cmd_check(int argc, char **argv)
 	if (check_argc_exact(argc, 1))
 		usage(cmd_check_usage);
 
+	/* This check is the only reason for --readonly to exist */
+	if (readonly && repair) {
+		fprintf(stderr, "Repair options are not compatible with --readonly\n");
+		exit(1);
+	}
+
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 
-- 
2.1.4

