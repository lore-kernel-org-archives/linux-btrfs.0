From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/4] btrfs-progs: Move files around
Date: Sun, 31 Jan 2010 19:51:35 +0530
Message-ID: <1264947698-32371-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Build libbtrfs.a and link against that for the commands

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Makefile                                        |   72 +++----------------
 lib/Makefile                                    |   47 ++++++++++++
 bit-radix.c => lib/bit-radix.c                  |    0
 bit-radix.h => lib/bit-radix.h                  |    0
 crc32c.c => lib/crc32c.c                        |    0
 crc32c.h => lib/crc32c.h                        |    0
 ctree.c => lib/ctree.c                          |    0
 ctree.h => lib/ctree.h                          |    0
 dir-item.c => lib/dir-item.c                    |    0
 disk-io.c => lib/disk-io.c                      |    0
 disk-io.h => lib/disk-io.h                      |    0
 extent-cache.c => lib/extent-cache.c            |    0
 extent-cache.h => lib/extent-cache.h            |    0
 extent-tree.c => lib/extent-tree.c              |    0
 extent_io.c => lib/extent_io.c                  |    0
 extent_io.h => lib/extent_io.h                  |    0
 file-item.c => lib/file-item.c                  |    0
 hash.h => lib/hash.h                            |    0
 inode-item.c => lib/inode-item.c                |    0
 inode-map.c => lib/inode-map.c                  |    0
 ioctl.h => lib/ioctl.h                          |    0
 kerncompat.h => lib/kerncompat.h                |    0
 list.h => lib/list.h                            |    0
 print-tree.c => lib/print-tree.c                |    0
 print-tree.h => lib/print-tree.h                |    0
 radix-tree.c => lib/radix-tree.c                |    0
 radix-tree.h => lib/radix-tree.h                |    0
 rbtree.c => lib/rbtree.c                        |    0
 rbtree.h => lib/rbtree.h                        |    0
 root-tree.c => lib/root-tree.c                  |    0
 transaction.h => lib/transaction.h              |    0
 utils.c => lib/utils.c                          |    0
 utils.h => lib/utils.h                          |    0
 volumes.c => lib/volumes.c                      |    0
 volumes.h => lib/volumes.h                      |    0
 misc/Makefile                                   |   79 ++++++++++++++++++++
 bcp => misc/bcp                                 |    0
 btrfs-image.c => misc/btrfs-image.c             |    0
 btrfs-map-logical.c => misc/btrfs-map-logical.c |    0
 btrfs-show.c => misc/btrfs-show.c               |    0
 btrfs-vol.c => misc/btrfs-vol.c                 |    0
 btrfsck.c => misc/btrfsck.c                     |    0
 btrfsctl.c => misc/btrfsctl.c                   |    0
 btrfstune.c => misc/btrfstune.c                 |    0
 convert.c => misc/convert.c                     |    0
 debug-tree.c => misc/debug-tree.c               |    0
 mkfs.c => misc/mkfs.c                           |    0
 version.sh => misc/version.sh                   |    0
 tests/Makefile                                  |   88 +++++++++++++++++++++++
 dir-test.c => tests/dir-test.c                  |    0
 hasher.c => tests/hasher.c                      |    0
 quick-test.c => tests/quick-test.c              |    0
 random-test.c => tests/random-test.c            |    0
 show-blocks => tests/show-blocks                |    0
 54 files changed, 223 insertions(+), 63 deletions(-)
 create mode 100644 lib/Makefile
 rename bit-radix.c => lib/bit-radix.c (100%)
 rename bit-radix.h => lib/bit-radix.h (100%)
 rename crc32c.c => lib/crc32c.c (100%)
 rename crc32c.h => lib/crc32c.h (100%)
 rename ctree.c => lib/ctree.c (100%)
 rename ctree.h => lib/ctree.h (100%)
 rename dir-item.c => lib/dir-item.c (100%)
 rename disk-io.c => lib/disk-io.c (100%)
 rename disk-io.h => lib/disk-io.h (100%)
 rename extent-cache.c => lib/extent-cache.c (100%)
 rename extent-cache.h => lib/extent-cache.h (100%)
 rename extent-tree.c => lib/extent-tree.c (100%)
 rename extent_io.c => lib/extent_io.c (100%)
 rename extent_io.h => lib/extent_io.h (100%)
 rename file-item.c => lib/file-item.c (100%)
 rename hash.h => lib/hash.h (100%)
 rename inode-item.c => lib/inode-item.c (100%)
 rename inode-map.c => lib/inode-map.c (100%)
 rename ioctl.h => lib/ioctl.h (100%)
 rename kerncompat.h => lib/kerncompat.h (100%)
 rename list.h => lib/list.h (100%)
 rename print-tree.c => lib/print-tree.c (100%)
 rename print-tree.h => lib/print-tree.h (100%)
 rename radix-tree.c => lib/radix-tree.c (100%)
 rename radix-tree.h => lib/radix-tree.h (100%)
 rename rbtree.c => lib/rbtree.c (100%)
 rename rbtree.h => lib/rbtree.h (100%)
 rename root-tree.c => lib/root-tree.c (100%)
 rename transaction.h => lib/transaction.h (100%)
 rename utils.c => lib/utils.c (100%)
 rename utils.h => lib/utils.h (100%)
 rename volumes.c => lib/volumes.c (100%)
 rename volumes.h => lib/volumes.h (100%)
 create mode 100644 misc/Makefile
 rename bcp => misc/bcp (100%)
 mode change 100755 => 100644
 rename btrfs-image.c => misc/btrfs-image.c (100%)
 rename btrfs-map-logical.c => misc/btrfs-map-logical.c (100%)
 rename btrfs-show.c => misc/btrfs-show.c (100%)
 rename btrfs-vol.c => misc/btrfs-vol.c (100%)
 rename btrfsck.c => misc/btrfsck.c (100%)
 rename btrfsctl.c => misc/btrfsctl.c (100%)
 rename btrfstune.c => misc/btrfstune.c (100%)
 rename convert.c => misc/convert.c (100%)
 rename debug-tree.c => misc/debug-tree.c (100%)
 rename mkfs.c => misc/mkfs.c (100%)
 rename version.sh => misc/version.sh (100%)
 create mode 100644 tests/Makefile
 rename dir-test.c => tests/dir-test.c (100%)
 rename hasher.c => tests/hasher.c (100%)
 rename quick-test.c => tests/quick-test.c (100%)
 rename random-test.c => tests/random-test.c (100%)
 rename show-blocks => tests/show-blocks (100%)
 mode change 100755 => 100644

