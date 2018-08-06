Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35620 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbeHFXFZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 19:05:25 -0400
Received: from naomi.gilbertsystems.net (unknown [24.192.26.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: floppym)
        by smtp.gentoo.org (Postfix) with ESMTPSA id E9955335CA0
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 20:54:34 +0000 (UTC)
From: Mike Gilbert <floppym@gentoo.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Install uncompressed man pages
Date: Mon,  6 Aug 2018 16:54:31 -0400
Message-Id: <20180806205432.11009-1-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Build systems do not typically compress man pages when installing them.
This is generally left to distro packaging mechanisms, which may end up
recompressing them using a different compressor.
---
 Documentation/Makefile.in | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index 184647c4..c4c843cb 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -37,9 +37,9 @@ MAN3_TXT += btrfs-ioctl.asciidoc
 MAN_TXT = $(MAN3_TXT) $(MAN8_TXT) $(MAN5_TXT)
 MAN_XML = $(patsubst %.asciidoc,%.xml,$(MAN_TXT))
 MAN_HTML = $(patsubst %.asciidoc,%.html,$(MAN_TXT))
-GZ_MAN3 = $(patsubst %.asciidoc,%.3.gz,$(MAN3_TXT))
-GZ_MAN5 = $(patsubst %.asciidoc,%.5.gz,$(MAN5_TXT))
-GZ_MAN8 = $(patsubst %.asciidoc,%.8.gz,$(MAN8_TXT))
+MAN3 = $(patsubst %.asciidoc,%.3,$(MAN3_TXT))
+MAN5 = $(patsubst %.asciidoc,%.5,$(MAN5_TXT))
+MAN8 = $(patsubst %.asciidoc,%.8,$(MAN8_TXT))
 
 mandir ?= $(prefix)/share/man
 man3dir = $(mandir)/man3
@@ -86,9 +86,9 @@ endif
 
 all: man
 man: man3 man5 man8
-man3: $(GZ_MAN3)
-man5: $(GZ_MAN5)
-man8: $(GZ_MAN8)
+man3: $(MAN3)
+man5: $(MAN5)
+man8: $(MAN8)
 html: $(MAN_HTML)
 
 install: install-man
@@ -96,15 +96,15 @@ install: install-man
 install-man: man
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
-	$(INSTALL) -m 644 $(GZ_MAN5) $(DESTDIR)$(man5dir)
+	$(INSTALL) -m 644 $(MAN5) $(DESTDIR)$(man5dir)
 	# the source file name of btrfs.5 clashes with section 8 page, but we
 	# want to keep the code generic
-	$(MV) $(DESTDIR)$(man5dir)/btrfs-man5.5.gz $(DESTDIR)$(man5dir)/btrfs.5.gz
-	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
-	$(LN_S) -f btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz
+	$(MV) $(DESTDIR)$(man5dir)/btrfs-man5.5 $(DESTDIR)$(man5dir)/btrfs.5
+	$(INSTALL) -m 644 $(MAN8) $(DESTDIR)$(man8dir)
+	$(LN_S) -f btrfs-check.8 $(DESTDIR)$(man8dir)/btrfsck.8
 
 uninstall:
-	cd $(DESTDIR)$(man8dir); rm -f btrfs-check.8.gz $(GZ_MAN8)
+	cd $(DESTDIR)$(man8dir); rm -f btrfs-check.8 $(MAN8)
 	$(RMDIR) -p --ignore-fail-on-non-empty $(DESTDIR)$(man8dir)
 
 clean:
-- 
2.18.0

