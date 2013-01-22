Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:38170 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3AVRWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 12:22:18 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122172217.TIGP6475.eastrmfepo202.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 12:22:17 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 2/3] Btrfs-progs Add make archive
Date: Tue, 22 Jan 2013 12:22:05 -0500
Message-Id: <1358875326-28636-3-git-send-email-gene@czarc.net>
In-Reply-To: <1358875326-28636-1-git-send-email-gene@czarc.net>
References: <1358875326-28636-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds the archive target to the Makefile which simply executes
do-archive.sh.  It also adds the remove of btrfs-progs.spec.in to
make clean.
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index d524f69..6812258 100644
--- a/Makefile
+++ b/Makefile
@@ -111,9 +111,13 @@ manpages:
 install-man:
 	cd man; $(MAKE) install
 
+archive:
+	bash do-archive.sh
+
 clean :
 	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
-	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
+	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h \
+	      btrfs-progs.spec
 	cd man; $(MAKE) clean
 
 install: $(progs) install-man
-- 
1.8.1

