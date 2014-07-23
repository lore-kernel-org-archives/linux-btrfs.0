Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaGWNQY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 09:16:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2D3F3AB07
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 13:16:23 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix build of static target
Date: Wed, 23 Jul 2014 15:16:21 +0200
Message-Id: <1406121381-18611-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user repoted that static buid fails with

utils-lib.static.o: In function `arg_strtou64':
/home/dsterba/labs/btrfs-progs/utils-lib.c:17: multiple definition of `arg_strtou64'
utils-lib.static.o:/home/dsterba/labs/btrfs-progs/utils-lib.c:17: first defined here

utils-lib.o was mistakenly added to linker twice.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 8e14d4837520..3853b8734568 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
-	  utils-lib.o ulist.o qgroup-verify.o
+	  ulist.o qgroup-verify.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
-- 
1.9.0

