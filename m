From: Joe Peterson <joe@skyrush.com>
Subject: [PATCH] btrfs-progs: remove hard-coding of "gcc" and "make" from
 Makefile
Date: Mon, 21 Sep 2009 10:18:53 -0600
Message-ID: <4AB7A76D.8050902@skyrush.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070509020109010709010604"
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070509020109010709010604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here's a simple patch to replace "gcc" with "$(CC)" and "make" with
"$(MAKE)".  This is required, for example, for Gentoo Linux ebuilds, and
it also eliminates a "jobserver unavailable" warning (make-related).

						-Joe

--------------070509020109010709010604
Content-Type: text/plain;
 name="btrfs-progs_use_env_gcc_make.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs-progs_use_env_gcc_make.patch"

diff -Nurp a/Makefile b/Makefile
--- a/Makefile	2009-09-21 09:43:46.672275731 -0600
+++ b/Makefile	2009-09-21 09:44:33.221156240 -0600
@@ -36,47 +36,47 @@ version:
 	bash version.sh
 
 btrfsctl: $(objects) btrfsctl.o
-	gcc $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-vol: $(objects) btrfs-vol.o
-	gcc $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-show: $(objects) btrfs-show.o
-	gcc $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfsck: $(objects) btrfsck.o
-	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
 
 mkfs.btrfs: $(objects) mkfs.o
-	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
 
 btrfs-debug-tree: $(objects) debug-tree.o
-	gcc $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
 
 btrfstune: $(objects) btrfstune.o
-	gcc $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
 
 btrfs-image: $(objects) btrfs-image.o
-	gcc $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
 
 dir-test: $(objects) dir-test.o
-	gcc $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
 
 quick-test: $(objects) quick-test.o
-	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
 convert: $(objects) convert.o
-	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
 
 manpages:
-	cd man; make
+	cd man; $(MAKE)
 
 install-man:
-	cd man; make install
+	cd man; $(MAKE) install
 
 clean :
 	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
-	cd man; make clean
+	cd man; $(MAKE) clean
 
 install: $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)

--------------070509020109010709010604--
