Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab3DWU52 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 16:57:28 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3NKvRVZ005982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 16:57:27 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3NKvQ9H003426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 16:57:27 -0400
Message-ID: <5176F5B5.6010008@redhat.com>
Date: Tue, 23 Apr 2013 15:57:25 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2 (resend)] btrfs-progs: standardize tool source filenames
References: <517463E4.7040400@redhat.com>
In-Reply-To: <517463E4.7040400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For any btrfs-$FOO executable, rename the main source file from
$FOO.c to to btrfs-$FOO.c

This makes it slightly more obvious what's building what,
and allows us to write a default rule in the Makefile for
these tools.

(also add btrfs-calc-size to the list of objects to remove
on make clean)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

vger ate my giant rename-files patch; here's the makefile bit, and
hopefully the rename-diffs at the end are something that git
knows how to apply?  TBH I've never tried that before.

-Eric


diff --git a/Makefile b/Makefile
index db70981..10f5fe5 100644
--- a/Makefile
+++ b/Makefile
@@ -115,17 +115,17 @@ btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objec
 	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
 		$(static_objects) $(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
-calc-size: $(objects) $(libs) calc-size.o
+btrfs-calc-size: $(objects) $(libs) btrfs-calc-size.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o btrfs-calc-size btrfs-calc-size.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-find-root: $(objects) $(libs) find-root.o
+btrfs-find-root: $(objects) $(libs) btrfs-find-root.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o btrfs-find-root btrfs-find-root.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-find-root.static: $(static_objects) find-root.static.o $(static_libbtrfs_objects)
+btrfs-find-root.static: $(static_objects) btrfs-find-root.static.o $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs-find-root.static find-root.static.o $(static_objects) \
+	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs-find-root.static btrfs-find-root.static.o $(static_objects) \
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
 # For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
@@ -142,9 +142,9 @@ mkfs.btrfs.static: $(static_objects) mkfs.static.o $(static_libbtrfs_objects)
 	$(Q)$(CC) $(STATIC_CFLAGS) -o mkfs.btrfs.static mkfs.static.o $(static_objects) \
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
-btrfs-debug-tree: $(objects) $(libs) debug-tree.o
+btrfs-debug-tree: $(objects) $(libs) btrfs-debug-tree.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) btrfs-debug-tree.o $(LDFLAGS) $(LIBS)
 
 btrfs-zero-log: $(objects) $(libs) btrfs-zero-log.o
 	@echo "    [LD]     $@"
@@ -186,13 +186,13 @@ quick-test: $(objects) $(libs) quick-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
-btrfs-convert: $(objects) $(libs) convert.o
+btrfs-convert: $(objects) $(libs) btrfs-convert.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o btrfs-convert $(objects) btrfs-convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
 
-btrfs-fragments: $(objects) $(libs) fragments.o
+btrfs-fragments: $(objects) $(libs) btrfs-fragments.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-fragments $(objects) fragments.o $(LDFLAGS) $(LIBS) -lgd -lpng -ljpeg -lfreetype
+	$(Q)$(CC) $(CFLAGS) -o btrfs-fragments $(objects) btrfs-fragments.o $(LDFLAGS) $(LIBS) -lgd -lpng -ljpeg -lfreetype
 
 ioctl-test: $(objects) $(libs) ioctl-test.o
 	@echo "    [LD]     $@"
@@ -212,7 +212,7 @@ clean :
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
-	      btrfs.static mkfs.btrfs.static \
+	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
 	      version.h \
 	      $(libs) $(lib_links)
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@

diff --git a/calc-size.c b/btrfs-calc-size.c
similarity index 100%
rename from calc-size.c
rename to btrfs-calc-size.c
diff --git a/convert.c b/btrfs-convert.c
similarity index 100%
rename from convert.c
rename to btrfs-convert.c
diff --git a/debug-tree.c b/btrfs-debug-tree.c
similarity index 100%
rename from debug-tree.c
rename to btrfs-debug-tree.c
diff --git a/find-root.c b/btrfs-find-root.c
similarity index 100%
rename from find-root.c
rename to btrfs-find-root.c
diff --git a/fragments.c b/btrfs-fragments.c
similarity index 100%
rename from fragments.c
rename to btrfs-fragments.c
