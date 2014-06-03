Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:54517 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaFCGRe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 02:17:34 -0400
From: Christian Hesse <mail@eworm.de>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Christian Hesse <mail@eworm.de>
Subject: [PATCH 1/1] btrfs-progs: fix build, manpage compression command
Date: Tue,  3 Jun 2014 08:09:25 +0200
Message-Id: <1401775765-16646-1-git-send-email-mail@eworm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

man pages for btrfs-progs are compressed by gzip by default. In Makefile
the variable GZIP is use, this evaluates to 'gzip gzip' on my system.
>From man gzip:

> The environment variable GZIP can hold a set of default options for
> gzip. These options are interpreted first and can be overwritten by
> explicit command line parameters.

So using any other variable name fixes this.

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 Documentation/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 45299bb..e79dd8f 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -45,7 +45,7 @@ MANPAGE_XSL = manpage-normal.xsl
 XMLTO = xmlto
 XMLTO_EXTRA =
 XMLTO_EXTRA = -m manpage-bold-literal.xsl
-GZIP = gzip
+GZIPCMD = gzip
 INSTALL ?= install
 RM ?= rm -f
 LNS ?= ln -sf
@@ -56,7 +56,7 @@ ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
 	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
 	QUIET_XMLTO	= @echo '   ' XMLTO $@;
-	QUIET_GZIP	= @echo '   ' GZIP $@;
+	QUIET_GZIP	= @echo '   ' GZIPCMD $@;
 	QUIET_STDERR	= 2> /dev/null
 	QUIET_SUBDIR0	= +@subdir=
 	QUIET_SUBDIR1	= ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
@@ -80,9 +80,9 @@ clean:
 	$(RM) *.xml *.xml+ *.8 *.8.gz
 
 %.8.gz : %.8
-	$(QUIET_GZIP)$(GZIP) -n -c $< > $@
+	$(QUIET_GZIP)$(GZIPCMD) -n -c $< > $@
 
-%.8 : %.xml 
+%.8 : %.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
 	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 %.xml : %.txt asciidoc.conf
-- 
2.0.0

