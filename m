Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-02.aalto.fi ([130.233.228.121]:59309 "EHLO
	smtp-out-02.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3KKQck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Nov 2013 11:32:40 -0500
From: Emil Karlson <jekarlson@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Emil Karlson <jekarlson@gmail.com>
Subject: [PATCH v2] btrfs-progs: remove extra uuid-tree.o in objects
Date: Mon, 11 Nov 2013 18:22:24 +0200
Message-Id: <1384186944-3808-1-git-send-email-jekarlson@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes static compile target of btrfs-progs.

Signed-off-by: Emil Karlson <jekarlson@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 4e33648..4604b1f 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@ CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o uuid-tree.o list_sort.o
+	  qgroup.o raid6.o free-space-cache.o list_sort.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
-- 
1.8.3.2

