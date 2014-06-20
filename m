Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:39484 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbaFTTzg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 15:55:36 -0400
From: Nils Steinger <git@n-st.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <git@n-st.de>
Subject: [PATCH] btrfs-progs: Add uninstall targets to Makefiles.
Date: Fri, 20 Jun 2014 21:48:05 +0200
Message-Id: <1403293685-23536-2-git-send-email-git@n-st.de>
In-Reply-To: <1403293685-23536-1-git-send-email-git@n-st.de>
References: <1403293685-23536-1-git-send-email-git@n-st.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nils Steinger <git@n-st.de>
---
 Documentation/Makefile | 4 ++++
 Makefile               | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 45299bb..5c9780b 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -76,6 +76,10 @@ install-man: man
 	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
 	$(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)
 
+uninstall:
+	cd $(DESTDIR)$(man8dir); rm -f btrfs-check.8.gz $(GZ_MAN8)
+	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(man8dir)
+
 clean:
 	$(RM) *.xml *.xml+ *.8 *.8.gz
 
diff --git a/Makefile b/Makefile
index 76565e8..4cafa37 100644
--- a/Makefile
+++ b/Makefile
@@ -257,6 +257,15 @@ $(INSTALLDIRS):
 	@echo "Making install in $(patsubst install-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst install-%,%,$@) install
 
+uninstall:
+	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation uninstall
+	cd $(DESTDIR)$(incdir); rm -f $(headers)
+	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(incdir)
+	cd $(DESTDIR)$(libdir); rm -f $(lib_links)
+	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(libdir)
+	cd $(DESTDIR)$(bindir); rm -f btrfsck fsck.btrfs $(progs)
+	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(bindir)
+
 ifneq ($(MAKECMDGOALS),clean)
 -include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
 endif
-- 
1.9.1

