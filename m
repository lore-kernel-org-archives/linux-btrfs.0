From: Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] Btrfs-progs: Relocate -lpthread in makefile
Date: Mon, 14 Nov 2011 16:47:28 +0100
Message-ID: <1321285648-16237-1-git-send-email-arnd@arndnet.de>
Cc: chris.mason@oracle.com, Arnd Hannemann <arnd@arndnet.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes the following compile error when compiled with
gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3):

gcc -lpthread -g -O0 -o btrfs btrfs.o btrfs_cmds.o scrub.o \
		ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o  -luuid
scrub.o: In function `scrub_start':
/home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1342: undefined reference to `pthread_create'
/home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1360: undefined reference to `pthread_create'
/home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1374: undefined reference to `pthread_join'
/home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1430: undefined reference to `pthread_cancel'
/home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1432: undefined reference to `pthread_join'
collect2: ld returned 1 exit status
make: *** [btrfs] Error 1

The gcc man page says: "[...] the placement of the -l option is significant." so lets include -lpthread together with the usual $(LIBS)

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 96e2002..834be47 100644
--- a/Makefile
+++ b/Makefile
@@ -37,8 +37,8 @@ version:
 	bash version.sh
 
 btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
-	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
-		$(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
 	gcc $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
-- 
1.7.5.4

