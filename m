From: slyich@gmail.com
Subject: [btrfs-progs: PATCH] scrub: fix build failure by restoring proper library ordering
Date: Mon,  7 Nov 2011 10:19:33 +0300
Message-ID: <1320650373-15054-1-git-send-email-slyich@gmail.com>
Cc: chris.mason@oracle.com, Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

$ LDFLAGS=-static make
gcc -lpthread -g -O0 -o btrfs btrfs.o btrfs_cmds.o scrub.o \
        ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o -static -luuid
scrub.o: In function `scrub_write_progress':
/home/slyfox/linux-2.6-um-x86_64-fs/btrfs-progs-unstable/scrub.c:752: undefined reference to `pthread_mutex_lock'
/home/slyfox/linux-2.6-um-x86_64-fs/btrfs-progs-unstable/scrub.c:758: undefined reference to `pthread_setcancelstate'
/home/slyfox/linux-2.6-um-x86_64-fs/btrfs-progs-unstable/scrub.c:783: undefined reference to `pthread_mutex_unlock'
/home/slyfox/linux-2.6-um-x86_64-fs/btrfs-progs-unstable/scrub.c:787: undefined reference to `pthread_setcancelstate'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index edee1a0..4d498b9 100644
--- a/Makefile
+++ b/Makefile
@@ -36,8 +36,8 @@ version:
 	bash version.sh
 
 btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
-	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
-		$(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 btrfsctl: $(objects) btrfsctl.o
 	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
-- 
1.7.3.4

