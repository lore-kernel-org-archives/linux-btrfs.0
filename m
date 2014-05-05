Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbaEEOyC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 10:54:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 66DAAAD23
	for <linux-btrfs@vger.kernel.org>; Mon,  5 May 2014 14:54:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: doc: fix symlink target for btrfsck.8
Date: Mon,  5 May 2014 16:54:00 +0200
Message-Id: <1399301640-31846-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The manpage of btrfsck.8 is supposed to link to btrfs-check.8 .

Reported-by: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index e22f5bca0ff2..e3ad34133832 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -74,7 +74,7 @@ install: install-man
 install-man: man
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
 	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
-	$(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)
+	$(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz
 
 clean:
 	$(RM) *.xml *.xml+ *.8 *.8.gz
-- 
1.9.0

