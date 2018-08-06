Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35622 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbeHFXFZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 19:05:25 -0400
Received: from naomi.gilbertsystems.net (unknown [24.192.26.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: floppym)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 60172335CA5
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 20:54:35 +0000 (UTC)
From: Mike Gilbert <floppym@gentoo.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Install btrfs-ioctl.3 man page
Date: Mon,  6 Aug 2018 16:54:32 -0400
Message-Id: <20180806205432.11009-2-floppym@gentoo.org>
In-Reply-To: <20180806205432.11009-1-floppym@gentoo.org>
References: <20180806205432.11009-1-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 Documentation/Makefile.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index c4c843cb..5bc0d80d 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -94,8 +94,10 @@ html: $(MAN_HTML)
 install: install-man
 
 install-man: man
+	$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir)
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
+	$(INSTALL) -m 644 $(MAN3) $(DESTDIR)$(man3dir)
 	$(INSTALL) -m 644 $(MAN5) $(DESTDIR)$(man5dir)
 	# the source file name of btrfs.5 clashes with section 8 page, but we
 	# want to keep the code generic
-- 
2.18.0

