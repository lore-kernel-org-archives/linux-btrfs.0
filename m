Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:48934 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3AYXUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 18:20:17 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 2BEF140C020
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Jan 2013 00:20:15 +0100 (CET)
Date: Sat, 26 Jan 2013 00:20:14 +0100
From: Ian Kumlien <pomac@vapor.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC] add static compile target to make file
Message-ID: <20130125232014.GC15780@pomac.netswarm.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LpQ9ahxlCli8rRTG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi, 

This is something i have been hacking in several times when i have had
odd issues or had to use a special version of btrfs-progs to handle
issues.

Anyway, thought i'd send something generic enough for everyone =).

--LpQ9ahxlCli8rRTG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-RFC-Add-static-compile-target.patch"

>From 42f4bae2d2e8ee4a46a36454f7d9e3c63a6284d2 Mon Sep 17 00:00:00 2001
From: Ian Kumlien <pomac@demius.net>
Date: Sat, 26 Jan 2013 00:12:28 +0100
Subject: [PATCH] [RFC] Add static compile target

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


--LpQ9ahxlCli8rRTG--
