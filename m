Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ae0-f57.auone-net.jp ([106.187.230.57]:45867 "EHLO
	dmta01.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768Ab3FVGN5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 02:13:57 -0400
Received: from amlmta037.auone-net.jp (amlmta037-MM [10.188.22.95])
	by dmta01.auone-net.jp (au one net mail) with ESMTP id 1F82D560038
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Jun 2013 15:13:43 +0900 (JST)
Date: Sat, 22 Jun 2013 15:13:42 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: btrfs requires version.h
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <51c54096000d1fdf00004a0d00004a10a000000e44ba@amlmta037.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ make btrfs
    [CC]     ctree.o
    [CC]     disk-io.o
    [CC]     radix-tree.o
    [CC]     extent-tree.o
    [CC]     print-tree.o
    [CC]     root-tree.o
    [CC]     dir-item.o
    [CC]     file-item.o
    [CC]     inode-item.o
    [CC]     inode-map.o
    [CC]     extent-cache.o
    [CC]     extent_io.o
    [CC]     volumes.o
    [CC]     utils.o
    [CC]     repair.o
    [CC]     qgroup.o
    [CC]     raid6.o
    [CC]     free-space-cache.o
    [CC]     btrfs.o
btrfs.c:24:21: fatal error: version.h: No such file or directory
 #include "version.h"
                     ^
compilation terminated.
make: *** [btrfs.o] Error 1

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index da7438e..0bca4d7 100644
--- a/Makefile
+++ b/Makefile
@@ -131,7 +131,7 @@ btrfs-%: version.h $(objects) $(libs) btrfs-%.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
 
-btrfs: $(objects) btrfs.o help.o $(cmds_objects) $(libs)
+btrfs: version.h $(objects) btrfs.o help.o $(cmds_objects) $(libs)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
-- 
1.8.3.1

