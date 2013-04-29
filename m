Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:27788 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab3D2IZv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 04:25:51 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp4) (RZmta 31.27 OK)
	with ESMTP id 6003dap3SGtxmS for <linux-btrfs@vger.kernel.org>;
	Mon, 29 Apr 2013 10:25:48 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: Add uuid-tree.o to libbtrfs.a
Date: Mon, 29 Apr 2013 10:25:48 +0200
Message-Id: <1367223948-11947-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since send-utils.o needs it and send-utils.o is part of the exported
libbtrfs functionality.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 98aa87e..589c60d 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o
-libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
+libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
+		   uuid-tree.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
 	       extent_io.h ioctl.h ctree.h
-- 
1.8.2.1

