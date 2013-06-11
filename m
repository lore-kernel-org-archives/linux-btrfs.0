Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42783 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3FKXPY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 19:15:24 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs-progs: Add Makefile infrastructure for subdirs
Date: Tue, 11 Jun 2013 18:15:17 -0500
Message-Id: <1370992519-21369-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparatory patch to move cmd & test files into their
own subdirs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Makefile     |   38 +++++++++++++++++++++++++++++++-------
 man/Makefile |    1 -
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 7a49174..5411ad9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,3 +1,6 @@
+# Export all variables to sub-makes by default
+export
+
 CC = gcc
 LN = ln
 AR = ar
@@ -53,6 +56,18 @@ btrfs_convert_libs = -lext2fs -lcom_err
 btrfs_image_libs = -lpthread
 btrfs_fragment_libs = -lgd -lpng -ljpeg -lfreetype
 
+SUBDIRS = man
+BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
+INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
+CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
+
+.PHONY: $(SUBDIRS)
+.PHONY: $(BUILDDIRS)
+.PHONY: $(INSTALLDIRS)
+.PHONY: $(TESTDIRS)
+.PHONY: $(CLEANDIRS)
+.PHONY: all install clean
+
 # Create all the static targets
 static_objects = $(patsubst %.o, %.static.o, $(objects))
 static_cmds_objects = $(patsubst %.o, %.static.o, $(cmds_objects))
@@ -85,7 +100,11 @@ endif
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
 
-all: version.h $(progs) manpages
+all: version.h $(progs) $(BUILDDIRS)
+$(SUBDIRS): $(BUILDDIRS)
+$(BUILDDIRS):
+	@echo "Making all in $(patsubst build-%,%,$@)"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst build-%,%,$@)
 
 #
 # NOTE: For static compiles, you need to have all the required libs
@@ -178,19 +197,19 @@ send-test: $(objects) $(libs) send-test.o
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C man
 
-install-man:
-	cd man; $(MAKE) install
-
-clean :
+clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
 	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
 	      version.h \
 	      $(libs) $(lib_links)
-	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
-install: $(libs) $(progs) install-man
+$(CLEANDIRS): 
+	@echo "Cleaning $(patsubst clean-%,%,$@)"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
+
+install: $(libs) $(progs) $(INSTALLDIRS)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
@@ -201,4 +220,9 @@ install: $(libs) $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
 	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
 
+$(INSTALLDIRS):
+	@echo "Making install in $(patsubst install-%,%,$@)"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst install-%,%,$@) install
+
+
 -include .*.d
diff --git a/man/Makefile b/man/Makefile
index 1ba23b5..54b57d1 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -21,7 +21,6 @@ all: $(MANPAGES)
 	$(Q)$(GZIPCMD) -n -c $< > $@
 
 clean :
-	@echo "Cleaning manpages"
 	$(Q)rm -f $(MANPAGES)
 
 install: $(MANPAGES)
-- 
1.7.1

