Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41207 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbbCYAzq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 20:55:46 -0400
Received: from naomi.gilbertsystems.net (d192-24-148-25.try.wideopenwest.com [24.192.25.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: floppym)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 824FE3408A3
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 00:55:45 +0000 (UTC)
From: Mike Gilbert <floppym@gentoo.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Fix autoconf handling of --enable-convert
Date: Tue, 24 Mar 2015 20:55:41 -0400
Message-Id: <1427244941-3896-1-git-send-email-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

AC_ARG_ENABLE(convert) sets $enable_convert, not $enable_btrfsconvert.

Signed-off-by: Mike Gilbert <floppym@gentoo.org>
---
 configure.ac | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0692d5a..1171ed7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -94,13 +94,13 @@ fi
 
 AC_ARG_ENABLE([convert],
 	      AS_HELP_STRING([--disable-convert], [do not build btrfs-convert]),
-  [], [enable_btrfsconvert=yes]
+  [], [enable_convert=yes]
 )
 
-AS_IF([test "x$enable_btrfsconvert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFSCONVERT=1])
+AS_IF([test "x$enable_convert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFSCONVERT=1])
 AC_SUBST([DISABLE_BTRFSCONVERT])
 
-if test "x$enable_btrfsconvert" = xyes; then
+if test "x$enable_convert" = xyes; then
 	PKG_CHECK_MODULES(EXT2FS, [ext2fs])
 	PKG_CHECK_MODULES(COM_ERR, [com_err])
 fi
@@ -163,7 +163,7 @@ AC_MSG_RESULT([
 
 	documentaton:      ${enable_documentation}
 	backtrace support: ${enable_backtrace}
-	btrfs-convert:     ${enable_btrfsconvert}
+	btrfs-convert:     ${enable_convert}
 
 	Type 'make' to compile.
 ])
-- 
2.3.3

