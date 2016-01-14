Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:53415 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbcANKSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 05:18:07 -0500
Received: from naomi.gilbertsystems.net (d192-24-148-25.try.wideopenwest.com [24.192.25.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: floppym)
	by smtp.gentoo.org (Postfix) with ESMTPSA id B8D32340AA1
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 10:18:06 +0000 (UTC)
From: Mike Gilbert <floppym@gentoo.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Use AC_CHECK_TOOL to find AR
Date: Thu, 14 Jan 2016 05:18:03 -0500
Message-Id: <1452766683-17982-1-git-send-email-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

AC_CHECK_TOOL takes the --host option into account for cross-compiling.

Signed-off-by: Mike Gilbert <floppym@gentoo.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c114097..fc343ea 100644
--- a/configure.ac
+++ b/configure.ac
@@ -35,7 +35,7 @@ AC_SYS_LARGEFILE
 
 AC_PROG_INSTALL
 AC_PROG_LN_S
-AC_PATH_PROG([AR], [ar])
+AC_CHECK_TOOL([AR], [ar])
 AC_PATH_PROG([RM], [rm], [rm])
 AC_PATH_PROG([RMDIR], [rmdir], [rmdir])
 
-- 
2.7.0

