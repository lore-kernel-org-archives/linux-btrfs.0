Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab3AaMuy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 07:50:54 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id D0D61A3CEE
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 13:50:53 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix parallel build
Date: Thu, 31 Jan 2013 13:50:52 +0100
Message-Id: <1359636652-20586-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Parallel build may fail due to late creation of version.h, fix the rule name
that does not match the filename.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 6df402c..bef1e13 100644
--- a/Makefile
+++ b/Makefile
@@ -52,9 +52,9 @@ endif
 	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
 
 
-all: version $(progs) manpages
+all: version.h $(progs) manpages
 
-version:
+version.h:
 	$(Q)bash version.sh
 
 btrfs: $(objects) btrfs.o help.o $(cmds_objects)
-- 
1.8.0.2

