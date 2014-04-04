Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaDDOuK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 10:50:10 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: add separate make target to clean docs
Date: Fri,  4 Apr 2014 16:50:05 +0200
Message-Id: <1396623005-16508-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regenerating the asciidoc takes much longer now and makes quick build
tests long. There's separate clean-doc target for that and clean-all
that cleans docs and sources.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

This applies on top of the new asciidoc patches and makes frequent build tests
more friendly

 Makefile | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 70eaf5765dd8..f2f2579ed9c6 100644
--- a/Makefile
+++ b/Makefile
@@ -56,9 +56,9 @@ btrfs_convert_libs = -lext2fs -lcom_err
 btrfs_image_libs = -lpthread
 btrfs_fragment_libs = -lgd -lpng -ljpeg -lfreetype
 
-SUBDIRS = Documentation
-BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
-INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
+SUBDIRS =
+BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS)) Documentation
+INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS)) Documentation
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
 .PHONY: $(SUBDIRS)
@@ -120,7 +120,7 @@ endif
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
 
-all: $(progs) manpages $(BUILDDIRS)
+all: $(progs) $(BUILDDIRS)
 $(SUBDIRS): $(BUILDDIRS)
 $(BUILDDIRS):
 	@echo "Making all in $(patsubst build-%,%,$@)"
@@ -223,6 +223,8 @@ send-test: $(objects) $(libs) send-test.o
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
 
+clean-all: clean-doc clean
+
 clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o *.o.d btrfs-convert btrfs-image btrfs-select-super \
@@ -231,6 +233,10 @@ clean: $(CLEANDIRS)
 	      version.h $(check_defs) \
 	      $(libs) $(lib_links)
 
+clean-doc:
+	@echo "Cleaning Documentation"
+	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation clean
+
 $(CLEANDIRS):
 	@echo "Cleaning $(patsubst clean-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
-- 
1.9.0

