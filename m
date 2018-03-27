Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56321 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeC0Hpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:45:54 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4995ACD2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:45:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 1/4] btrfs-progs: Remove btrfs-debug-tree command
Date: Tue, 27 Mar 2018 10:45:43 +0300
Message-Id: <1522136746-13365-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is already a replacement in the face of btrfs inspect-internal
dump-tree. And this command is just a simple wrapper around it. Just
remove it and adjust the show-blocks script to call the main btrfs
binary to achieve the same effect.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2 (analogical changes to other patches so changelog is present only in the 
first patch): 
 * Remove tool reference from .gitignore and Documentation/Makefile.in
 * Document that the standalone tools are removed in the STANDALONE section in 
 the documentation.

 .gitignore                   |  1 -
 Documentation/Makefile.in    |  1 -
 Documentation/btrfs.asciidoc |  3 ++-
 Makefile                     |  4 +---
 btrfs-debug-tree.c           | 41 -----------------------------------------
 show-blocks                  |  2 +-
 6 files changed, 4 insertions(+), 48 deletions(-)
 delete mode 100644 btrfs-debug-tree.c

diff --git a/.gitignore b/.gitignore
index 4ec04cb6dcf6..237a45182e8e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,7 +10,6 @@ Documentation/*.gz
 Documentation/*.html
 btrfs
 btrfs.static
-btrfs-debug-tree
 btrfs-map-logical
 btrfs-fragments
 btrfsck
diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index 64947afb3f6f..0a90f803c020 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -103,7 +103,6 @@ install-man: man
 	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
 	$(LN_S) -f btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz
 	$(LN_S) -f btrfs-rescue.8.gz $(DESTDIR)$(man8dir)/btrfs-zero-log.8.gz
-	$(LN_S) -f btrfs-inspect-internal.8.gz $(DESTDIR)$(man8dir)/btrfs-debug-tree.8.gz
 	$(LN_S) -f btrfs-inspect-internal.8.gz $(DESTDIR)$(man8dir)/btrfs-show-super.8.gz
 
 uninstall:
diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
index 8253023444b6..5b328cd18dbf 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -120,7 +120,8 @@ long (years) depreciation period.
 
 Deprecated and obsolete tools:
 
-*btrfs-debug-tree*:: moved to *btrfs inspect-internal dump-tree*
+*btrfs-debug-tree*:: moved to *btrfs inspect-internal dump-tree*. Removed from 
+source distribution. 
 *btrfs-show-super*:: moved to *btrfs inspect-internal dump-super*
 *btrfs-zero-log*:: moved to *btrfs rescue zero-log*
 
diff --git a/Makefile b/Makefile
index 6065522a615f..a7726e98947d 100644
--- a/Makefile
+++ b/Makefile
@@ -210,8 +210,7 @@ MAKEOPTS = --no-print-directory Q=$(Q)
 progs = $(progs_install) btrfsck btrfs-corrupt-block
 
 # install only selected
-progs_install = btrfs mkfs.btrfs btrfs-debug-tree \
-	btrfs-map-logical btrfs-image btrfs-zero-log \
+progs_install = btrfs mkfs.btrfs btrfs-map-logical btrfs-image btrfs-zero-log \
 	btrfs-find-root btrfstune \
 	btrfs-select-super
 
@@ -229,7 +228,6 @@ endif
 btrfs_convert_cflags = -DBTRFSCONVERT_EXT2=$(BTRFSCONVERT_EXT2)
 btrfs_convert_cflags += -DBTRFSCONVERT_REISERFS=$(BTRFSCONVERT_REISERFS)
 btrfs_fragments_libs = -lgd -lpng -ljpeg -lfreetype
-btrfs_debug_tree_objects = cmds-inspect-dump-tree.o
 btrfs_show_super_objects = cmds-inspect-dump-super.o
 btrfs_calc_size_objects = cmds-inspect-tree-stats.o
 cmds_restore_cflags = -DBTRFSRESTORE_ZSTD=$(BTRFSRESTORE_ZSTD)
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
deleted file mode 100644
index 7bee018f604e..000000000000
--- a/btrfs-debug-tree.c
+++ /dev/null
@@ -1,41 +0,0 @@
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
-#include "disk-io.h"
-#include "volumes.h"
-#include "utils.h"
-#include "commands.h"
-#include "help.h"
-
-int main(int argc, char **argv)
-{
-	int ret;
-
-	set_argv0(argv);
-
-	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd_inspect_dump_tree_usage);
-
-	radix_tree_init();
-
-	ret = cmd_inspect_dump_tree(argc, argv);
-
-	btrfs_close_all_devices();
-
-	return ret;
-}
diff --git a/show-blocks b/show-blocks
index 49e1770e5bd0..3876b2acfa74 100755
--- a/show-blocks
+++ b/show-blocks
@@ -108,7 +108,7 @@ from pylab import *
     return X
 
 def run_debug_tree(device):
-    p = os.popen('btrfs-debug-tree -e ' + device)
+    p = os.popen('btrfs inspect-internal dump-tree -e ' + device)
     data = loaddata(p)
     return data
 
-- 
2.7.4

