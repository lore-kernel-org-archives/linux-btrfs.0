From: Julian Andres Klode <jak@jak-linux.org>
Subject: [PATCH] Rename convert target to btrfs-convert
Date: Fri, 23 Jan 2009 16:32:26 +0100
Message-ID: <1232724746-27087-1-git-send-email-jak@jak-linux.org>
Cc: Julian Andres Klode <jak@jak-linux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The target builds btrfs-convert and should therefore be
also named this way.

Signed-off-by: Julian Andres Klode <jak@jak-linux.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index e6a332c..3b69db6 100644
--- a/Makefile
+++ b/Makefile
@@ -65,7 +65,7 @@ dir-test: $(objects) dir-test.o
 quick-test: $(objects) quick-test.o
 	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
-convert: $(objects) convert.o
+btrfs-convert: $(objects) convert.o
 	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
 
 manpages:
-- 
1.6.0.6

