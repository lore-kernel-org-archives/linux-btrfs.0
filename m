Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:58812 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaGYNmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 09:42:12 -0400
From: "n.st" <git@n-st.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <git@n-st.de>, David Sterba <dsterba@suse.cz>
Subject: [PATCH v3] btrfs-progs: Add uninstall targets to Makefiles.
Date: Fri, 25 Jul 2014 15:41:57 +0200
Message-Id: <1406295717-10193-1-git-send-email-git@n-st.de>
In-Reply-To: <20140627123201.GB1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nils Steinger <git@n-st.de>

Signed-off-by: Nils Steinger <git@n-st.de>
---

v2: As Satoru Takeuchi pointed out, I forgot to remove $(libs) in the main
Makefile.

v3: David Sterba suggested not to remove the $(bindir) and $(libdir), since
those might be needed by other programs, even if the btrfs uninstallation
leaves them empty.

 Documentation/Makefile | 4 ++++
 Makefile               | 7 +++++++
 2 files changed, 11 insertions(+)

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
index 76565e8..de5bd9e 100644
--- a/Makefile
+++ b/Makefile
@@ -257,6 +257,13 @@ $(INSTALLDIRS):
 	@echo "Making install in $(patsubst install-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst install-%,%,$@) install
 
+uninstall:
+	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation uninstall
+	cd $(DESTDIR)$(incdir); rm -f $(headers)
+	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(incdir)
+	cd $(DESTDIR)$(libdir); rm -f $(lib_links) $(libs)
+	cd $(DESTDIR)$(bindir); rm -f btrfsck fsck.btrfs $(progs)
+
 ifneq ($(MAKECMDGOALS),clean)
 -include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
 endif
-- 
1.9.1

