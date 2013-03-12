Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vimg1.rdg.ac.uk ([134.225.1.81]:36212 "EHLO vimg1.rdg.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab3CLQJk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 12:09:40 -0400
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <h.r.mills@reading.ac.uk>, Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] btrfs-progs: add Makefile rule for static build of btrfs-find-root
Date: Tue, 12 Mar 2013 15:44:11 +0000
Message-Id: <1363103051-10207-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Hugo Mills <h.r.mills@reading.ac.uk>

btrfs-find-root isn't yet integrated into the main btrfs tool, and is
an important recovery tool, so it deserves to be built as a static
binary.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index d102dee..c519d21 100644
--- a/Makefile
+++ b/Makefile
@@ -86,7 +86,7 @@ all: version.h $(progs) manpages
 # NOTE: For static compiles, you need to have all the required libs
 # 	static equivalent available
 #
-static: version.h $(libs) btrfs.static
+static: version.h $(libs) btrfs.static btrfs-find-root.static
 
 version.h:
 	$(Q)bash version.sh
@@ -122,6 +122,10 @@ btrfs-find-root: $(objects) $(libs) find-root.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
 
+btrfs-find-root.static: $(static_objects) $(libs) find-root.static.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs-find-root.static find-root.static.o $(static_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
+
 btrfsctl: $(objects) $(libs) btrfsctl.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
-- 
1.7.10.4

