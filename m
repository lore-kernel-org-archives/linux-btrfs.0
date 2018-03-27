Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750939AbeC0Hpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:45:54 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 838F0AFE0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:45:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 4/4] btrfs-progs: Remove deprecated btrfs-calc-size tool
Date: Tue, 27 Mar 2018 10:45:46 +0300
Message-Id: <1522136746-13365-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1522136746-13365-1-git-send-email-nborisov@suse.com>
References: <1522136746-13365-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Its function has been superseded by btrfs inspect-internal tree-stats.
Just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 .gitignore        |  1 -
 Makefile          |  2 +-
 btrfs-calc-size.c | 39 ---------------------------------------
 3 files changed, 1 insertion(+), 41 deletions(-)
 delete mode 100644 btrfs-calc-size.c

diff --git a/.gitignore b/.gitignore
index 06db51f39512..9e4b7520e709 100644
--- a/.gitignore
+++ b/.gitignore
@@ -29,7 +29,6 @@ btrfs-find-root.static
 btrfs-image
 btrfs-corrupt-block
 btrfs-select-super
-btrfs-calc-size
 btrfs-crc
 btrfstune
 mktables
diff --git a/Makefile b/Makefile
index 087289b756ef..051739b8cbc9 100644
--- a/Makefile
+++ b/Makefile
@@ -215,7 +215,7 @@ progs_install = btrfs mkfs.btrfs btrfs-map-logical btrfs-image \
 	btrfs-select-super
 
 # other tools, not built by default
-progs_extra = btrfs-fragments btrfs-calc-size
+progs_extra = btrfs-fragments
 
 progs_static = $(foreach p,$(progs),$(p).static)
 
diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
deleted file mode 100644
index d2d68ab259eb..000000000000
--- a/btrfs-calc-size.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright (C) 2011 Red Hat.  All rights reserved.
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
-#include "volumes.h"
-#include "utils.h"
-#include "commands.h"
-#include "help.h"
-
-int main(int argc, char **argv)
-{
-	int ret;
-
-	warning(
-"\nthe tool has been deprecated, please use 'btrfs inspect-internal tree-stats' instead\n");
-
-	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd_inspect_tree_stats_usage);
-
-	ret = cmd_inspect_tree_stats(argc, argv);
-
-	btrfs_close_all_devices();
-
-	return ret;
-}
-- 
2.7.4

