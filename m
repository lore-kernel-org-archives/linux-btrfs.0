Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:58818 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbeDJUDz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 16:03:55 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-btrfs@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] btrfs.static: needs libbtrfsutil
Date: Tue, 10 Apr 2018 23:03:41 +0300
Message-Id: <5023fdf9a4524106ef6fe1d0fdd75ade16dec62c.1523390621.git.baruch@tkos.co.il>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add libbtrfsutil objects to btrfs.static link command. This fixes static
build failure:

utils.static.o: In function `parse_qgroupid':
utils.c:(.text.parse_qgroupid+0xb0): undefined reference to `btrfs_util_is_subvolume'
props.static.o: In function `prop_read_only':
props.c:(.text.prop_read_only+0x70): undefined reference to `btrfs_util_set_subvolume_read_only'
...
Makefile:457: recipe for target 'btrfs.static' failed
make[1]: *** [btrfs.static] Error 1

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 5ba76d2eee40..9b97c36a44a5 100644
--- a/Makefile
+++ b/Makefile
@@ -453,7 +453,7 @@ btrfs: btrfs.o $(objects) $(cmds_objects) $(libs_static)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) $(LIBS_COMP)
 
-btrfs.static: btrfs.static.o $(static_objects) $(static_cmds_objects) $(static_libbtrfs_objects)
+btrfs.static: btrfs.static.o $(static_objects) $(static_cmds_objects) $(static_libbtrfs_objects) $(libbtrfsutil_objects)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS) $(STATIC_LIBS_COMP)
 
-- 
2.16.3

