Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:36354 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbcCUOQV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 10:16:21 -0400
Received: by mail-qg0-f49.google.com with SMTP id u110so152856034qge.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 07:16:20 -0700 (PDT)
From: Noah Massey <nmassey@kmbs.konicaminolta.us>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Noah Massey <noah.massey@gmail.com>
Subject: [PATCH] btrfs-progs: build: fix static standalone utilities
Date: Mon, 21 Mar 2016 10:16:07 -0400
Message-Id: <1458569767-6432-1-git-send-email-noah.massey@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit b5e7979 "btrfs-progs: build: extend per-binary objects" allows
the standalone utilities to link against object files shared with the
main binary. However, the btrfs-*.static targets need to be adjusted
to build against the static versions of the common files.

Signed-off-by: Noah Massey <noah.massey@gmail.com>
---
 Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.in b/Makefile.in
index dd30686..c553c5f 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -254,7 +254,7 @@ $(lib_links):
 btrfs-%.static: $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ $@.o $(static_objects) \
-		$($(subst -,_,$(subst .static,,$@)-objects)) \
+		$(patsubst %.o, %.static.o, $($(subst -,_,$(subst .static,,$@)-objects))) \
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) \
 		$($(subst -,_,$(subst .static,,$@)-libs)) $(STATIC_LIBS)
 
-- 
2.7.0

