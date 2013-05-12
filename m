Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab3ELPdz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 May 2013 11:33:55 -0400
From: "Richard W.M. Jones" <rjones@redhat.com>
To: mfasheh@suse.de
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] libbtrfs: Set SONAME to "libbtrfs.so.0" (instead of "libbtrfs.so").
Date: Sun, 12 May 2013 16:33:44 +0100
Message-Id: <1368372824-15700-2-git-send-email-rjones@redhat.com>
In-Reply-To: <1368372824-15700-1-git-send-email-rjones@redhat.com>
References: <1368372824-15700-1-git-send-email-rjones@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Richard W.M. Jones" <rjones@redhat.com>

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9c195b3..d2c2e28 100644
--- a/Makefile
+++ b/Makefile
@@ -93,7 +93,7 @@ version.h:
 
 $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so -o libbtrfs.so.0.1
+	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so.0 -o libbtrfs.so.0.1
 
 $(libs_static): $(libbtrfs_objects)
 	@echo "    [AR]     $@"
-- 
1.8.1.4

