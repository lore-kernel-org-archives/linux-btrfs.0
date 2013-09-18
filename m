Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3IRB4a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 21:56:30 -0400
Message-ID: <5239084D.4020802@redhat.com>
Date: Tue, 17 Sep 2013 20:56:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: rongqing.li@windriver.com
CC: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Add version.h dependency to fix parallel builds
References: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com>
In-Reply-To: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the suffix rule to ensure that version.h is 
built before we try to create any .o file.

Reported-by: Roy Li <rongqing.li@windriver.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I dunno, does this work?  My gnu make is rusty.

diff --git a/Makefile b/Makefile
index 3d715d8..d25054f 100644
--- a/Makefile
+++ b/Makefile
@@ -107,13 +107,13 @@ endif
 %.o.d: %.c
 	$(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
 
-.c.o:
+%.o: %.c version.h
 	@$(check_echo) "    [SP]     $<"
 	$(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(AM_CFLAGS) $(CFLAGS) -c $<
 
-%.static.o: %.c
+%.static.o: %.c version.h
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
 