diff --git a/Makefile b/Makefile
index 02f881e..a30c212 100644
--- a/Makefile
+++ b/Makefile
@@ -1,11 +1,6 @@
 CC=gcc
 AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
 CFLAGS = -g -Werror -Os
-objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
-	  root-tree.o dir-item.o file-item.o inode-item.o \
-	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o
-
 #
 CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 		-Wuninitialized -Wshadow -Wundef
@@ -16,8 +11,7 @@ prefix ?= /usr/local
 bindir = $(prefix)/bin
 LIBS=-luuid
 
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
-	btrfs-map-logical
+SUBDIRS=lib misc man
 
 # make C=1 to enable sparse
 ifdef C
@@ -31,60 +25,12 @@ endif
 	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
 
 
-all: version $(progs) manpages
-
-version:
-	bash version.sh
-
-btrfsctl: $(objects) btrfsctl.o
-	gcc $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-vol: $(objects) btrfs-vol.o
-	gcc $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-show: $(objects) btrfs-show.o
-	gcc $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfsck: $(objects) btrfsck.o
-	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
-
-mkfs.btrfs: $(objects) mkfs.o
-	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
-
-btrfs-debug-tree: $(objects) debug-tree.o
-	gcc $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
-
-btrfstune: $(objects) btrfstune.o
-	gcc $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
-
-btrfs-map-logical: $(objects) btrfs-map-logical.o
-	gcc $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
-
-btrfs-image: $(objects) btrfs-image.o
-	gcc $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
-
-dir-test: $(objects) dir-test.o
-	gcc $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
-
-quick-test: $(objects) quick-test.o
-	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
-
-convert: $(objects) convert.o
-	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
-
-manpages:
-	cd man; make
-
-install-man:
-	cd man; make install
-
-clean :
-	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
-	cd man; make clean
-
-install: $(progs) install-man
-	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
-	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
-	if [ -e btrfs-convert ]; then $(INSTALL) btrfs-convert $(DESTDIR)$(bindir); fi
+all clean install:
+	@for subdir in $(SUBDIRS); do \
+	  if test -d $$subdir ; then \
+	    target=`echo $@`; \
+	    echo making $$target in $$subdir; \
+	    (cd $$subdir && $(MAKE) $$target) || exit 1; \
+	  fi ; \
+	done
 
