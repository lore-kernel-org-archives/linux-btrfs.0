Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42784 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3FKXPZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 19:15:25 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs-progs: move test tools to tests/ subdir
Date: Tue, 11 Jun 2013 18:15:18 -0500
Message-Id: <1370992519-21369-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move test tools to tests/

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Makefile                                           |   23 +--------
 tests/Makefile                                     |   49 ++++++++++++++++++++
 .../btrfs-corrupt-block.c                          |    0
 dir-test.c => tests/dir-test.c                     |    0
 ioctl-test.c => tests/ioctl-test.c                 |    0
 quick-test.c => tests/quick-test.c                 |    0
 random-test.c => tests/random-test.c               |    0
 send-test.c => tests/send-test.c                   |    0
 8 files changed, 52 insertions(+), 20 deletions(-)
 create mode 100644 tests/Makefile
 rename btrfs-corrupt-block.c => tests/btrfs-corrupt-block.c (100%)
 rename dir-test.c => tests/dir-test.c (100%)
 rename ioctl-test.c => tests/ioctl-test.c (100%)
 rename quick-test.c => tests/quick-test.c (100%)
 rename random-test.c => tests/random-test.c (100%)
 rename send-test.c => tests/send-test.c (100%)

diff --git a/Makefile b/Makefile
index 5411ad9..01b71ec 100644
--- a/Makefile
+++ b/Makefile
@@ -56,7 +56,7 @@ btrfs_convert_libs = -lext2fs -lcom_err
 btrfs_image_libs = -lpthread
 btrfs_fragment_libs = -lgd -lpng -ljpeg -lfreetype
 
-SUBDIRS = man
+SUBDIRS = man tests
 BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
 INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
@@ -102,7 +102,7 @@ endif
 
 all: version.h $(progs) $(BUILDDIRS)
 $(SUBDIRS): $(BUILDDIRS)
-$(BUILDDIRS):
+$(BUILDDIRS): $(libs)
 	@echo "Making all in $(patsubst build-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst build-%,%,$@)
 
@@ -178,30 +178,13 @@ btrfstune: $(objects) $(libs) btrfstune.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
 
-dir-test: $(objects) $(libs) dir-test.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
-
-quick-test: $(objects) $(libs) quick-test.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
-
-ioctl-test: $(objects) $(libs) ioctl-test.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
-
-send-test: $(objects) $(libs) send-test.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
-
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C man
 
 clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
-	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
-	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
+	      btrfs-zero-log btrfstune btrfsck btrfs.static mkfs.btrfs.static btrfs-calc-size \
 	      version.h \
 	      $(libs) $(lib_links)
 
diff --git a/tests/Makefile b/tests/Makefile
new file mode 100644
index 0000000..198de0d
--- /dev/null
+++ b/tests/Makefile
@@ -0,0 +1,49 @@
+CFLAGS += -I..
+
+objects := $(addprefix ../, $(objects))
+
+lib_LIBS = -lblkid -luuid
+LIBS = $(lib_LIBS) $(addprefix ../, $(libs_static))
+
+# These last 2 don't actually build anymore
+progs = btrfs-corrupt-block ioctl-test quick-test send-test # random-test dir-test
+
+libs_static = libbtrfs.a
+libs = $(addprefix ../, $(libs_static))
+headers = $(libbtrfs_headers)
+
+.c.o:
+	$(Q)$(check) $<
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+all: $(progs)
+
+btrfs-corrupt-block: $(objects) $(libs) btrfs-corrupt-block.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-corrupt-block $(objects) btrfs-corrupt-block.o $(LDFLAGS) $(LIBS)
+
+dir-test: $(objects) $(libs) dir-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
+
+ioctl-test: $(objects) $(libs) ioctl-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
+
+quick-test: $(objects) $(libs) quick-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
+
+random-test: $(objects) $(libs) random-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o random-test $(objects) random-test.o $(LDFLAGS) $(LIBS)
+
+send-test: $(objects) $(libs) send-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
+
+clean :
+	$(Q)rm -f *.o .*.d $(progs)
+
+-include .*.d
diff --git a/btrfs-corrupt-block.c b/tests/btrfs-corrupt-block.c
similarity index 100%
rename from btrfs-corrupt-block.c
rename to tests/btrfs-corrupt-block.c
diff --git a/dir-test.c b/tests/dir-test.c
similarity index 100%
rename from dir-test.c
rename to tests/dir-test.c
diff --git a/ioctl-test.c b/tests/ioctl-test.c
similarity index 100%
rename from ioctl-test.c
rename to tests/ioctl-test.c
diff --git a/quick-test.c b/tests/quick-test.c
similarity index 100%
rename from quick-test.c
rename to tests/quick-test.c
diff --git a/random-test.c b/tests/random-test.c
similarity index 100%
rename from random-test.c
rename to tests/random-test.c
diff --git a/send-test.c b/tests/send-test.c
similarity index 100%
rename from send-test.c
rename to tests/send-test.c
-- 
1.7.1

