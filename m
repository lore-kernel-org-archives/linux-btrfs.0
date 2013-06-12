Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3FLAiE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 20:38:04 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5C0c4o8000785
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:38:04 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r5C0c3r6014152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:38:03 -0400
Message-ID: <51B7C2EB.8090509@redhat.com>
Date: Tue, 11 Jun 2013 19:38:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3 V2] Btrfs-progs: move btrfs cmd files to cmd/ subdir
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com> <1370992519-21369-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1370992519-21369-4-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move btrfs cmd files to cmd/ subdir

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: move btrfsck symlink handling to cmd/Makefile too

 Makefile                                   |   38 ++++++-----------
 cmd/Makefile                               |   61 ++++++++++++++++++++++++++++
 btrfs.c => cmd/btrfs.c                     |    0
 cmds-balance.c => cmd/cmds-balance.c       |    0
 cmds-check.c => cmd/cmds-check.c           |    0
 cmds-device.c => cmd/cmds-device.c         |    0
 cmds-filesystem.c => cmd/cmds-filesystem.c |    0
 cmds-inspect.c => cmd/cmds-inspect.c       |    0
 cmds-qgroup.c => cmd/cmds-qgroup.c         |    0
 cmds-quota.c => cmd/cmds-quota.c           |    0
 cmds-receive.c => cmd/cmds-receive.c       |    0
 cmds-replace.c => cmd/cmds-replace.c       |    0
 cmds-restore.c => cmd/cmds-restore.c       |    0
 cmds-scrub.c => cmd/cmds-scrub.c           |    0
 cmds-send.c => cmd/cmds-send.c             |    0
 cmds-subvolume.c => cmd/cmds-subvolume.c   |    0
 help.c => cmd/help.c                       |    0
 17 files changed, 74 insertions(+), 25 deletions(-)
 create mode 100644 cmd/Makefile
 rename btrfs.c => cmd/btrfs.c (100%)
 rename cmds-balance.c => cmd/cmds-balance.c (100%)
 rename cmds-check.c => cmd/cmds-check.c (100%)
 rename cmds-device.c => cmd/cmds-device.c (100%)
 rename cmds-filesystem.c => cmd/cmds-filesystem.c (100%)
 rename cmds-inspect.c => cmd/cmds-inspect.c (100%)
 rename cmds-qgroup.c => cmd/cmds-qgroup.c (100%)
 rename cmds-quota.c => cmd/cmds-quota.c (100%)
 rename cmds-receive.c => cmd/cmds-receive.c (100%)
 rename cmds-replace.c => cmd/cmds-replace.c (100%)
 rename cmds-restore.c => cmd/cmds-restore.c (100%)
 rename cmds-scrub.c => cmd/cmds-scrub.c (100%)
 rename cmds-send.c => cmd/cmds-send.c (100%)
 rename cmds-subvolume.c => cmd/cmds-subvolume.c (100%)
 rename help.c => cmd/help.c (100%)

diff --git a/Makefile b/Makefile
index 01b71ec..db8f348 100644
--- a/Makefile
+++ b/Makefile
@@ -10,10 +10,6 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o
-cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
-	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
-	       cmds-restore.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
@@ -46,8 +42,8 @@ endif
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 
-progs = mkfs.btrfs btrfs-debug-tree btrfsck \
-	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
+progs = mkfs.btrfs btrfs-debug-tree \
+	btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfstune btrfs-show-super
 
 # external libs required by various binaries; for btrfs-foo,
@@ -56,13 +52,17 @@ btrfs_convert_libs = -lext2fs -lcom_err
 btrfs_image_libs = -lpthread
 btrfs_fragment_libs = -lgd -lpng -ljpeg -lfreetype
 
-SUBDIRS = man tests
+SUBDIRS = cmd man tests
+STATIC_SUBDIRS = cmd
 BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
+STATIC_BUILDDIRS = $(patsubst %,buildstatic-%,$(STATIC_SUBDIRS))
 INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
 .PHONY: $(SUBDIRS)
+.PHONY: $(STATIC_SUBDIRS)
 .PHONY: $(BUILDDIRS)
+.PHONY: $(STATIC_BUILDDIRS)
 .PHONY: $(INSTALLDIRS)
 .PHONY: $(TESTDIRS)
 .PHONY: $(CLEANDIRS)
@@ -70,7 +70,6 @@ CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
 # Create all the static targets
 static_objects = $(patsubst %.o, %.static.o, $(objects))
-static_cmds_objects = $(patsubst %.o, %.static.o, $(cmds_objects))
 static_libbtrfs_objects = $(patsubst %.o, %.static.o, $(libbtrfs_objects))
 
 # Define static compilation flags
@@ -110,7 +109,11 @@ $(BUILDDIRS): $(libs)
 # NOTE: For static compiles, you need to have all the required libs
 # 	static equivalent available
 #
-static: version.h btrfs.static mkfs.btrfs.static btrfs-find-root.static
+static: version.h mkfs.btrfs.static btrfs-find-root.static $(STATIC_BUILDDIRS)
+$(STATIC_SUBDIRS): $(STATIC_BUILDDIRS)
+$(STATIC_BUILDDIRS): $(static_objects) $(static_libbtrfs_objects) 
+	@echo "Making static in $(patsubst buildstatic-%,%,$@)"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst buildstatic-%,%,$@) static
 
 version.h:
 	@echo "    [SH]     $@"
