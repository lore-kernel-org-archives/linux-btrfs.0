From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: [btrfs-progs 4/4] Modify Makefile to include man directory
Date: Tue, 13 Jan 2009 18:21:19 +0530
Message-ID: <20090113125119.GA15224@baloo.junglebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@gmail.com>
---
 Makefile |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 3349079..8f21c27 100644
--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,7 @@ endif
 	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
 
 
-all: version $(progs)
+all: version $(progs) manpages
 
 version:
 	bash version.sh
@@ -68,10 +68,17 @@ quick-test: $(objects) quick-test.o
 convert: $(objects) convert.o
 	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
 
+manpages:
+	cd man; make
+
+install-man:
+	cd man; make install
+
 clean :
 	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
+	cd man; make clean
 
-install: $(progs)
+install: $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
 	if [ -e btrfs-convert ]; then $(INSTALL) btrfs-convert $(DESTDIR)$(bindir); fi
-- 
1.6.0.2


-- 
Goldwyn
