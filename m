Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:52839 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751032AbaH3MsQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Aug 2014 08:48:16 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-btrfs@vger.kernel.org
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 1/2] Add support for DISABLE_DOCUMENTATION
Date: Sat, 30 Aug 2014 14:48:09 +0200
Message-Id: <1409402890-22860-2-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1409402890-22860-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1409402890-22860-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gustavo Zacarias <gustavo@zacarias.com.ar>

This commit adds the support for a make variable named
"DISABLE_DOCUMENTATION", which allows to disable the build of the
documentation. This is useful in contexts where the tools needed to
build the documentation are not necessarily available.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 Makefile | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e721e99..926885f 100644
--- a/Makefile
+++ b/Makefile
@@ -57,10 +57,15 @@ btrfs_image_libs = -lpthread
 btrfs_fragments_libs = -lgd -lpng -ljpeg -lfreetype
 
 SUBDIRS =
-BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS)) build-Documentation
-INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS)) install-Documentation
+BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
+INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
+ifneq ($(DISABLE_DOCUMENTATION),1)
+BUILDDIRS += build-Documentation
+INSTALLDIRS += install-Documentation
+endif
+
 .PHONY: $(SUBDIRS)
 .PHONY: $(BUILDDIRS)
 .PHONY: $(INSTALLDIRS)
-- 
2.0.0

