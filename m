From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/7][V2] btrfs-progs:  Update the makefile for generating the help messages.
Date: Tue, 08 Nov 2011 23:12:38 +0100
Message-ID: <1988774.8uPblmpdsr@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1692439.YDWAYK6G5d"
Cc: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1692439.YDWAYK6G5d
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"


Update the makefile for generating the help messages.


Signed off by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 413f5d5..e9555b3 100644
--- a/Makefile
+++ b/Makefile
@@ -38,8 +38,9 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o helpmsg.o
 	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+		helpmsg.o \
 		$(objects) $(LDFLAGS) $(LIBS)
 
 calc-size: $(objects) calc-size.o
@@ -108,6 +109,19 @@ man/btrfs.8.in: helpextract $(btrfs_man_page_source)
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
 
@@ -115,6 +129,7 @@ clean :
 	rm -f man/btrfs.8.in
 	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-
super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
+	rm -f helpmsg.c
 	cd man; make clean
 
 install: $(progs) install-man
-- 
1.7.7.2

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1692439.YDWAYK6G5d
Content-Disposition: inline; filename="send-via-kmail-attach-10625-1320789396-5158.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-10625-1320789396-5158.msg"

diff --git a/Makefile b/Makefile
index 413f5d5..e9555b3 100644
--- a/Makefile
+++ b/Makefile
@@ -38,8 +38,9 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o helpmsg.o
 	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+		helpmsg.o \
 		$(objects) $(LDFLAGS) $(LIBS)
 
 calc-size: $(objects) calc-size.o
@@ -108,6 +109,19 @@ man/btrfs.8.in: helpextract $(btrfs_man_page_source)
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
 
@@ -115,6 +129,7 @@ clean :
 	rm -f man/btrfs.8.in
 	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
+	rm -f helpmsg.c
 	cd man; make clean
 
 install: $(progs) install-man
-- 
1.7.7.2

--nextPart1692439.YDWAYK6G5d--

