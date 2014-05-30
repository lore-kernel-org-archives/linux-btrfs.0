Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbaE3Q1Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 12:27:16 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4UGREgU031111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 12:27:15 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s4UGRDuF003042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 12:27:14 -0400
Message-ID: <5388B162.6070601@redhat.com>
Date: Fri, 30 May 2014 11:27:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: make pretty Documentation/ build match the rest
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the most important patch ever.  ;)

I found this to be less aesthetically pleasing than it was before:

     [CC]     btrfstune.o
 Making all in Documentation
     ASCIIDOC btrfs-convert.xml
     [LD]     btrfstune
     XMLTO btrfs-convert.8
     [CC]     btrfs-show-super.o
     GZIP btrfs-convert.8.gz
     [LD]     btrfs-show-super
     ASCIIDOC btrfs-debug-tree.xml
     XMLTO btrfs-debug-tree.8

so I shortened the pretty-text to match what we had before.

Also, make clean "quiet" like it is in the top dir.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

If folks don't like the 2-letter abbreviations, obviously the
patch just isn't that important.

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 45299bb..03a5cd5 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -54,9 +54,10 @@ BTRFS_VERSION = $(shell sed -n 's/.*BTRFS_BUILD_VERSION "Btrfs \(.*\)"/\1/p'\
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
-	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
-	QUIET_XMLTO	= @echo '   ' XMLTO $@;
-	QUIET_GZIP	= @echo '   ' GZIP $@;
+	QUIET_RM	= @
+	QUIET_ASCIIDOC	= @echo "    [AD]     $@";
+	QUIET_XMLTO	= @echo "    [XT]     $@";
+	QUIET_GZIP	= @echo "    [GZ]     $@";
 	QUIET_STDERR	= 2> /dev/null
 	QUIET_SUBDIR0	= +@subdir=
 	QUIET_SUBDIR1	= ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
@@ -77,7 +78,7 @@ install-man: man
 	$(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)
 
 clean:
-	$(RM) *.xml *.xml+ *.8 *.8.gz
+	$(QUIET_RM)$(RM) *.xml *.xml+ *.8 *.8.gz
 
 %.8.gz : %.8
 	$(QUIET_GZIP)$(GZIP) -n -c $< > $@

