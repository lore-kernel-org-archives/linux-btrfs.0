Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38993 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752431AbeCVNSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:18:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E80C8ABEC
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 13:18:29 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs-progs: Remove deprecated btrfs-zero-log standalone tool
Date: Thu, 22 Mar 2018 15:18:25 +0200
Message-Id: <1521724707-19180-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Its function has been subsumed by "btrfs rescue zero-log". Remove its
source file and adjust make/tests soruces accordingly.
---
 Makefile                              |  4 +-
 btrfs-zero-log.c                      | 78 -----------------------------------
 tests/misc-tests.sh                   |  1 -
 tests/misc-tests/003-zero-log/test.sh |  6 +--
 4 files changed, 3 insertions(+), 86 deletions(-)
 delete mode 100644 btrfs-zero-log.c

diff --git a/Makefile b/Makefile
index a7726e98947d..2a2a76855a26 100644
--- a/Makefile
+++ b/Makefile
@@ -210,7 +210,7 @@ MAKEOPTS = --no-print-directory Q=$(Q)
 progs = $(progs_install) btrfsck btrfs-corrupt-block
 
 # install only selected
-progs_install = btrfs mkfs.btrfs btrfs-map-logical btrfs-image btrfs-zero-log \
+progs_install = btrfs mkfs.btrfs btrfs-map-logical btrfs-image \
 	btrfs-find-root btrfstune \
 	btrfs-select-super
 
@@ -322,7 +322,7 @@ test-fsck: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune
 	$(Q)bash tests/fsck-tests.sh
 
 test-misc: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune fssum \
-		btrfs-zero-log btrfs-find-root btrfs-select-super btrfs-convert
+		btrfs-find-root btrfs-select-super btrfs-convert
 	@echo "    [TEST]   misc-tests.sh"
 	$(Q)bash tests/misc-tests.sh
 
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
deleted file mode 100644
index 2fce59e98d6e..000000000000
--- a/btrfs-zero-log.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include "kerncompat.h"
-
-#include <stdio.h>
-#include <unistd.h>
-#include "ctree.h"
-#include "disk-io.h"
-#include "transaction.h"
-#include "utils.h"
-#include "help.h"
-
-__attribute__((noreturn)) static void print_usage(void)
-{
-	printf("usage: btrfs-zero-log dev\n");
-	exit(1);
-}
-
-int main(int argc, char **argv)
-{
-	struct btrfs_root *root;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_super_block *sb;
-	int ret;
-
-	set_argv0(argv);
-	if (check_argc_exact(argc - optind, 1))
-		print_usage();
-
-	radix_tree_init();
-
-	printf("WARNING: this utility is deprecated, please use 'btrfs rescue zero-log'\n\n");
-
-	if ((ret = check_mounted(argv[optind])) < 0) {
-		fprintf(stderr, "ERROR: could not check mount status: %s\n", strerror(-ret));
-		goto out;
-	} else if (ret) {
-		fprintf(stderr, "ERROR: %s is currently mounted\n", argv[optind]);
-		ret = -EBUSY;
-		goto out;
-	}
-
-	root = open_ctree(argv[optind], 0, OPEN_CTREE_WRITES | OPEN_CTREE_PARTIAL);
-	if (!root) {
-		fprintf(stderr, "ERROR: cannot open ctree\n");
-		return 1;
-	}
-
-	sb = root->fs_info->super_copy;
-	printf("Clearing log on %s, previous log_root %llu, level %u\n",
-			argv[optind],
-			(unsigned long long)btrfs_super_log_root(sb),
-			(unsigned)btrfs_super_log_root_level(sb));
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(IS_ERR(trans));
-	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
-	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
-	btrfs_commit_transaction(trans, root);
-	close_ctree(root);
-out:
-	return !!ret;
-}
diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index 94703a3ec200..dad397ecaeec 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -46,7 +46,6 @@ check_prereq btrfs-corrupt-block
 check_prereq btrfs-image
 check_prereq btrfstune
 check_prereq btrfs
-check_prereq btrfs-zero-log
 check_prereq btrfs-find-root
 check_prereq btrfs-select-super
 check_kernel_support
diff --git a/tests/misc-tests/003-zero-log/test.sh b/tests/misc-tests/003-zero-log/test.sh
index 9d2940f56851..8b0d0c57eb0e 100755
--- a/tests/misc-tests/003-zero-log/test.sh
+++ b/tests/misc-tests/003-zero-log/test.sh
@@ -30,11 +30,7 @@ test_zero_log()
 		--rootdir $INTERNAL_BIN/Documentation \
 		$TEST_DEV
 	run_check $TOP/btrfs inspect-internal dump-super $TEST_DEV
-	if [ "$1" = 'standalone' ]; then
-		run_check $TOP/btrfs rescue zero-log $TEST_DEV
-	else
-		run_check $TOP/btrfs-zero-log $TEST_DEV
-	fi
+	run_check $TOP/btrfs rescue zero-log $TEST_DEV
 	log_root=$(get_log_root $TEST_DEV)
 	log_root_level=$(get_log_root $TEST_DEV)
 	if [ "$log_root" != 0 ]; then
-- 
2.7.4