--include .*.d
diff --git a/lib/Makefile b/lib/Makefile
new file mode 100644
index 0000000..7ece415
--- /dev/null
+++ b/lib/Makefile
@@ -0,0 +1,47 @@
+CC=gcc
+AR = ar
+ARGEN = $(AR) rc
+RANLIB = ranlib
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+CFLAGS = -g -Werror -Os
+objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
+	  root-tree.o dir-item.o file-item.o inode-item.o \
+	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
+	  volumes.o utils.o
+
+#
+CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
+		-Wuninitialized -Wshadow -Wundef
+DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+
+INSTALL= install
+prefix ?= /usr/local
+libdir = $(prefix)/lib/
+
+
+# make C=1 to enable sparse
+ifdef C
+	check=sparse $(CHECKFLAGS)
+else
+	check=ls
+endif
+
+.c.o:
+	$(check) $<
+	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+all: libbtrfs.a
+
+libbtrfs.a: $(objects)
+	$(ARGEN) $@ $(objects)
+	$(RANLIB) $@
+
+clean :
+	rm -f $(progs) *.o .*.d
+	rm -f libbtrfs.a
+
+install: $(progs)
+	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
+	$(INSTALL) libbtrfs.a $(DESTDIR)$(libdir)
+
+-include .*.d
diff --git a/bit-radix.c b/lib/bit-radix.c
similarity index 100%
rename from bit-radix.c
rename to lib/bit-radix.c
diff --git a/bit-radix.h b/lib/bit-radix.h
similarity index 100%
rename from bit-radix.h
rename to lib/bit-radix.h
diff --git a/crc32c.c b/lib/crc32c.c
similarity index 100%
rename from crc32c.c
rename to lib/crc32c.c
diff --git a/crc32c.h b/lib/crc32c.h
similarity index 100%
rename from crc32c.h
rename to lib/crc32c.h
diff --git a/ctree.c b/lib/ctree.c
similarity index 100%
rename from ctree.c
rename to lib/ctree.c
diff --git a/ctree.h b/lib/ctree.h
similarity index 100%
rename from ctree.h
rename to lib/ctree.h
diff --git a/dir-item.c b/lib/dir-item.c
similarity index 100%
rename from dir-item.c
rename to lib/dir-item.c
diff --git a/disk-io.c b/lib/disk-io.c
similarity index 100%
rename from disk-io.c
rename to lib/disk-io.c
diff --git a/disk-io.h b/lib/disk-io.h
similarity index 100%
rename from disk-io.h
rename to lib/disk-io.h
diff --git a/extent-cache.c b/lib/extent-cache.c
similarity index 100%
rename from extent-cache.c
rename to lib/extent-cache.c
diff --git a/extent-cache.h b/lib/extent-cache.h
similarity index 100%
rename from extent-cache.h
rename to lib/extent-cache.h
diff --git a/extent-tree.c b/lib/extent-tree.c
similarity index 100%
rename from extent-tree.c
rename to lib/extent-tree.c
diff --git a/extent_io.c b/lib/extent_io.c
similarity index 100%
rename from extent_io.c
rename to lib/extent_io.c
diff --git a/extent_io.h b/lib/extent_io.h
similarity index 100%
rename from extent_io.h
rename to lib/extent_io.h
diff --git a/file-item.c b/lib/file-item.c
similarity index 100%
rename from file-item.c
rename to lib/file-item.c
diff --git a/hash.h b/lib/hash.h
similarity index 100%
rename from hash.h
rename to lib/hash.h
diff --git a/inode-item.c b/lib/inode-item.c
similarity index 100%
rename from inode-item.c
rename to lib/inode-item.c
diff --git a/inode-map.c b/lib/inode-map.c
similarity index 100%
rename from inode-map.c
rename to lib/inode-map.c
diff --git a/ioctl.h b/lib/ioctl.h
similarity index 100%
rename from ioctl.h
rename to lib/ioctl.h
diff --git a/kerncompat.h b/lib/kerncompat.h
similarity index 100%
rename from kerncompat.h
rename to lib/kerncompat.h
diff --git a/list.h b/lib/list.h
similarity index 100%
rename from list.h
rename to lib/list.h
diff --git a/print-tree.c b/lib/print-tree.c
similarity index 100%
rename from print-tree.c
rename to lib/print-tree.c
diff --git a/print-tree.h b/lib/print-tree.h
similarity index 100%
rename from print-tree.h
rename to lib/print-tree.h
diff --git a/radix-tree.c b/lib/radix-tree.c
similarity index 100%
rename from radix-tree.c
rename to lib/radix-tree.c
diff --git a/radix-tree.h b/lib/radix-tree.h
similarity index 100%
rename from radix-tree.h
rename to lib/radix-tree.h
diff --git a/rbtree.c b/lib/rbtree.c
similarity index 100%
rename from rbtree.c
rename to lib/rbtree.c
diff --git a/rbtree.h b/lib/rbtree.h
similarity index 100%
rename from rbtree.h
rename to lib/rbtree.h
diff --git a/root-tree.c b/lib/root-tree.c
similarity index 100%
rename from root-tree.c
rename to lib/root-tree.c
diff --git a/transaction.h b/lib/transaction.h
similarity index 100%
rename from transaction.h
rename to lib/transaction.h
diff --git a/utils.c b/lib/utils.c
similarity index 100%
rename from utils.c
rename to lib/utils.c
diff --git a/utils.h b/lib/utils.h
similarity index 100%
rename from utils.h
rename to lib/utils.h
diff --git a/volumes.c b/lib/volumes.c
similarity index 100%
rename from volumes.c
rename to lib/volumes.c
diff --git a/volumes.h b/lib/volumes.h
similarity index 100%
rename from volumes.h
rename to lib/volumes.h
diff --git a/misc/Makefile b/misc/Makefile
new file mode 100644
index 0000000..4a39c80
--- /dev/null
+++ b/misc/Makefile
@@ -0,0 +1,79 @@
+CC=gcc
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+CFLAGS = -g -Werror -Os -I../lib/
+#
+CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
+		-Wuninitialized -Wshadow -Wundef
+DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+
+INSTALL= install
+prefix ?= /usr/local
+bindir = $(prefix)/bin
+LIBS=-luuid
+TOPDIR=../
+
+progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
+	btrfs-map-logical
+
+# make C=1 to enable sparse
+ifdef C
+	check=sparse $(CHECKFLAGS)
+else
+	check=ls
+endif
+
+.c.o:
+	$(check) $<
+	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+all: version $(progs)
+
+version:
+	bash version.sh
+
+btrfsctl: $(TOPDIR)/lib/libbtrfs.a btrfsctl.o
+	gcc $(CFLAGS) -static -o btrfsctl btrfsctl.o $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
+
+btrfs-vol: $(TOPDIR)/lib/libbtrfs.a btrfs-vol.o
+	gcc $(CFLAGS) -o btrfs-vol btrfs-vol.o $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
+
+btrfs-show: $(TOPDIR)/lib/libbtrfs.a btrfs-show.o
+	gcc $(CFLAGS) -o btrfs-show btrfs-show.o $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
+
+btrfsck: $(TOPDIR)/lib/libbtrfs.a btrfsck.o
+	gcc $(CFLAGS) -o btrfsck btrfsck.o $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
+
+mkfs.btrfs: $(TOPDIR)/lib/libbtrfs.a mkfs.o
+	gcc $(CFLAGS) -o mkfs.btrfs mkfs.o  $(TOPDIR)/lib/libbtrfs.a  $(LDFLAGS) $(LIBS)
+
+btrfs-debug-tree: $(TOPDIR)/lib/libbtrfs.a debug-tree.o
+	gcc $(CFLAGS) -o btrfs-debug-tree debug-tree.o $(TOPDIR)/lib/libbtrfs.a  $(LDFLAGS) $(LIBS)
+
+btrfstune: $(TOPDIR)/lib/libbtrfs.a btrfstune.o
+	gcc $(CFLAGS) -o btrfstune btrfstune.o $(TOPDIR)/lib/libbtrfs.a  $(LDFLAGS) $(LIBS)
+
+btrfs-map-logical: $(TOPDIR)/lib/libbtrfs.a btrfs-map-logical.o
+	gcc $(CFLAGS) -o btrfs-map-logical btrfs-map-logical.o $(TOPDIR)/lib/libbtrfs.a  $(LDFLAGS) $(LIBS)
+
+btrfs-image: $(TOPDIR)/lib/libbtrfs.a btrfs-image.o
+	gcc $(CFLAGS) -o btrfs-image btrfs-image.o $(TOPDIR)/lib/libbtrfs.a  -lpthread -lz $(LDFLAGS) $(LIBS)
+
+dir-test: $(TOPDIR)/lib/libbtrfs.a dir-test.o
+	gcc $(CFLAGS) -o dir-test dir-test.o $(TOPDIR)/lib/libbtrfs.a  $(LDFLAGS) $(LIBS)
+
+quick-test: $(TOPDIR)/lib/libbtrfs.a quick-test.o
+	gcc $(CFLAGS) -o quick-test quick-test.o $(TOPDIR)/lib/libbtrfs.a  $(LDFLAGS) $(LIBS)
+
+convert: $(TOPDIR)/lib/libbtrfs.a convert.o
+	gcc $(CFLAGS) -o btrfs-convert convert.o $(TOPDIR)/lib/libbtrfs.a  -lext2fs $(LDFLAGS) $(LIBS)
+
+clean :
+	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
+	rm -f version.h
+
+install: $(progs) install-man
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	if [ -e btrfs-convert ]; then $(INSTALL) btrfs-convert $(DESTDIR)$(bindir); fi
+
+-include .*.d
diff --git a/bcp b/misc/bcp
old mode 100755
new mode 100644
similarity index 100%
rename from bcp
rename to misc/bcp
diff --git a/btrfs-image.c b/misc/btrfs-image.c
similarity index 100%
rename from btrfs-image.c
rename to misc/btrfs-image.c
diff --git a/btrfs-map-logical.c b/misc/btrfs-map-logical.c
similarity index 100%
rename from btrfs-map-logical.c
rename to misc/btrfs-map-logical.c
diff --git a/btrfs-show.c b/misc/btrfs-show.c
similarity index 100%
rename from btrfs-show.c
rename to misc/btrfs-show.c
diff --git a/btrfs-vol.c b/misc/btrfs-vol.c
similarity index 100%
rename from btrfs-vol.c
rename to misc/btrfs-vol.c
diff --git a/btrfsck.c b/misc/btrfsck.c
similarity index 100%
rename from btrfsck.c
rename to misc/btrfsck.c
diff --git a/btrfsctl.c b/misc/btrfsctl.c
similarity index 100%
rename from btrfsctl.c
rename to misc/btrfsctl.c
diff --git a/btrfstune.c b/misc/btrfstune.c
similarity index 100%
rename from btrfstune.c
rename to misc/btrfstune.c
diff --git a/convert.c b/misc/convert.c
similarity index 100%
rename from convert.c
rename to misc/convert.c
diff --git a/debug-tree.c b/misc/debug-tree.c
similarity index 100%
rename from debug-tree.c
rename to misc/debug-tree.c
diff --git a/mkfs.c b/misc/mkfs.c
similarity index 100%
rename from mkfs.c
rename to misc/mkfs.c
diff --git a/version.sh b/misc/version.sh
similarity index 100%
rename from version.sh
rename to misc/version.sh
diff --git a/tests/Makefile b/tests/Makefile
new file mode 100644
index 0000000..e8df52c
--- /dev/null
+++ b/tests/Makefile
@@ -0,0 +1,88 @@
+CC=gcc
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+CFLAGS = -g -Werror -Os
+objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
+	  root-tree.o dir-item.o file-item.o inode-item.o \
+	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
+	  volumes.o utils.o
+
+#
+CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
+		-Wuninitialized -Wshadow -Wundef
+DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+
+INSTALL= install
+prefix ?= /usr/local
+bindir = $(prefix)/bin
+LIBS=-luuid
+
+progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
+	btrfs-map-logical
+
+# make C=1 to enable sparse
+ifdef C
+	check=sparse $(CHECKFLAGS)
+else
+	check=ls
+endif
+
+.c.o:
+	$(check) $<
+	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+
+all: version $(progs) manpages
+
+version:
+	bash version.sh
+
+btrfsctl: $(objects) btrfsctl.o
+	gcc $(CFLAGS) -static -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
+
+btrfs-vol: $(objects) btrfs-vol.o
+	gcc $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
+	gcc $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
+
+btrfsck: $(objects) btrfsck.o
+	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
+
+mkfs.btrfs: $(objects) mkfs.o
+	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+
+btrfs-debug-tree: $(objects) debug-tree.o
+	gcc $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
+
+btrfstune: $(objects) btrfstune.o
+	gcc $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+
+btrfs-map-logical: $(objects) btrfs-map-logical.o
+	gcc $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
+
+btrfs-image: $(objects) btrfs-image.o
+	gcc $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
+
+dir-test: $(objects) dir-test.o
+	gcc $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
+
+quick-test: $(objects) quick-test.o
+	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
+
+convert: $(objects) convert.o
+	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
+
+manpages:
+	cd man; make
+
+install-man:
+	cd man; make install
+
+clean :
+	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
+	cd man; make clean
+
+install: $(progs) install-man
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	if [ -e btrfs-convert ]; then $(INSTALL) btrfs-convert $(DESTDIR)$(bindir); fi
+
+-include .*.d
diff --git a/dir-test.c b/tests/dir-test.c
similarity index 100%
rename from dir-test.c
rename to tests/dir-test.c
diff --git a/hasher.c b/tests/hasher.c
similarity index 100%
rename from hasher.c
rename to tests/hasher.c
diff --git a/quick-test.c b/tests/quick-test.c
similarity index 100%
rename from quick-test.c
rename to tests/quick-test.c
diff --git a/random-test.c b/tests/random-test.c
similarity index 100%
rename from random-test.c
rename to tests/random-test.c
diff --git a/show-blocks b/tests/show-blocks
old mode 100755
new mode 100644
similarity index 100%
rename from show-blocks
rename to tests/show-blocks
-- 
1.7.0.rc0.48.gdace5

