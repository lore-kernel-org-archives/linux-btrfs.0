Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967595AbaLLMgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:14 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCaEXX018443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:14 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 10/10] btrfs-progs: add --disable-documentation
Date: Fri, 12 Dec 2014 13:35:24 +0100
Message-Id: <1418387724-20188-11-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 Makefile.in  | 1 +
 configure.ac | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/Makefile.in b/Makefile.in
index bdd7683..5889224 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -5,6 +5,7 @@ CC = @CC@
 LN_S = @LN_S@
 AR = @AR@
 INSTALL = @INSTALL@
+DISABLE_DOCUMENTATION = @DISABLE_DOCUMENTATION@
 
 # Non-static compilation flags
 CFLAGS = @CFLAGS@ \
diff --git a/configure.ac b/configure.ac
index 290d022..79cb591 100644
--- a/configure.ac
+++ b/configure.ac
@@ -66,6 +66,15 @@ AS_IF([test "x$enable_backtrace" = xno], [
   AC_DEFINE([BTRFS_DISABLE_BACKTRACE], [1], [disable backtrace stuff in kerncompat.h ])
 ])
 
+
+AC_ARG_ENABLE([documentation],
+	      AS_HELP_STRING([--disable-documentation], [do not build domumentation]),
+  [], [enable_documentation=yes]
+)
+AS_IF([test "x$enable_documentation" = xyes], [DISABLE_DOCUMENTATION=0], [DISABLE_DOCUMENTATION=1])
+AC_SUBST([DISABLE_DOCUMENTATION])
+
+
 dnl Define <NAME>_LIBS= and <NAME>_CFLAGS= by pkg-config
 dnl
 dnl The default PKG_CHECK_MODULES() action-if-not-found is end the
-- 
1.9.3

