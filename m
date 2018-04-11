Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:61148 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbeDKI30 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 04:29:26 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D6C18AC0231
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 17:29:20 +0900 (JST)
Received: from G01JPEXCHYT13.g01.fujitsu.local (G01JPEXCHYT13.g01.fujitsu.local [10.128.194.52])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 3F0DF584319
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 17:29:20 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: configure: check if xmlto exists at configure
 time
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <29b3fdcb-afbc-b3b3-41c3-825f778ccecd@jp.fujitsu.com>
Date: Wed, 11 Apr 2018 17:29:00 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

AC_PATH_PROG won't fail even if it fails to find command path.
xmlto is required for document build and we should report error
if it doesn't exist at configure time.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 configure.ac | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index af13a959..a4c98b31 100644
--- a/configure.ac
+++ b/configure.ac
@@ -93,7 +93,11 @@ AC_SUBST([DISABLE_DOCUMENTATION])
 dnl detect tools to build documentation
 ASCIIDOC_TOOL="none"
 if test "x$enable_documentation" = xyes; then
-	AC_PATH_PROG([XMLTO], [xmlto], [xmlto])
+	AC_PATH_PROG([XMLTO], [xmlto])
+	if test -z "$XMLTO"; then
+		AC_MSG_ERROR([cannot find xmlto, cannot build documentation])
+	fi
+
 	AC_PATH_PROG([GZIP], [gzip], [gzip])
 	AC_PATH_PROG([MV], [mv], [mv])
 	AC_PROG_SED
-- 
2.14.3


