Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56327 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750937AbeC0Hpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:45:54 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D106AF4B
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:45:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 3/4] btrfs-progs: Remove deprecated btrfs-show-super
Date: Tue, 27 Mar 2018 10:45:45 +0300
Message-Id: <1522136746-13365-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1522136746-13365-1-git-send-email-nborisov@suse.com>
References: <1522136746-13365-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Its function has been superseded by btrfs inspect-internal show-super.
Furthermore the tools is currently not built by default. Just remove
it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 .gitignore                                |  1 -
 Documentation/Makefile.in                 |  1 -
 Documentation/btrfs-select-super.asciidoc |  3 +--
 Documentation/btrfs.asciidoc              |  3 ++-
 Makefile                                  |  2 +-
 btrfs-show-super.c                        | 39 -------------------------------
 6 files changed, 4 insertions(+), 45 deletions(-)
 delete mode 100644 btrfs-show-super.c

diff --git a/.gitignore b/.gitignore
index c0f85fc448c8..06db51f39512 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,7 +27,6 @@ btrfs-convert
 btrfs-find-root
 btrfs-find-root.static
 btrfs-image
-btrfs-show-super
 btrfs-corrupt-block
 btrfs-select-super
 btrfs-calc-size
diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index ee32a50dc068..184647c41940 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -102,7 +102,6 @@ install-man: man
 	$(MV) $(DESTDIR)$(man5dir)/btrfs-man5.5.gz $(DESTDIR)$(man5dir)/btrfs.5.gz
 	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
 	$(LN_S) -f btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz
-	$(LN_S) -f btrfs-inspect-internal.8.gz $(DESTDIR)$(man8dir)/btrfs-show-super.8.gz
 
 uninstall:
 	cd $(DESTDIR)$(man8dir); rm -f btrfs-check.8.gz $(GZ_MAN8)
diff --git a/Documentation/btrfs-select-super.asciidoc b/Documentation/btrfs-select-super.asciidoc
index 6e94a034f482..e3bca98b4f6e 100644
--- a/Documentation/btrfs-select-super.asciidoc
+++ b/Documentation/btrfs-select-super.asciidoc
@@ -21,8 +21,7 @@ The filesystem specified by 'device' must not be mounted.
 NOTE: *Prior to overwriting the primary superblock, please make sure that the backup
 copies are valid!*
 
-To dump a superblock use the *btrfs inspect-internal
-dump-super* command, or the obsolete command *btrfs-show-super*.
+To dump a superblock use the *btrfs inspect-internal dump-super* command.
 
 Then run the check (in the non-repair mode) using the command *btrfs check -s*
 where '-s' specifies the superblock copy to use.
diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
index e89400a2e5b5..0c08950b38fd 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -122,7 +122,8 @@ long (years) depreciation period.
 
 *btrfs-debug-tree*:: moved to *btrfs inspect-internal dump-tree*. Removed from 
 source distribution. 
-*btrfs-show-super*:: moved to *btrfs inspect-internal dump-super*
+*btrfs-show-super*:: moved to *btrfs inspect-internal dump-super*, standalone
+removed.
 *btrfs-zero-log*:: moved to *btrfs rescue zero-log*, standalone removed.
 
 EXIT STATUS
diff --git a/Makefile b/Makefile
index 2a2a76855a26..087289b756ef 100644
--- a/Makefile
+++ b/Makefile
@@ -215,7 +215,7 @@ progs_install = btrfs mkfs.btrfs btrfs-map-logical btrfs-image \
 	btrfs-select-super
 
 # other tools, not built by default
-progs_extra = btrfs-fragments btrfs-calc-size btrfs-show-super
+progs_extra = btrfs-fragments btrfs-calc-size
 
 progs_static = $(foreach p,$(progs),$(p).static)
 
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
deleted file mode 100644
index 4273e42dca3d..000000000000
--- a/btrfs-show-super.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright (C) 2012 STRATO AG.  All rights reserved.
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
-#include "utils.h"
-#include "commands.h"
-#include "help.h"
-
-int main(int argc, char **argv)
-{
-
-	int ret;
-
-	set_argv0(argv);
-
-	warning(
-"\nthe tool has been deprecated, please use 'btrfs inspect-internal dump-super' instead\n");
-
-	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd_inspect_dump_super_usage);
-
-	ret = cmd_inspect_dump_super(argc, argv);
-
-	return ret;
-}
-- 
2.7.4

