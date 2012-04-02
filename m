From: Sergei Trofimovich <slyich@gmail.com>
Subject: [btrfs-progs: PATCH 2/2] Makefile: use $(MAKE) instead of hardcoded 'make'
Date: Mon,  2 Apr 2012 16:10:02 +0300
Message-ID: <1333372202-627-2-git-send-email-slyich@gmail.com>
References: <1333372202-627-1-git-send-email-slyich@gmail.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333372202-627-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index ebfd5c8..9694444 100644
--- a/Makefile
+++ b/Makefile
@@ -101,15 +101,15 @@ ioctl-test: $(objects) ioctl-test.o
 	$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
 
 manpages:
-	cd man; make
+	cd man; $(MAKE)
 
 install-man:
-	cd man; make install
+	cd man; $(MAKE) install
 
 clean :
 	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
-	cd man; make clean
+	cd man; $(MAKE) clean
 
 install: $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
-- 
1.7.8.5

