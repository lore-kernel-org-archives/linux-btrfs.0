Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaKGRGZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 12:06:25 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CDDC4AC89
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 17:06:23 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/5] btrfs-progs: build, add make target for a build test
Date: Fri,  7 Nov 2014 18:06:22 +0100
Message-Id: <86be0aeaf638b1b2c0dd453ff30d4dadd96250ef.1415379676.git.dsterba@suse.cz>
In-Reply-To: <cover.1415379676.git.dsterba@suse.cz>
References: <cover.1415379676.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A quick check that everything still builds.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index 99b03658a406..126dc593ddfb 100644
--- a/Makefile
+++ b/Makefile
@@ -248,6 +248,13 @@ library-test.static: $(libs_static) library-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o library-test-static library-test.o $(LDFLAGS) $(libs_static)
 
+test-build:
+	$(MAKE) clean-all
+	$(MAKE) library-test
+	-$(MAKE) library-test.static
+	$(MAKE) -j 8 all
+	-$(MAKE) -j 8 static
+
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
 
-- 
1.8.4.5

