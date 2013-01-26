Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:49987 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab3AZAWH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 19:22:07 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id CB31540C036
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Jan 2013 01:13:42 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH] [RFC] Add static compile target
Date: Sat, 26 Jan 2013 01:09:47 +0100
Message-Id: <1359158987-19921-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes, when you least expect it, a static binary is what you need to
rescue your data... Or just get a good enough handle on things to make
it work again ;)

"make static" is a gift to you, dear user with filesystem problems!
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 4894903..9148d0b 100644
--- a/Makefile
+++ b/Makefile
@@ -117,4 +117,8 @@ install: $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
 
+static: CFLAGS += -static
+static: LIBS += -lpthread
+static: all
+
 -include .*.d
-- 
1.8.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
