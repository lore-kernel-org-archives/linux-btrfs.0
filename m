From: Sergei Trofimovich <slyich@gmail.com>
Subject: [btrfs-progs: PATCH 1/2] Makefile: use $(CC) as a compilers instead of $(CC)/gcc
Date: Mon,  2 Apr 2012 16:10:01 +0300
Message-ID: <1333372202-627-1-git-send-email-slyich@gmail.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 79818e6..ebfd5c8 100644
--- a/Makefile
+++ b/Makefile
@@ -44,13 +44,13 @@ btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
-	gcc $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-find-root: $(objects) find-root.o
-	gcc $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-restore: $(objects) restore.o
-	gcc $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
+	$(CC) $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
 
 btrfsctl: $(objects) btrfsctl.o
 	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
-- 
1.7.8.5

