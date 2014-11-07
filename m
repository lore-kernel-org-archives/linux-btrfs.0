Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaKGRG1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 12:06:27 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B8878AC89
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 17:06:26 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/5] btrfs-progs: build, gather utilities that are not built by default
Date: Fri,  7 Nov 2014 18:06:26 +0100
Message-Id: <3fba49eab85b9d81a4e619024cc574fe42e4121f.1415379676.git.dsterba@suse.cz>
In-Reply-To: <cover.1415379676.git.dsterba@suse.cz>
References: <cover.1415379676.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add them to build test and to clean rules.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 126dc593ddfb..b597ad8e9b89 100644
--- a/Makefile
+++ b/Makefile
@@ -50,6 +50,9 @@ progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfstune btrfs-show-super
 
+progs_extra = btrfs-corrupt-block btrfs-fragments btrfs-calc-size \
+	      btrfs-select-super
+
 progs_static = $(foreach p,$(progs),$(p).static)
 
 # external libs required by various binaries; for btrfs-foo,
@@ -254,6 +257,7 @@ test-build:
 	-$(MAKE) library-test.static
 	$(MAKE) -j 8 all
 	-$(MAKE) -j 8 static
+	$(MAKE) -j 8 $(progs_extra)
 
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
@@ -266,7 +270,8 @@ clean: $(CLEANDIRS)
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
 	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
 	      version.h $(check_defs) \
-	      $(libs) $(lib_links)
+	      $(libs) $(lib_links) \
+	      $(progs_extra)
 
 clean-doc:
 	@echo "Cleaning Documentation"
-- 
1.8.4.5

