Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab3DUWWj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 18:22:39 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LMMdfo013504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 18:22:39 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3LMMblo019837
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 18:22:39 -0400
Message-ID: <517466AD.9060401@redhat.com>
Date: Sun, 21 Apr 2013 17:22:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Add default rules to Makefile
References: <517463E4.7040400@redhat.com>
In-Reply-To: <517463E4.7040400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a default rule for any btrfs-$FOO or btrfs-$FOO.static
target, allowing it to be built from btrfs-$FOO.c along with
all the normal userspace objects.

This gets rid of a lot of the cut and pasted rules for
each individual command, and as an added bonus makes it
easy to build any btrfs-$FOO statically as well, i.e.

  # make btrfs-convert.static

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Makefile |   79 ++++++++++++++++++++-------------------------------------------
1 file changed, 26 insertions(+), 53 deletions(-)

diff --git a/Makefile b/Makefile
index 10f5fe5..86d2c93 100644
--- a/Makefile
+++ b/Makefile
@@ -105,6 +105,32 @@ $(lib_links):
 	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so.0
 	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so
 
+# external libs required by various binaries; for btrfs-foo,
+# specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
+btrfs_convert_libs = -lext2fs -lcom_err
+btrfs_image_libs = -lpthread
+btrfs_fragment_libs = -lgd -lpng -ljpeg -lfreetype
+
+# keep intermediate files from the below implicit rules around
+.PRECIOUS: $(addsuffix .o,$(progs))
+
+# Make any btrfs-foo out of btrfs-foo.o, with appropriate libs.
+# The $($(subst...)) bits below takes the btrfs_*_libs definitions above and
+# turns them into a list of libraries to link against if they exist
+#
+# For static variants, use an extra $(subst) to get rid of the ".static"
+# from the target name before translating to list of libs
+
+btrfs-%.static: version.h $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ $@.o $(static_objects) \
+		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS) \
+		$($(subst -,_,$(subst .static,,$@)-libs))
+
+btrfs-%: version.h $(objects) $(libs) btrfs-%.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
+
 btrfs: $(objects) btrfs.o help.o $(cmds_objects) $(libs)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
@@ -115,19 +141,6 @@ btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objec
 	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
 		$(static_objects) $(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
-btrfs-calc-size: $(objects) $(libs) btrfs-calc-size.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-calc-size btrfs-calc-size.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-find-root: $(objects) $(libs) btrfs-find-root.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-find-root btrfs-find-root.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-find-root.static: $(static_objects) btrfs-find-root.static.o $(static_libbtrfs_objects)
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs-find-root.static btrfs-find-root.static.o $(static_objects) \
-		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
-
 # For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
 btrfsck: btrfs
 	@echo "    [LN]     $@"
@@ -142,42 +155,10 @@ mkfs.btrfs.static: $(static_objects) mkfs.static.o $(static_libbtrfs_objects)
 	$(Q)$(CC) $(STATIC_CFLAGS) -o mkfs.btrfs.static mkfs.static.o $(static_objects) \
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
-btrfs-debug-tree: $(objects) $(libs) btrfs-debug-tree.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) btrfs-debug-tree.o $(LDFLAGS) $(LIBS)
-
-btrfs-zero-log: $(objects) $(libs) btrfs-zero-log.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
-
-btrfs-show-super: $(objects) $(libs) btrfs-show-super.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-show-super $(objects) btrfs-show-super.o $(LDFLAGS) $(LIBS)
-
-btrfs-select-super: $(objects) $(libs) btrfs-select-super.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
-
 btrfstune: $(objects) $(libs) btrfstune.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
 
-btrfs-map-logical: $(objects) $(libs) btrfs-map-logical.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
-
-btrfs-corrupt-block: $(objects) $(libs) btrfs-corrupt-block.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-corrupt-block $(objects) btrfs-corrupt-block.o $(LDFLAGS) $(LIBS)
-
-btrfs-image: $(objects) $(libs) btrfs-image.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
-
-btrfs-crc: btrfs-crc.o $(libs)
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-crc btrfs-crc.o $(LDFLAGS) $(LIBS)
-
 dir-test: $(objects) $(libs) dir-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
@@ -186,14 +167,6 @@ quick-test: $(objects) $(libs) quick-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
-btrfs-convert: $(objects) $(libs) btrfs-convert.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-convert $(objects) btrfs-convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
-
-btrfs-fragments: $(objects) $(libs) btrfs-fragments.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-fragments $(objects) btrfs-fragments.o $(LDFLAGS) $(LIBS) -lgd -lpng -ljpeg -lfreetype
-
 ioctl-test: $(objects) $(libs) ioctl-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)


