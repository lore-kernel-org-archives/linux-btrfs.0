Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38999 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752913AbeCVNSc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:18:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 300ADACAD
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 13:18:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs-progs: Remove deprecated btrfs-show-super
Date: Thu, 22 Mar 2018 15:18:26 +0200
Message-Id: <1521724707-19180-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1521724707-19180-1-git-send-email-nborisov@suse.com>
References: <1521724707-19180-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Its function has been superseded by btrfs inspect-internal show-super.
Furthermore the tools is currently not built by default. Just remove
it.
---
 Makefile           |  2 +-
 btrfs-show-super.c | 39 ---------------------------------------
 2 files changed, 1 insertion(+), 40 deletions(-)
 delete mode 100644 btrfs-show-super.c

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

