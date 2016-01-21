Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:33557 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbcAUP7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 10:59:37 -0500
Received: from naomi.gilbertsystems.net (d192-24-148-25.try.wideopenwest.com [24.192.25.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: floppym)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 23419340998
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 15:59:37 +0000 (UTC)
From: Mike Gilbert <floppym@gentoo.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Makefile.in: Simplify/correct install-static
Date: Thu, 21 Jan 2016 10:59:32 -0500
Message-Id: <1453391972-25669-1-git-send-email-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

install -D does not create the last component, so this failed if
$(DESTDIR)$(bindir) did not already exist.

There's no need for a loop here since install accepts multiple source
arguments.

Signed-off-by: Mike Gilbert <floppym@gentoo.org>
---
 Makefile.in | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 19697ff..82a3143 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -379,9 +379,8 @@ install: $(libs) $(progs_install) $(INSTALLDIRS)
 	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
 
 install-static: $(progs_static) $(INSTALLDIRS)
-	for p in $(progs_static) ; do \
-		$(INSTALL) -D -m755 $$p $(DESTDIR)$(bindir)/ ; \
-	done
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(progs_static) $(DESTDIR)$(bindir)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
 	$(LN_S) -f btrfs.static $(DESTDIR)$(bindir)/btrfsck.static
 
-- 
2.7.0

