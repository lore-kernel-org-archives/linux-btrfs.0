From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 6/6] Update the makefile for generating the help messages.
Date: Tue, 19 Jul 2011 18:12:28 +0200
Message-ID: <20110719161228.3210.93016.stgit@venice.bhome>
References: <20110719161049.3210.54794.stgit@venice.bhome>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110719161049.3210.54794.stgit@venice.bhome>
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Update the makefile for generating the help messages.
---
 Makefile |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index dc1342f..7b25b47 100644
--- a/Makefile
+++ b/Makefile
@@ -37,8 +37,9 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o helpmsg.o
 	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+		helpmsg.o \
 		$(objects) $(LDFLAGS) $(LIBS)
 
 btrfsctl: $(objects) btrfsctl.o
@@ -95,6 +96,19 @@ man/btrfs.8.in: helpextract $(btrfs_man_page_source)
 manpages: man/btrfs.8.in
 	cd man; make
 
+helpmsg.c: helpextract $(btrfs_man_page_source)
+	echo  >$@ "/*"
+	echo >>$@ " * this file contains the help messages. It is "
+	echo >>$@ " * automatically generated. do not edit ! "
+	echo >>$@ " */"
+	echo >>$@
+	echo >>$@ "#define NULL 0"
+	echo >>$@
+
+	echo -n "char * help_messages[] = " >>$@
+	./helpextract --c-array $(btrfs_man_page_source) >>$@
+	 echo >>$@ ";"
+
 install-man:
 	cd man; make install
 
@@ -102,6 +116,7 @@ clean :
 	rm -f man/btrfs.8.in
 	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
+	rm -f helpmsg.c
 	cd man; make clean
 
 install: $(progs) install-man

