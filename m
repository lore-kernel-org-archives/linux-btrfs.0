Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:35173 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaHNTgx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:36:53 -0400
From: Nils Steinger <nst@voidptr.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <nst@voidptr.de>, David Sterba <dsterba@suse.cz>
Subject: [PATCH v3] btrfs-progs: Add uninstall targets to Makefiles.
Date: Thu, 14 Aug 2014 21:36:48 +0200
Message-Id: <1408045008-13399-2-git-send-email-nst@voidptr.de>
In-Reply-To: <1408045008-13399-1-git-send-email-nst@voidptr.de>
References: <1408045008-13399-1-git-send-email-nst@voidptr.de>
In-Reply-To: <20140627123201.GB1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nils Steinger <nst@voidptr.de>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
