Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaKGRGb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 12:06:31 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 01D00AC89
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 17:06:30 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/5] btrfs-progs: build, update the clean rule
Date: Fri,  7 Nov 2014 18:06:29 +0100
Message-Id: <6d95e999adabf96421a99b9ac943defd1e5559d3.1415379676.git.dsterba@suse.cz>
In-Reply-To: <cover.1415379676.git.dsterba@suse.cz>
References: <cover.1415379676.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove duplicate files, add extra progs, add library test binaries.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index b597ad8e9b89..4cae30c179b5 100644
--- a/Makefile
+++ b/Makefile
@@ -266,12 +266,12 @@ clean-all: clean-doc clean
 
 clean: $(CLEANDIRS)
 	@echo "Cleaning"
-	$(Q)rm -f $(progs) cscope.out *.o *.o.d btrfs-convert btrfs-image btrfs-select-super \
-	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
-	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
+	$(Q)rm -f $(progs) cscope.out *.o *.o.d \
+	      dir-test ioctl-test quick-test send-test library-test library-test-static \
+	      btrfs.static mkfs.btrfs.static \
 	      version.h $(check_defs) \
 	      $(libs) $(lib_links) \
-	      $(progs_extra)
+	      $(progs_static) $(progs_extra)
 
 clean-doc:
 	@echo "Cleaning Documentation"
-- 
1.8.4.5