@@ -150,21 +153,6 @@ btrfs-%: version.h $(objects) $(libs) btrfs-%.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
 
-btrfs: $(objects) btrfs.o help.o $(cmds_objects) $(libs)
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
-		$(objects) $(LDFLAGS) $(LIBS) -lpthread
-
-btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects) $(static_libbtrfs_objects)
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
-		$(static_objects) $(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
-
-# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
-btrfsck: btrfs
-	@echo "    [LN]     $@"
-	$(Q)$(LN) -f btrfs btrfsck
-
 mkfs.btrfs: $(objects) $(libs) mkfs.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
@@ -184,7 +172,7 @@ manpages:
 clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
-	      btrfs-zero-log btrfstune btrfsck btrfs.static mkfs.btrfs.static btrfs-calc-size \
+	      btrfs-zero-log btrfstune mkfs.btrfs.static btrfs-calc-size \
 	      version.h \
 	      $(libs) $(lib_links)
 
@@ -195,8 +183,6 @@ $(CLEANDIRS):
 install: $(libs) $(progs) $(INSTALLDIRS)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
-	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
-	$(LN) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
 	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
 	cp -a $(lib_links) $(DESTDIR)$(libdir)
diff --git a/cmd/Makefile b/cmd/Makefile
new file mode 100644
index 0000000..994febb
--- /dev/null
+++ b/cmd/Makefile
@@ -0,0 +1,63 @@
+CFLAGS += -I..
+
+cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
+	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
+	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
+	       cmds-restore.o
+objects := $(addprefix ../, $(objects))
+static_objects = $(patsubst %.o, %.static.o, $(objects))
+
+progs = btrfs btrfsck
+
+lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
+LIBS = $(lib_LIBS) $(addprefix ../, $(libs_static))
+
+libs_static = libbtrfs.a
+libs = $(addprefix ../, $(libs_static))
+
+.c.o:
+	$(Q)$(check) $<
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+%.static.o: %.c
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
+
+all: $(progs)
+
+#
+# NOTE: For static compiles, you need to have all the required libs
+# 	static equivalent available
+#
+static: btrfs.static
+
+btrfs: $(objects) btrfs.o help.o $(cmds_objects) $(libs)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
+		$(objects) $(LDFLAGS) $(LIBS) -lpthread
+
+btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects) $(static_libbtrfs_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
+		$(static_objects) $(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
+
+# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
+btrfsck: btrfs
+	@echo "    [LN]     $@"
+	$(Q)$(LN) -f btrfs btrfsck
+
+clean:
+	$(Q)rm -f *.o .*.d $(progs)
+
+install: $(libs) $(progs) $(INSTALLDIRS)
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
+	$(LN) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
+
+$(INSTALLDIRS):
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(@:install-%=%) install
+
+
+-include .*.d
diff --git a/btrfs.c b/cmd/btrfs.c
similarity index 100%
rename from btrfs.c
rename to cmd/btrfs.c
diff --git a/cmds-balance.c b/cmd/cmds-balance.c
similarity index 100%
rename from cmds-balance.c
rename to cmd/cmds-balance.c
diff --git a/cmds-check.c b/cmd/cmds-check.c
similarity index 100%
rename from cmds-check.c
rename to cmd/cmds-check.c
diff --git a/cmds-device.c b/cmd/cmds-device.c
similarity index 100%
rename from cmds-device.c
rename to cmd/cmds-device.c
diff --git a/cmds-filesystem.c b/cmd/cmds-filesystem.c
similarity index 100%
rename from cmds-filesystem.c
rename to cmd/cmds-filesystem.c
diff --git a/cmds-inspect.c b/cmd/cmds-inspect.c
similarity index 100%
rename from cmds-inspect.c
rename to cmd/cmds-inspect.c
diff --git a/cmds-qgroup.c b/cmd/cmds-qgroup.c
similarity index 100%
rename from cmds-qgroup.c
rename to cmd/cmds-qgroup.c
diff --git a/cmds-quota.c b/cmd/cmds-quota.c
similarity index 100%
rename from cmds-quota.c
rename to cmd/cmds-quota.c
diff --git a/cmds-receive.c b/cmd/cmds-receive.c
similarity index 100%
rename from cmds-receive.c
rename to cmd/cmds-receive.c
diff --git a/cmds-replace.c b/cmd/cmds-replace.c
similarity index 100%
rename from cmds-replace.c
rename to cmd/cmds-replace.c
diff --git a/cmds-restore.c b/cmd/cmds-restore.c
similarity index 100%
rename from cmds-restore.c
rename to cmd/cmds-restore.c
diff --git a/cmds-scrub.c b/cmd/cmds-scrub.c
similarity index 100%
rename from cmds-scrub.c
rename to cmd/cmds-scrub.c
diff --git a/cmds-send.c b/cmd/cmds-send.c
similarity index 100%
rename from cmds-send.c
rename to cmd/cmds-send.c
diff --git a/cmds-subvolume.c b/cmd/cmds-subvolume.c
similarity index 100%
rename from cmds-subvolume.c
rename to cmd/cmds-subvolume.c
diff --git a/help.c b/cmd/help.c
similarity index 100%
rename from help.c
rename to cmd/help.c
---
1.7.1
