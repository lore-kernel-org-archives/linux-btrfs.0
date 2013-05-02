Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760060Ab3EBQUY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 May 2013 12:20:24 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r42GKNSo018958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 2 May 2013 12:20:24 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r42GKNFE031513
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 2 May 2013 12:20:23 -0400
Message-ID: <51829246.10601@redhat.com>
Date: Thu, 02 May 2013 11:20:22 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make btrfsck a hardlink at install time
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfsck gets hardlinked to btrfs during the build, but the
install phase simply copies them both to the destination without
preserving the link.

Just force-link btrfsck in the destination again during install
so that the installed btrfsck is a link as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Makefile b/Makefile
index 86d2c93..7237e05 100644
--- a/Makefile
+++ b/Makefile
@@ -193,6 +193,8 @@ clean :
 install: $(libs) $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
+	$(LN) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
 	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
 	cp -a $(lib_links) $(DESTDIR)$(libdir)

